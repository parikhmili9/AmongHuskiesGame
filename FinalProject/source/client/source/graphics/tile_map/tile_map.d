module client.source.graphics.tile_map.tile_map;
import std.stdio;

// Load the SDL2 library
import client.source.graphics.tile_map.tile_set : TileSet;
import bindbc.sdl;


/** 
 * DrawableTilemap is responsible for drawing the world
 */
struct TileMap
{
    const int MAP_X_SIZE = 50;
    const int MAP_Y_SIZE = 50;

    // Tile map with tiles
    TileSet mTileSet;

    // Static array for now for simplicity
    int[MAP_X_SIZE][MAP_Y_SIZE] mTiles;

    /**
    * Constructor for this tile_map.
    *
    * params:
    *   - t: the TileSet that will be used to create this tilemap
    */
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

    /**
    * Renders this tilemap.
    *
    * params:
    *   - renderer: The SDL Renderer to render this tile_set.
    *   - zoomFactor: the level of zoom being applied to this tileMap
    */
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
}
