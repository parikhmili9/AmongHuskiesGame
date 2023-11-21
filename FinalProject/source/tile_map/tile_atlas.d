module tile_atlas;

/** 
 * TileSet struct is passed to tileMap for rendering. This tileSet stores bmp tiles
 * loaded from a bmp file
 */
struct TileAtlas{

        // Rectangle storing a specific tile at an index
		SDL_Rect[] mRectTiles;
        // The full texture loaded onto the GPU of the entire tile map.
		SDL_Texture* mTexture;
        // Tile dimensions (assumed to be square)
        int mTileSize;
        // Number of tiles in the tilemap in the x-dimension
        int mXTiles;
        // Number of tiles in the tilemap in the y-dimension
        int mYTiles;

        /// Constructor
		this(SDL_Renderer* renderer, string filepath, int tileSize, int xTiles, int yTiles){
            mTileSize = tileSize;
            mXTiles   = xTiles;
            mYTiles   = yTiles;

			// Load the bitmap surface
			SDL_Surface* myTestImage   = SDL_LoadBMP(filepath.ptr);
			// Create a texture from the surface
			mTexture = SDL_CreateTextureFromSurface(renderer,myTestImage);

			// Done with the bitmap surface pixels after we create the texture, we have
			// effectively updated memory to GPU texture.
			SDL_FreeSurface(myTestImage);

            // Populate a series of rectangles with individual tiles
            for(int y = 0; y < yTiles; y++){
                for(int x = 0; x < xTiles; x++){
                    // create rectangle
                    SDL_Rect rect;
			        rect.x = x*tileSize;
        			rect.y = y*tileSize;
		        	rect.w = tileSize;
        			rect.h = tileSize;
                    // populate tilemap with rectangle
                    mRectTiles ~= rect;
                }
            }
		}

        /** Helper function that displays all of the tiles one after the other in an 
        animation. This is just a quick way to preview the tile **/
        void debugTiles(SDL_Renderer* renderer, int x, int y, int zoomFactor=1){
            import std.stdio;

			static int tilenum =0;

            if(tilenum > mRectTiles.length-1){
				tilenum = 0;
			}

            // Just a little helper for you to debug
            // You can omit this as necessary
            writeln("Showing tile number: ",tilenum);

            // Select a specific tile from our
            // tiemap texture, by offsetting correcting
            // into the tilemap
			SDL_Rect selection;
            selection = mRectTiles[tilenum];

            // Draw a preview of the actual tile
            SDL_Rect rect;
            rect.x = x;
            rect.y = y;
            rect.w = mTileSize * zoomFactor;
            rect.h = mTileSize * zoomFactor;

    	    SDL_RenderCopy(renderer, mTexture, &selection, &rect);
			tilenum++;
        }


        /// This is a handy helper function to tell you
        /// which tile your mouse is over.
        void tileSetSelector(SDL_Renderer* renderer){
            import std.stdio;
            
            int mouseX,mouseY;
            int mask = SDL_GetMouseState(&mouseX, &mouseY);

            int xTileSelected = mouseX / mTileSize;
            int yTileSelected = mouseY / mTileSize;
            int tilenum = yTileSelected * mXTiles + xTileSelected;
            if(tilenum > mRectTiles.length-1){
                return;
            }

            writeln("mouse  : ",mouseX,",",mouseY);
            writeln("tile   : ",xTileSelected,",",yTileSelected);
            writeln("tilenum: ",tilenum);

            SDL_SetRenderDrawColor(renderer, 255, 255, 255,255);

            // Tile to draw out on
            SDL_Rect rect = mRectTiles[tilenum];

            // Copy tile to our renderer
            // Note: We need a rectangle that's the exact dimensions of the
            //       image in order for it to render appropriately.
            SDL_Rect tilemap;
            tilemap.x = 0;
            tilemap.y = 0;
            tilemap.w = mXTiles * mTileSize;
            tilemap.h = mYTiles * mTileSize;
    	    SDL_RenderCopy(renderer, mTexture, null, &tilemap);
            // Draw a rectangle
            SDL_RenderDrawRect(renderer, &rect);

        }

        /// Draw a specific tile from our tilemap at pos[x,y]
		void renderTile(SDL_Renderer* renderer, int tile, int x, int y, int zoomFactor=1){
            if(tile > this.mRectTiles.length-1){
                // NOTE: Could use 'logger' here to log an error
                return;
            }

            // Select a specific tile from our
            // tiemap texture, by offsetting correcting
            // into the tilemap
			SDL_Rect selection = this.mRectTiles[tile];

            // Tile to draw out on
            SDL_Rect rect;
            rect.x = this.mTileSize * x * zoomFactor;
            rect.y = this.mTileSize * y * zoomFactor;
            rect.w = this.mTileSize * zoomFactor;
            rect.h = this.mTileSize * zoomFactor;
 
            // Copy tile to our renderer
    	    SDL_RenderCopy(renderer, mTexture, &selection, &rect);
		}
}