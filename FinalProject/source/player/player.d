import bindbc.sdl;
import sprite;

struct Player{

    Sprite playerSprite;

    this(SDL_Renderer* renderer, string filepath){
        playerSprite = Sprite(renderer,filepath);
    }

    int getX(){
        return playerSprite.xPos;
    }
    int getY(){
        return playerSprite.yPos;
    }

    void moveUp(){
        playerSprite.yPos -=16;
        playerSprite.mState = STATE.WALK;
    }
    void moveDown(){
        playerSprite.yPos +=16;
        playerSprite.mState = STATE.WALK;
    }
    void moveLeft(){
        playerSprite.xPos -=16;
        playerSprite.mState = STATE.WALK;
    }
    void moveRight(){
        playerSprite.xPos +=16;
        playerSprite.mState = STATE.WALK;
    }

    void render(SDL_Renderer* renderer){
        playerSprite.render(renderer);
        playerSprite.mState = STATE.IDLE;
    }
}
