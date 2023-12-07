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

    /**
    * Constructor for the Husky class.
    *
    * Params:
    *   - renderer: SDL renderer for rendering the husky.
    *   - filepath: Filepath to the sprite image.
    *   - startX: Initial X coordinate of the husky in pixels.
    *   - startY: Initial Y coordinate of the husky in pixels.
    *   - husky_id: Unique identifier for the husky.
    */
    this(SDL_Renderer* renderer, string filepath, int startX, int startY, char husky_id)
    {
        huskySprite = HuskySprite(renderer, filepath, startX, startY, 32);
        this.husky_id = husky_id;
    }


    /**
    * Render the husky sprite to the screen.
    *
    * Params:
    *   - renderer: SDL renderer for rendering the husky.
    */
    void render(SDL_Renderer* renderer)
    {
        huskySprite.render(renderer);
    }

    /**
    * Get the id of this husky
    */
    char getId()
    {
        return this.husky_id;
    }

    /**
    * Sets the position of this husky object on the tilemap.
    *
    * Params:
    *   - huskyCoords: the cooridinates to set the husky to.
    */
    void setPositionFromTileValues(int[2] huskyCoords){
        auto newX = convertToPixels(huskyCoords[0]);
        auto newY = convertToPixels(huskyCoords[1]);
        this.moveHusky(newX, newY);
    }

    /**
    * First, we need to know which direction the sprite is moving so that we can set the state.
    * Then, we can move to the target and update the state value.
    * Params:
    *   - targetX: the target x-coordinate for this player
    *   - targety: the target y-coordinate for this player
    */
    void moveHusky(int targetX, int targetY){
        huskySprite.xPos = targetX;
        huskySprite.yPos = targetY;
    }

    /**
    * Converts a tile coordinate to to a pixel coordinate.
    *
    * Params:
    *   - tileValue: the tileValue to be rendered.
    */
    int convertToPixels(int tileValue){
        return TILE_TO_PIXEL * tileValue;
    }
}
