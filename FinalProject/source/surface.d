module surface;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

/** **/
struct Surface {

  // Load the bitmap surface
  SDL_Surface* sdl_surface;
  uint bytesPerPixel;
  int pixelRowLength;
  int height;
  int width;

/** constructor **/
this(int width, int height) {

    // Constant surface args
    Uint32 FLAGS=0;
    int DEPTH=32;
    Uint32 RMASK=0;
    Uint32 GMASK=0;
    Uint32 BMASK=0;
    Uint32 AMASK=0;

    sdl_surface = SDL_CreateRGBSurface(
        FLAGS, width, height, DEPTH,
        RMASK, GMASK, BMASK, AMASK
    );

    // initialize this surface object's data from the created sdl_surface
    bytesPerPixel = sdl_surface.format.BytesPerPixel;
    pixelRowLength = sdl_surface.pitch;
    this.height = height;
    this.width = width;
}

    /** **/
    ~this(){
        SDL_FreeSurface(sdl_surface);
    }

    /** **/
    void blitSurfaceToWindow(SDL_Window* dst_window) {
        
        // convert the args to the type needed to call the SDL library functions
        SDL_Surface* window = SDL_GetWindowSurface(dst_window);
        
        // Blit the surace (i.e. update the window with another surfaces pixels
        //                       by copying those pixels onto the window).
        SDL_BlitSurface(sdl_surface, null, window, null);
        // Update the window surface
        SDL_UpdateWindowSurface(dst_window);
    }

    /** Function for updating the pixels in a surface to a 'blue-ish' color. **/
    void updateSurfacePixel(int xPos, int yPos, ubyte r, ubyte g, ubyte b){
            
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(sdl_surface);

        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(sdl_surface);

        // Retrieve the pixel arraay that we want to modify
        this.setPixelRgbValues(xPos, yPos, r, g, b);
    }

    /** Function for updating the pixels in a surface to a 'blue-ish' color. **/
    ubyte* getPixelArray() {
        ubyte* pixelArray = cast(ubyte*)sdl_surface.pixels;
        return pixelArray;
    }

    /** **/
    ubyte[] getPixelRgbValues(int xPos, int yPos) {
        ubyte* pixelArray = getPixelArray();
        ubyte r = pixelArray[yPos*pixelRowLength + xPos*bytesPerPixel + 0];
        ubyte g = pixelArray[yPos*pixelRowLength + xPos*bytesPerPixel + 1];
        ubyte b = pixelArray[yPos*pixelRowLength + xPos*bytesPerPixel + 2];
        return [r, g, b];
    }

    /** **/
    void setPixelRgbValues(int xPos, int yPos, ubyte r, ubyte g, ubyte b) {
        ubyte* pixelArray = cast(ubyte*)sdl_surface.pixels;
        pixelArray[yPos*pixelRowLength + xPos*bytesPerPixel + 0] = r;
        pixelArray[yPos*pixelRowLength + xPos*bytesPerPixel + 1] = g;
        pixelArray[yPos*pixelRowLength + xPos*bytesPerPixel + 2] = b;
    }
}