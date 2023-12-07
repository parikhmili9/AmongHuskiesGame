module client.source.graphics.husky.husky;

import std.stdio;

import bindbc.sdl;
import client.source.graphics.husky.husky_sprite;
import client.source.packet.client_packet : ClientPacket;

struct Husky
{

    HuskySprite huskySprite;
    char husky_id;
    const int TILE_TO_PIXEL = 32;

    this(SDL_Renderer* renderer, string filepath, int startX, int startY, char husky_id)
    {
        huskySprite = HuskySprite(renderer, filepath, startX, startY, 32);
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

    void render(SDL_Renderer* renderer)
    {
        huskySprite.render(renderer);
    }

    char getId()
    {
        return this.husky_id;
    }

    void setPositionFromTileValues(int[2] huskyCoords){
        auto newX = convertToPixels(huskyCoords[0]);
        auto newY = convertToPixels(huskyCoords[1]);
        this.moveHusky(newX, newY);
    }

    // First, we need to know which direction the sprite is moving so that we can set the state.
    // Then, we can move to the target and update the state value.
    void moveHusky(int targetX, int targetY){
        huskySprite.xPos = targetX;
        huskySprite.yPos = targetY;
    }

    int convertToPixels(int tileValue){
        return TILE_TO_PIXEL * tileValue;
    }
}
