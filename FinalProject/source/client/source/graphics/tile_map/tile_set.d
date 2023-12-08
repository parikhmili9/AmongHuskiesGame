module client.source.graphics.tile_map.tile_set;

// Load the SDL2 library
import bindbc.sdl;

/** 
 * TileSet struct is passed to tileMap for rendering. This tileSet stores bmp tiles
 * loaded from a bmp file
 */
struct TileSet
{

    // Rectangle storing a specific tile at an index
    SDL_Rect[] mRectTiles;
    // The full texture loaded onto the GPU of the entire
    // tile map.
    SDL_Texture* mTexture;
    // Tile dimensions (assumed to be square)
    int mTileSize;
    // Number of tiles in the tilemap in the x-dimension
    int mXTiles;
    // Number of tiles in the tilemap in the y-dimension
    int mYTiles;

    /**
    * 
    *
    * params:
    *   - [name]
    */

    /**
    * Constructor for the TileSet class.
    *
    * params:
    *   - renderer: The SDL Renderer to render this tile_set.
    *   - filepath: The filepath to the image that represents this tile_set
    *   - tileSize: the size of the tiles in this tile_set, in pixels
    *   - xTiles: the number of tiles in the x dimension of this tile_set
    *   - yTiles: the number of tiles in the y dimension of this tile_set
    */
    this(SDL_Renderer* renderer, string filepath, int tileSize, int xTiles, int yTiles)
    {
        mTileSize = tileSize;
        mXTiles = xTiles;
        mYTiles = yTiles;

        // Load the bitmap surface
        SDL_Surface* myTestImage = SDL_LoadBMP(filepath.ptr);
        // Create a texture from the surface
        mTexture = SDL_CreateTextureFromSurface(renderer, myTestImage);
        // Done with the bitmap surface pixels after we create the texture, we have
        // effectively updated memory to GPU texture.
        SDL_FreeSurface(myTestImage);

        // Populate a series of rectangles with individual tiles
        for (int y = 0; y < yTiles; y++)
        {
            for (int x = 0; x < xTiles; x++)
            {
                SDL_Rect rect;
                rect.x = x * tileSize;
                rect.y = y * tileSize;
                rect.w = tileSize;
                rect.h = tileSize;

                mRectTiles ~= rect;
            }
        }
    }

    /**
    * Draw a specific tile from our tilemap.
    *
    * params:
    *   - renderer: The SDL Renderer to render this tile_set.
    *   - tile: the index of this tile in the tile_set
    *   - x: the x position of this tile on the screen
    *   - y: the y position of this tile on the screen
    *   - zoomFactor: the level of zoom we have applied to this tileset (optional, default = 1)
    */
    void renderTile(SDL_Renderer* renderer, int tile, int x, int y, int zoomFactor = 1)
    {
        if (tile > mRectTiles.length - 1)
        {
            // NOTE: Could use 'logger' here to log an error
            return;
        }

        // Select a specific tile from our
        // tiemap texture, by offsetting correcting
        // into the tilemap
        SDL_Rect selection = mRectTiles[tile];

        // Tile to draw out on
        SDL_Rect rect;
        rect.x = mTileSize * x * zoomFactor;
        rect.y = mTileSize * y * zoomFactor;
        rect.w = mTileSize * zoomFactor;
        rect.h = mTileSize * zoomFactor;

        // Copy tile to our renderer
        SDL_RenderCopy(renderer, mTexture, &selection, &rect);
    }
}
