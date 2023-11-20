
module player;

// Load the SDL2 library
import bindbc.sdl;
import sprite;

struct Player{
    // Load our sprite
    Sprite mSprite;

    this(SDL_Renderer* renderer, string filepath){
        mSprite = Sprite(renderer,filepath);
    }

    int getX(){
        return mSprite.mXPos;
    }
    int getY(){
        return mSprite.mYPos;
    }

    void moveUp(){
        mSprite.mYPos -=16;
        mSprite.mState = STATE.WALK;
    }
    void moveDown(){
        mSprite.mYPos +=16;
        mSprite.mState = STATE.WALK;
    }
    void moveLeft(){
        mSprite.mXPos -=16;
        mSprite.mState = STATE.WALK;
    }
    void moveRight(){
        mSprite.mXPos +=16;
        mSprite.mState = STATE.WALK;
    }

    void render(SDL_Renderer* renderer){
        mSprite.Render(renderer);
        mSprite.mState = STATE.IDLE;
    }
}