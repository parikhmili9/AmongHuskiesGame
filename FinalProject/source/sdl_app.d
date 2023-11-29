module sdl_app;

// Import D standard libraries
import std.stdio;
import std.string;

import tile_map: TileMap;
import tile_set: TileSet;
import player;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

class SDLApp{

    bool runApplication = true;
    
    SDL_Event e;
    SDLSupport ret;
    SDL_Window* window;
    SDL_Renderer* renderer;

    this() {
        // OS checking for proper SDL library
        version(Windows){
            writeln("Searching for SDL on Windows");
            ret = loadSDL("SDL2.dll");
        }
        version(OSX){
            writeln("Searching for SDL on Mac");
            ret = loadSDL();
        }
        version(linux){ 
            writeln("Searching for SDL on Linux");
            ret = loadSDL();
        }

        // Error if SDL cannot be loaded
        if(ret != sdlSupport){
            writeln("error loading SDL library");
            
            foreach( info; loader.errors){
                writeln(info.error,':', info.message);
            }
        }
        if(ret == SDLSupport.noLibrary){
            writeln("error no library found");    
        }
        if(ret == SDLSupport.badLibrary){
            writeln(
                "Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?"
            );
        }

        // Initialize SDL
        if(SDL_Init(SDL_INIT_EVERYTHING) !=0){
            writeln("SDL_Init: ", fromStringz(SDL_GetError()));
        }


        // every SDL app will need a window and a surface
        const(char)* WINDOW_NAME = "AmongHuskies^TM HuskyTown".ptr;
        const int WINDOW_WIDTH = 960;
        const int WINDOW_HEIGHT = 960;
        this.window = SDL_CreateWindow(WINDOW_NAME,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  WINDOW_WIDTH,
                                  WINDOW_HEIGHT, 
                                  SDL_WINDOW_SHOWN
                                );
    }

    ~this(){
        // Destroy our window
        SDL_DestroyWindow(window);
        // Quit the SDL Application 
        SDL_Quit();
	    writeln("Ending application--good bye!");
    }

    void mainApplicationLoop(){ 
            const string TILEMAP_PATH = "./source/assets/tilemap.bmp";
            const string SPRITE_PATH = "./source/assets/test.bmp";

            const int TILE_SIZE = 32;
            const int X_TILES = 50;
            const int Y_TILES = 50;

            // Create a hardware accelerated renderer and load our tiles from an image
            this.renderer = null;
            this.renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
            TileSet tileSet = TileSet(renderer, TILEMAP_PATH, TILE_SIZE, X_TILES, Y_TILES);
            TileMap tileMap = TileMap(tileSet);

            // render the player
            Player player = Player(renderer, SPRITE_PATH);

            while(this.runApplication) {
            // Handle events
            // Events are pushed into an 'event queue' internally in SDL, and then
            // handled one at a time within this loop for as many events have
            // been pushed into the internal SDL queue. Thus, we poll until there
            // are '0' events or a NULL event is returned.
            while(SDL_PollEvent(&(this.e)) !=0) {
                if(e.type == SDL_QUIT){
                    runApplication= false;
                }
                // TODO (Ryan to handle this) - Handle events in the SDL application loop
                // Get Keyboard input
                const ubyte* keyboardState = SDL_GetKeyboardState(null);
                int playerX = player.getX();
                int playerY = player.getY();

                // (3) Clear and Draw the Screen
                // Gives us a clear "canvas"
                SDL_SetRenderDrawColor(renderer, 100, 190, 255, SDL_ALPHA_OPAQUE);
                SDL_RenderClear(renderer);

                // NOTE: The draw order here is very important
                //       We follow the 'painters algorithm' in 2D
                //       meaning that we draw the background first,
                //       and then our objects on top.

                // Render out DrawableTileMap and player
                int zoomFactor = 1;
                tileMap.render(renderer, zoomFactor);
                player.render(renderer);

                // Little frame capping hack so we don't run too fast
                SDL_Delay(125);

                // Finally show what we've drawn
                // (i.e. anything where we have called SDL_RenderCopy will be in memory and presnted here)
                SDL_RenderPresent(renderer);
            }
        }
    }
 }
