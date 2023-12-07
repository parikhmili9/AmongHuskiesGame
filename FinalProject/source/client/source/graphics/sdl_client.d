module source.graphics.sdl_client;

// Import D standard libraries
import std.stdio;
import std.string;
import core.thread.osthread;

import client.source.graphics.tile_map.tile_map : TileMap;
import client.source.graphics.tile_map.tile_set : TileSet;
import client.source.graphics.player.player;
import client.source.packet.client_packet : ClientPacket;
import client.source.client : TCPClient;
import client.source.packet.packet: Packet;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

class SDLClient
{

    bool runApplication = true;
    int zoomFactor = 1;
    TCPClient tcp;
    Packet current_server_packet;
    char self_id;
    SDL_Event e;
    SDLSupport ret;
    SDL_Window* window;
    SDL_Renderer* renderer;

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

        new Thread({ tcp_client_loop(); }).start();
        // every SDL app will need a window and a surface
        // todo - add params 
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

    ~this()
    {
        // Destroy our window
        SDL_DestroyWindow(window);
        // Quit the SDL Application 
        SDL_Quit();
        writeln("Ending application--good bye!");
    }

    /// Writing an independent TCP client loop

    void tcp_client_loop(){
        tcp = new TCPClient();
        self_id = tcp.intitalize_self();
        writeln("Your Player ID is: ", self_id);
        auto temp = tcp.server_packet_recieved();
        if (temp.player1Coords != [-999,-999]){
            current_server_packet = temp;
            writeln(current_server_packet);
        } 

    }

    /**
    * 
    **/
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

    void mainApplicationLoop()
    {

        // enumerate asset paths
        const string TILEMAP_PATH = "./assets/grid.bmp";
        const string STANDARD_BLUE_SPRITE_PATH = "./assets/dark_blue_player_sprites.bmp";
        const string STANDARD_RED_SPRITE_PATH = "./assets/red_player_sprites.bmp";
        const string ACTIVE_ORANGE_SPRITE_PATH = "./assets/orange_player_sprites.bmp";
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

        // TODO - UN-HARDCODE THIS; USE DATA FROM THE SERVER
        // Render 4 characters, 2 for each team
        Player player1 = Player(renderer, STANDARD_BLUE_SPRITE_PATH, 0, 0, 'A');
        Player player2 = Player(renderer, STANDARD_BLUE_SPRITE_PATH, 32, 0, 'B');
        Player player3 = Player(renderer, STANDARD_RED_SPRITE_PATH, 64, 0, 'C');
        Player player4 = Player(renderer, STANDARD_RED_SPRITE_PATH, 32 * 10, 32 * 6, 'D');

        while (this.runApplication)
        {
            // Handle events
            while (SDL_PollEvent(&(this.e)) != 0)
            {
                if (e.type == SDL_QUIT)
                {
                    runApplication = false;
                }
                // Get Keyboard input
                const ubyte* keyboardState = SDL_GetKeyboardState(null);
                // send_movement_client_packet(keyboardState, self_id);

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

                // Little frame capping hack so we don't run too fast
                SDL_Delay(125); // Finally show what we've drawn
                // (i.e. anything where we have called SDL_RenderCopy will be in memory and presnted here)
                SDL_RenderPresent(renderer);
            }
        }
    }
}
