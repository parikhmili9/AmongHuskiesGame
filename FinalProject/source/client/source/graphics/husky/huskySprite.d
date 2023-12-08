module client.source.graphics.husky.husky_sprite;
import std.stdio;

// Load the SDL2 library
import bindbc.sdl;

/** 
 * Sprite that holds a texture and position for husky.
 */
struct HuskySprite
{
	int xPos;
	int yPos;
	SDL_Rect mRectangle;
	SDL_Texture* mTexture;

	/**
	* Constructor for the husky sprite class.
	*
	* Params:
	*   - renderer: SDL renderer for rendering graphics.
	*   - filepath: Filepath to the sprite image.
	*   - startX: Initial X coordinate in pixels.
	*   - startY: Initial Y coordinate in pixels.
	*   - spritePixelSize: Optional parameter, size of the sprite in pixels (default: 149).
	*/
	this(SDL_Renderer* renderer, string filepath, int startX, int startY, int spritePixelSize=149)
	{
		// Load the bitmap surface
		SDL_Surface* myTestImage = SDL_LoadBMP(filepath.ptr);

		// Create a texture from the surface
		mTexture = SDL_CreateTextureFromSurface(renderer, myTestImage);

		// Done with the bitmap surface pixels after we create the texture, we have
		// effectively updated memory to GPU texture.
		SDL_FreeSurface(myTestImage);

		// Setting the sprite's starting location
		this.xPos = startX;
		this.yPos = startY;
		mRectangle.x = this.xPos;
		mRectangle.y = this.yPos;

		// setting the sprite's size
		mRectangle.w = spritePixelSize;
		mRectangle.h = spritePixelSize;
	}

	/**
    * Render the husky sprite to the screen.
    *
    * Params:
    *   - renderer: SDL renderer for rendering the husky.
    */
	void render(SDL_Renderer* renderer)
	{
		SDL_Rect selection;
		selection.x = 0;
		selection.y = 0;
		selection.w = 149;
		selection.h = 149;

		// Location on the tilemap that the sprite will be rendered
		mRectangle.x = xPos;
		mRectangle.y = yPos;

		SDL_RenderCopy(renderer, mTexture, &selection, &mRectangle);
	}
}
