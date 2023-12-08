module source.graphics.sdl_client;

// Import D standard libraries
import std.stdio;
import std.string;
import core.thread.osthread;
import std.concurrency;
import core.thread;

import client.source.graphics.tile_map.tile_map : TileMap;
import client.source.graphics.tile_map.tile_set : TileSet;
import client.source.graphics.player.player;
import client.source.graphics.husky.husky;
import client.source.packet.client_packet : ClientPacket;
import client.source.client : TCPClient;
import client.source.packet.packet: Packet;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


/**
* The main graphical application for our program.
*/
class SDLClient
{

    bool runApplication = true;
    bool endGame = true;
    bool player1Activated = false;
    bool player2Activated = false;
    bool player3Activated = false;
    bool player4Activated = false;
    int zoomFactor = 1;
    TCPClient tcp;
    Packet current_server_packet;
    char self_id;
    SDL_Event e;
    SDLSupport ret;
    SDL_Window* window;
    SDL_Renderer* renderer;

    /**
    * The constructor for the SDL_CLient.
    */ 
    this()
    {
        // OS checking for proper SDL library
        version (Windows)
        {
            writeln("Searching for SDL on Windows");
            ret = loadSDL("SDL2.dll");
        }
        version (OSX)
        {
            writeln("Searching for SDL on Mac");
            ret = loadSDL();
        }
        version (linux)
        {
            writeln("Searching for SDL on Linux");
            ret = loadSDL();
        }

        // Error if SDL cannot be loaded
        if (ret != sdlSupport)
        {
            writeln("error loading SDL library");

            foreach (info; loader.errors)
            {
                writeln(info.error, ':', info.message);
            }
        }
        if (ret == SDLSupport.noLibrary)
        {
            writeln("error no library found");
        }
        if (ret == SDLSupport.badLibrary)
        {
            writeln(
                "Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?"
            );
        }

        // Initialize SDL
        if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
        {
            writeln("SDL_Init: ", fromStringz(SDL_GetError()));
        }

        /// Make a new thread for TCP client. 
        tcp = new TCPClient();
        new Thread({ tcp_client_loop(); }).start();
        new Thread({ tcp.run(); }).start();

        const(char)* WINDOW_NAME = "AmongHuskies^TM HuskyTown".ptr;
        const int WINDOW_WIDTH = 640;
        const int WINDOW_HEIGHT = 800;
        this.window = SDL_CreateWindow(WINDOW_NAME,
            SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED,
            WINDOW_WIDTH,
            WINDOW_HEIGHT,
            SDL_WINDOW_SHOWN
        );
    }

    /// destructor
    ~this()
    {
        // Destroy our window
        SDL_DestroyWindow(window);
        // Quit the SDL Application 
        SDL_Quit();
        writeln("Ending application--good bye!");
    }



    /**
    * method called inside of the tcp client via a thread. This method handles * providing packets from the
    * server to this sdl_client via the tcp client.
    */
    void tcp_client_loop(){
        self_id = tcp.intitalize_self();
        writeln("Your Player ID is: ", self_id);

        while(this.runApplication){
            Packet temp;
            while(tcp.recieved_packets.size() != 0){
            temp = tcp.server_packet_recieved();
            }
            if (temp.player1Coords != [-999,-999] && !is_null_packet(temp)){
                if(temp.message != ""){
                    trim_and_print(temp.message);
                }
                this.current_server_packet = temp;

            }
        }
    }

    void trim_and_print(char[200] message){
        string toPrint;
        foreach(char c; message){
            int ascii_c = cast(int) c;
            if (c != '\0' && (ascii_c != 255)){
                toPrint ~= c;
            }
        }
        writeln(toPrint);
    }

    /**
    * Determines whether the packet received from the tcp client is null.
    * 
    * params:
    *   p: the packet in question
    */
    bool is_null_packet(Packet p){
        if(p.player1Coords == [0,0]
        && p.player2Coords == [0,0]
        && p.player3Coords == [0,0]
        && p.player4Coords == [0,0]){
            return true;
        }
        return false;
    }

    /**
    * Sends to the server a client_packet that expresses a move from this client.
    * 
    * params:
    *   keyboardState: The state of the keyboard
    *   player_id: The id of the player sending the move
    */
    void send_movement_client_packet(const ubyte* keyboardState, char player_id)
    {
        int playerMove = -1;
        if (keyboardState[SDL_SCANCODE_LEFT])
        {
            playerMove = 1;
        }
        else if (keyboardState[SDL_SCANCODE_RIGHT])
        {
            playerMove = 2;
        }
        else if (keyboardState[SDL_SCANCODE_UP])
        {
            playerMove = 3;
        }
        else if (keyboardState[SDL_SCANCODE_DOWN])
        {
            playerMove = 4;
        }

        ClientPacket cp;
        if (playerMove != -1)
        {
            // Send our client packet move.
            cp = ClientPacket(player_id, playerMove);
            tcp.sendMove(cp);
        }
    }

