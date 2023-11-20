module sdl_app;

// Import D standard libraries
import std.stdio;
import std.string;

import surface: Surface;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

class SDLApp{

    bool runApplication = true;
    
    SDL_Event e;
    SDL_Window* window;
    Surface imgSurface;
    SDLSupport ret;

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
        int WINDOW_WIDTH = 640;
        int WINDOW_HEIGHT = 480;
        window = SDL_CreateWindow(WINDOW_NAME,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  WINDOW_WIDTH,
                                  WINDOW_HEIGHT, 
                                  SDL_WINDOW_SHOWN
                                );
        imgSurface = Surface(WINDOW_HEIGHT, WINDOW_WIDTH);
    }

    ~this(){
        // Destroy our window
        SDL_DestroyWindow(window);
        // Quit the SDL Application 
        SDL_Quit();
	    writeln("Ending application--good bye!");
    }

    void mainApplicationLoop(){ 

            while(this.runApplication) {
            // Handle events
            // Events are pushed into an 'event queue' internally in SDL, and then
            // handled one at a time within this loop for as many events have
            // been pushed into the internal SDL queue. Thus, we poll until there
            // are '0' events or a NULL event is returned.
            while(SDL_PollEvent(&e) !=0) {
                if(e.type == SDL_QUIT){
                    runApplication= false;
                }
                // TODO (Ryan to handle this) - Handle events in the SDL application loop
                // Get Keyboard input
                const ubyte* keyboard = SDL_GetKeyboardState(null);

                // player movement cases
                
            }

            imgSurface.blitSurfaceToWindow(window);
            // Delay for 16 milliseconds
            // Otherwise the program refreshes too quickly
            SDL_Delay(16);
        }
    }
 }
