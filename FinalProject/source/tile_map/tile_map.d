module tile_map;
import std.stdio;

// Load the SDL2 library
import tile_set : TileSet;
import bindbc.sdl;

// DrawableTilemap is responsible for drawing the world
struct TileMap
{
    const int MAP_X_SIZE = 50;
    const int MAP_Y_SIZE = 50;

    // Tile map with tiles
    TileSet mTileSet;

    // Static array for now for simplicity
    int[MAP_X_SIZE][MAP_Y_SIZE] mTiles;

    // Set the tileset
    this(TileSet t)
    {
        mTileSet = t;

        // Set all tiles to tiles from the tileset since we are drawing
        // it from a file
        for (int y = 0; y < MAP_Y_SIZE; y++)
        {
            for (int x = 0; x < MAP_X_SIZE; x++)
            {
                int selection = y * MAP_Y_SIZE + x;
                mTiles[x][y] = selection;
            }
        }
    }

    void render(SDL_Renderer* renderer, int zoomFactor = 1)
    {
        for (int y = 0; y < MAP_Y_SIZE; y++)
        {
            for (int x = 0; x < MAP_X_SIZE; x++)
            {
                mTileSet.renderTile(renderer, mTiles[x][y], x, y, zoomFactor);
            }
        }
    }

    // Specify a position local coorindate on the window
    int getTileAt(int localX, int localY, int zoomFactor = 1)
    {
        int x = localX / (mTileSet.mTileSize * zoomFactor);
        int y = localY / (mTileSet.mTileSize * zoomFactor);

        if (x < 0 || y < 0 || x > MAP_X_SIZE - 1 || y > MAP_Y_SIZE - 1)
        {
            // TODO: Perhaps log error?
            // Maybe throw an exception -- think if this is possible!
            // You decide the proper mechanism!
            return -1;
        }

        return mTiles[x][y];
    }
}