    /**
    * Updates the positions of the objects on the game board based on the current_server_packet.
    *
    * param:
    *   - renderer: The SDL renderer for the objects in question
    *   - player1: the object representing player1
    *   - player2:  the object representing player2
    *   - player3: the object representing player3
    *   - player4: the object representing player4
    *   - husky1: the object representing husky1
    *   - husky2: the object representing husky2
    */
    void updateObjectPositions(SDL_Renderer* renderer, ref Player player1, ref Player player2, ref Player player3,
    ref Player player4, ref Husky husky1, ref Husky husky2)
    {
        player1.setPositionFromTileValues(this.current_server_packet.player1Coords);
        player2.setPositionFromTileValues(this.current_server_packet.player2Coords);

        player3.setPositionFromTileValues(this.current_server_packet.player3Coords);
        player4.setPositionFromTileValues(this.current_server_packet.player4Coords);

        husky1.setPositionFromTileValues(this.current_server_packet.ball1Coords);
        husky2.setPositionFromTileValues(this.current_server_packet.ball2Coords);

        if (player1.isHoldingOpponentBall(
            this.current_server_packet.ball2Coords)){
                player1.markActive(renderer);
                player1Activated = true;
        } else if (player2.isHoldingOpponentBall(
        this.current_server_packet.ball2Coords)){
            player2.markActive(renderer);
            player2Activated = true;
        }

        if (player3.isHoldingOpponentBall(
        this.current_server_packet.ball1Coords)){
            player3.markActive(renderer);
            player3Activated = true;
        } else if (player4.isHoldingOpponentBall(
        this.current_server_packet.ball1Coords)){
            player4.markActive(renderer);
            player4Activated = true;
        }

    }

    /**
    * Checks if the game is over
    */ 
    void checkEndGame(){
        if(player1Activated && player2Activated){
            this.endGame = true;
            this.runApplication = false;
            writeln("Team Red Won!");
        }
        if(player3Activated && player4Activated){
            this.endGame = true;
            this.runApplication = false;
            write("Team Blue Won!");
        }
    }


    /**
    * The game loop.
    */ 
    void mainApplicationLoop()
    {
        // enumerate asset paths
        const string TILEMAP_PATH = "./assets/grid.bmp";
        const string STANDARD_BLUE_SPRITE_PATH = "./assets/light_blue_player_sprites.bmp";
        const string STANDARD_RED_SPRITE_PATH = "./assets/orange_player_sprites.bmp";
        const string ACTIVE_RED_SPRITE_PATH = "./assets/red_player_sprites.bmp";
        const string ACTIVE_BLUE_SPRITE_PATH = "./assets/dark_blue_player_sprites.bmp";
        const string HUSKY_SPRITE_BLUE = "./assets/blue_husky_sprite.bmp";
        const string HUSKY_SPRITE_RED = "./assets/red_husky_sprite.bmp";

        // describing the tile map
        const int TILE_SIZE = 32;
        const int X_TILES = 50;
        const int Y_TILES = 50;

        // Create a hardware accelerated renderer and load our tiles from an image
        this.renderer = null;
        this.renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

        // load in the tilemap and player assets from local storage
        TileSet tileSet = TileSet(renderer, TILEMAP_PATH, TILE_SIZE, X_TILES, Y_TILES);
        TileMap tileMap = TileMap(tileSet);

        // Render 4 characters, 2 for each team
        Player player1 = Player(renderer, STANDARD_RED_SPRITE_PATH,ACTIVE_RED_SPRITE_PATH, 0, 0, 'A');
        Player player2 = Player(renderer, STANDARD_RED_SPRITE_PATH,ACTIVE_RED_SPRITE_PATH, 32, 0, 'B');
        Player player3 = Player(renderer, STANDARD_BLUE_SPRITE_PATH, ACTIVE_BLUE_SPRITE_PATH, 64, 0, 'C');
        Player player4 = Player(renderer, STANDARD_BLUE_SPRITE_PATH,ACTIVE_BLUE_SPRITE_PATH, 32 * 10, 32 * 6, 'D');

        Husky husky1 = Husky(renderer, HUSKY_SPRITE_RED, 544, 128, 'R');
        Husky husky2 = Husky(renderer, HUSKY_SPRITE_BLUE, 544, 640, 'B');

        while (this.runApplication)
        {
            checkEndGame();

            if (!is_null_packet(this.current_server_packet)){
                updateObjectPositions(renderer, player1, player2, player3, player4, husky1, husky2);
            }
            // Handle events
            while (SDL_PollEvent(&(this.e)) != 0)
            {
                if (e.type == SDL_QUIT)
                {
                    runApplication = false;
                }
                // Get Keyboard input
                const ubyte* keyboardState = SDL_GetKeyboardState(null);
                send_movement_client_packet(keyboardState, self_id);

                // (3) Clear and Draw the Screen
                // Gives us a clear "canvas"
                SDL_SetRenderDrawColor(renderer, 100, 190, 255, SDL_ALPHA_OPAQUE);
                SDL_RenderClear(renderer); // NOTE: The draw order here is very important
                //       We follow the 'painters algorithm' in 2D
                //       meaning that we draw the background first,
                //       and then our objects on top.

                // Render out DrawableTileMap and player
                tileMap.render(renderer, zoomFactor);
                player1.render(renderer);
                player2.render(renderer);
                player3.render(renderer);
                player4.render(renderer);
                husky1.render(renderer);
                husky2.render(renderer);

                // Little frame capping hack so we don't run too fast
                SDL_Delay(125); // Finally show what we've drawn
                // (i.e. anything where we have called SDL_RenderCopy will be in memory and presnted here)
                SDL_RenderPresent(renderer);
            }
        }
        scope(exit) SDL_DestroyWindow(window);
        scope(exit) SDL_Quit();
    }
}
