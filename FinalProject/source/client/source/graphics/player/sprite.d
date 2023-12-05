module client.source.graphics.player.sprite;

// Load the SDL2 library
import bindbc.sdl;

/// Store state for sprites and very simple animation
enum STATE
{
	IDLE,
	WALK_DOWN,
	WALK_LEFT,
	WALK_RIGHT,
	WALK_UP
};

/// Sprite that holds a texture and position
struct Sprite
{

	int xPos;
	int yPos;
	int mFrame;
	int direction;
	STATE mState;
	SDL_Rect mRectangle;
	SDL_Texture* mTexture;

	this(SDL_Renderer* renderer, string filepath, int startX, int startY)
	{
		// Load the bitmap surface
		SDL_Surface* myTestImage = SDL_LoadBMP(filepath.ptr);
		// Create a texture from the surface
		mTexture = SDL_CreateTextureFromSurface(renderer, myTestImage);
		this.direction = 0;
		// Done with the bitmap surface pixels after we create the texture, we have
		// effectively updated memory to GPU texture.
		SDL_FreeSurface(myTestImage);

		// Rectangle is where we will represent the shape
		mRectangle.x = startX;
		mRectangle.y = startY;
		mRectangle.w = 64;
		mRectangle.h = 64;
	}

	void render(SDL_Renderer* renderer)
	{

		// Change the direction of the sprite if they change direction
		switch (mState)
		{
		case STATE.WALK_DOWN:
			this.direction = 0;
			break;
		case STATE.WALK_LEFT:
			this.direction = 1;
			break;
		case STATE.WALK_RIGHT:
			this.direction = 2;
			break;
		case STATE.WALK_UP:
			this.direction = 3;
			break;
		default:
			break;
		}

		SDL_Rect selection;
		selection.x = 64 * mFrame; // cycling through walking
		selection.y = 64 * this.direction; // determining direction of walk sprite
		selection.w = 64;
		selection.h = 64;

		mRectangle.x = xPos;
		mRectangle.y = yPos;

		SDL_RenderCopy(renderer, mTexture, &selection, &mRectangle);

		if (mState != STATE.IDLE)
		{
			mFrame++;
			if (mFrame > 3)
			{
				mFrame = 0;
			}
		}
	}
}
