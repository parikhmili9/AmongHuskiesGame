module client.source.graphics.player.player;

import std.stdio;
import std.math;
import bindbc.sdl;
import client.source.graphics.player.sprite;
import client.source.packet.client_packet : ClientPacket;

struct Player
{

    Sprite playerSprite;
    char player_id;
    const int TILE_TO_PIXEL = 32;
    string currFilePath;
    string activeFilePath;
    this(SDL_Renderer* renderer, string currFilePath, string activeFilePath, int startX, int startY, char player_id)
    {
        this.currFilePath = currFilePath;
        this.activeFilePath = activeFilePath;
        // By default, we haven't actively picked up a ball.
        playerSprite = Sprite(renderer, currFilePath, startX, startY);
        this.player_id = player_id;
    }

    int getX()
    {
        return playerSprite.xPos;
    }

    int getY()
    {
        return playerSprite.yPos;
    }

    void moveUp()
    {
        playerSprite.yPos -= 16;
        playerSprite.mState = STATE.WALK_UP;
    }

    void moveDown()
    {
        playerSprite.yPos += 16;
        playerSprite.mState = STATE.WALK_DOWN;
    }

    void moveLeft()
    {
        playerSprite.xPos -= 16;
        playerSprite.mState = STATE.WALK_LEFT;
    }

    void moveRight()
    {
        playerSprite.xPos += 16;
        playerSprite.mState = STATE.WALK_RIGHT;
    }

    void render(SDL_Renderer* renderer)
    {
        playerSprite.render(renderer);
        playerSprite.mState = STATE.IDLE;
    }

    char getId()
    {
        return this.player_id;
    }

    void setPositionFromTileValues(int[2] playerCoords){
        auto newX = convertToPixels(playerCoords[0]);
        auto newY = convertToPixels(playerCoords[1]);

        movePlayer(newX, newY);
    }

    int convertToPixels(int tileValue){
        return TILE_TO_PIXEL * tileValue;
    }

    // First, we need to know which direction the sprite is moving so that we can set the state.
    // Then, we can move to the target and update the state value.
    void movePlayer(int targetX, int targetY){
        if (targetX > this.getX()){
            playerSprite.xPos += TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_RIGHT;
        } else if (targetX < this.getX()){
            writeln("MOVING PLAYER TO LEFT: ", targetX, targetY);
            playerSprite.xPos -= TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_LEFT;
        } else if (targetY < this.getY()){
            writeln("MOVING PLAYER UP: ", targetX, targetY);
            playerSprite.yPos -= TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_UP;
        } else if (targetY > this.getY()){
            writeln("MOVING PLAYER DOWN: ", targetX, targetY);
            playerSprite.yPos += TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_DOWN;
        } else {
            // No movement needed, we haven't changed.
            playerSprite.mState = STATE.IDLE;
        }

    }

    bool isHoldingOpponentBall(int[] oppBallCoords){
        if(abs(this.getX() - oppBallCoords[0]) <= 32 &&  abs(this.getY() - oppBallCoords[1]) <= 32){
            writeln(this.getX());
            writeln(this.getY());
            writeln(oppBallCoords);
        }
        return oppBallCoords[0] == this.getX() && oppBallCoords[1] == this.getY();
    }

    void markActive(SDL_Renderer* renderer){
        this.playerSprite.updateImage(renderer, activeFilePath);
    }
    void markInactive(SDL_Renderer* renderer){
        this.playerSprite.updateImage(renderer,currFilePath);
    }
}
