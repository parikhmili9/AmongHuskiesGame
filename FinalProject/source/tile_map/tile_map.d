module tile_map.tile_map;

import consts: tile_map_x_size;

import bindbc.sdl;

// Load the SDL2 library
import bindbc.sdl;

/// DrawableTilemap is responsible for drawing 
/// the actual tiles for the tilemap data structure
struct DrawableTileMap{
    const int mMapXSize = 8;
    const int mMapYSize = 8;
 
    // Tile map with tiles
    TileSet mapTileSet;

    // Static array for now for simplicity}
    int [mMapXSize][mMapYSize] mTiles;

    // Set the tileset
    this(TileSet t){
        // Set our tilemap
        mapTileSet = t;

        // Set all tiles to 'default' tile
        for(int y=0; y < mMapYSize; y++){
            for(int x=0; x < mMapXSize; x++){
                if(y==0){
                   mTiles[x][y] = 33;
                } 
                else if(y==mMapYSize-1){
                    mTiles[x][y] = 107;
                } 
                else if(x==0){
                    mTiles[x][y] = 69;
                } 
                else if(x==mMapXSize-1){
                    mTiles[x][y] = 71;
                } 
                else{
                    // Deafult tile
                    mTiles[x][y] = 966;
                }
            }
        }

        // Adjust the corners
        // todo -> create constants
        mTiles[0][0] = 32;
        mTiles[mMapXSize-1][0] = 34;
        mTiles[0][mMapYSize-1] = 106;
        mTiles[mMapXSize-1][mMapYSize-1] = 108;
    }
 
    void render(SDL_Renderer* renderer, int zoomFactor=1){
        for(int y=0; y < mMapYSize; y++){
            for(int x=0; x < mMapXSize; x++){
                mapTileSet.renderTile(renderer, mTiles[x][y], x, y, zoomFactor);
            }
        }
    }

    // Specify a position local coorindate on the window
    int getTileAt(int localX, int localY, int zoomFactor=1){
        int x = localX / (mapTileSet.mTileSize * zoomFactor);
        int y = localY / (mapTileSet.mTileSize * zoomFactor);

        if(x < 0 || y < 0 || x> mMapXSize-1 || y > mMapYSize-1 ){
            // TODO: Perhaps log error?
            // Maybe throw an exception -- think if this is possible!
            // You decide the proper mechanism!
            return -1;
        }

        return mTiles[x][y]; 
    }
}