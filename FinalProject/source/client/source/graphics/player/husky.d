module client.source.graphics.player.husky;

import std.stdio;

import bindbc.sdl;
import client.source.graphics.player.sprite;
import client.source.packet.client_packet : ClientPacket;

struct Husky
{

    Sprite huskySprite;
    char husky_id;
    const int TILE_TO_PIXEL = 32;

    this(SDL_Renderer* renderer, string filepath, int startX, int startY, char husky_id)
    {
        huskySprite = Sprite(renderer, filepath, startX, startY,32);
        this.husky_id = husky_id;
    }

    int getX()
    {
        return huskySprite.xPos;
    }

    int getY()
    {
        return huskySprite.yPos;
    }

    void moveUp()
    {
        huskySprite.yPos -= 16;
        huskySprite.mState = STATE.WALK_UP;
    }

    void moveDown()
    {
        huskySprite.yPos += 16;
        huskySprite.mState = STATE.WALK_DOWN;
    }

    void moveLeft()
    {
        huskySprite.xPos -= 16;
        huskySprite.mState = STATE.WALK_LEFT;
    }

    void moveRight()
    {
        huskySprite.xPos += 16;
        huskySprite.mState = STATE.WALK_RIGHT;
    }

    void render(SDL_Renderer* renderer)
    {
        huskySprite.render(renderer);
        huskySprite.mState = STATE.IDLE;
    }

    char getId()
    {
        return this.husky_id;
    }

    void setPositionFromTileValues(int[2] huskyCoords){
        auto newX = convertToPixels(huskyCoords[0]);
        auto newY = convertToPixels(huskyCoords[1]);

    }

    int convertToPixels(int tileValue){
        return TILE_TO_PIXEL * tileValue;
    }
}
