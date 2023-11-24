module tile_map;


// Load the SDL2 library
import tile_set: TileSet;
import bindbc.sdl;

/// DrawableTilemap is responsible for drawing 
/// the actual tiles for the tilemap data structure
struct DrawableTileMap{
    const int MAP_X_SIZE = 8;
    const int MAP_Y_SIZE = 8;
 
    // Tile map with tiles
    TileSet mapTileSet;

    // Drawn map exists as static array for now (for simplicity)
    int [MAP_X_SIZE][MAP_Y_SIZE] mTiles;

    // Set the tileset
    this(TileSet t){
        // Set our tilemap
        mapTileSet = t;

        // Set all tiles to 'default' tile
        for(int y=0; y < MAP_Y_SIZE; y++){
            for(int x=0; x < MAP_X_SIZE; x++){
                if(y==0){
                   mTiles[x][y] = 33;
                } 
                else if(y==MAP_Y_SIZE-1){
                    mTiles[x][y] = 107;
                } 
                else if(x==0){
                    mTiles[x][y] = 69;
                } 
                else if(x==MAP_X_SIZE-1){
                    mTiles[x][y] = 71;
                } 
                else{
                    // Deafult tile
                    mTiles[x][y] = 966;
                }
            }
        }

        // Adjust the corners
        mTiles[0][0] = 32;
        mTiles[MAP_X_SIZE-1][0] = 34;
        mTiles[0][MAP_Y_SIZE-1] = 106;
        mTiles[MAP_X_SIZE-1][MAP_Y_SIZE-1] = 108;
    }
    /** 
    Render all the tiles in the tilemap. 
    Done by selecting each tile in the drawn tilemap and rendering it.
    **/
    void render(SDL_Renderer* renderer, int zoomFactor=1){
        for(int y=0; y < MAP_Y_SIZE; y++){
            for(int x=0; x < MAP_X_SIZE; x++){
                mapTileSet.renderTile(renderer, mTiles[x][y], x, y, zoomFactor);
            }
        }
    }

    // Specify a position local coorindate on the window
    int getTileAt(int localX, int localY, int zoomFactor=1){
        int x = localX / (mapTileSet.mTileSize * zoomFactor);
        int y = localY / (mapTileSet.mTileSize * zoomFactor);

        if(x < 0 || y < 0 || x> MAP_X_SIZE-1 || y > MAP_Y_SIZE-1 ){
            // TODO: Perhaps log error?
            // Maybe throw an exception -- think if this is possible!
            // You decide the proper mechanism!
            return -1;
        }

        return mTiles[x][y]; 
    }
}