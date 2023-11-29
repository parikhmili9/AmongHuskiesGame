import bindbc.sdl;
import sprite;

struct Player{

    Sprite playerSprite;

    this(SDL_Renderer* renderer, string filepath, int startX, int startY){
        playerSprite = Sprite(renderer, filepath, startX, startY);
    }

    int getX(){
        return playerSprite.xPos;
    }
    int getY(){
        return playerSprite.yPos;
    }

    void moveUp(){
        playerSprite.yPos -=16;
        playerSprite.mState = STATE.WALK_UP;
    }
    void moveDown(){
        playerSprite.yPos +=16;
        playerSprite.mState = STATE.WALK_DOWN;
    }
    void moveLeft(){
        playerSprite.xPos -=16;
        playerSprite.mState = STATE.WALK_LEFT;
    }
    void moveRight(){
        playerSprite.xPos +=16;
        playerSprite.mState = STATE.WALK_RIGHT;
    }

    void render(SDL_Renderer* renderer){
        playerSprite.render(renderer);
        playerSprite.mState = STATE.IDLE;
    }
}
