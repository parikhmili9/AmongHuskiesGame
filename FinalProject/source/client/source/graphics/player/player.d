module client.source.graphics.player.player;

import std.stdio;
import std.math;
import bindbc.sdl;
import client.source.graphics.player.sprite;
import client.source.packet.client_packet : ClientPacket;

/** 
* The struct that represents the Player object
*/
struct Player
{

    Sprite playerSprite;
    char player_id;
    const int TILE_TO_PIXEL = 32;
    string currFilePath;
    string activeFilePath;

    /**
	* Constructor for the Player class.
	*
	* Params:
	*   - renderer: SDL renderer for rendering graphics.
    *   - currFilePath: filePath to the sprites currently representing this player.
	*   - activeFilePath: Filepath to the sprites for this player for when they are actively carrying a husky.
	*   - startX: Initial X coordinate in pixels.
	*   - startY: Initial Y coordinate in pixels.
	*   - playerId: unique id for this player object
	*/
    this(SDL_Renderer* renderer, string currFilePath, string activeFilePath, int startX, int startY, char player_id)
    {
        this.currFilePath = currFilePath;
        this.activeFilePath = activeFilePath;
        // By default, we haven't actively picked up a ball.
        playerSprite = Sprite(renderer, currFilePath, startX, startY);
        this.player_id = player_id;
    }


    /**
    * Returns the player's X position in pixels
    */
    int getX()
    {
        return playerSprite.xPos;
    }

    /**
    * Returns the player's Y position in pixels
    */
    int getY()
    {
        return playerSprite.yPos;
    }

    /**
    * Moves this player up in the tilemap it is represented on.
    */
    void moveUp()
    {
        playerSprite.yPos -= 16;
        playerSprite.mState = STATE.WALK_UP;
    }

    /**
    * Moves this player down in the tilemap it is represented on.
    */
    void moveDown()
    {
        playerSprite.yPos += 16;
        playerSprite.mState = STATE.WALK_DOWN;
    }

    /**
    * Moves this player left in the tilemap it is represented on.
    */
    void moveLeft()
    {
        playerSprite.xPos -= 16;
        playerSprite.mState = STATE.WALK_LEFT;
    }

    /**
    * Moves this player right in the tilemap it is represented on.
    */
    void moveRight()
    {
        playerSprite.xPos += 16;
        playerSprite.mState = STATE.WALK_RIGHT;
    }

    /**
    * Renders this player in the tilemap it is represented on.
    */
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

    
    
    /**
    * First, we need to know which direction the sprite is moving so that we can set the state.
    * Then, we can move to the target and update the state value.
    *
    * params:
    *   - targetX: the target x-coordinate for this player 
    *   - targety: the target y-coordinate for this player 
    */
    void movePlayer(int targetX, int targetY){
        if (targetX > this.getX()){
            playerSprite.xPos += TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_RIGHT;
        } else if (targetX < this.getX()){
            playerSprite.xPos -= TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_LEFT;
        } else if (targetY < this.getY()){
            playerSprite.yPos -= TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_UP;
        } else if (targetY > this.getY()){
            playerSprite.yPos += TILE_TO_PIXEL;
            playerSprite.mState = STATE.WALK_DOWN;
        } else {
            // No movement needed, we haven't changed.
            playerSprite.mState = STATE.IDLE;
        }

    }

    /**
	* Tells whether this player is holding the opposing team's husky (ball).
	*
	* Params:
	*   - oppBallCoords: the coordinates of the opposing team's Husky (ball).
	*/
    bool isHoldingOpponentBall(int[] oppBallCoords){
        auto ballX = oppBallCoords[0] * TILE_TO_PIXEL;
        auto ballY = oppBallCoords[1] * TILE_TO_PIXEL;
        if(abs(this.getX() - ballX) <= TILE_TO_PIXEL &&  abs(this.getY() - ballY) <= TILE_TO_PIXEL){
            return true;
        }
        return false;
    }


    /**
	* Mark's this player as active (carrying the opposing team's husky) and updates their
    * sprite accordingly.
	*
	* Params:
	*   - renderer: the SDL renderer for this player's sprite
	*/
    void markActive(SDL_Renderer* renderer){
        this.playerSprite.updateImage(renderer, activeFilePath);
    }

    /**
	* Mark's this player as inactive (carrying the opposing team's husky) and updates their
    * sprite accordingly.
    * 
	* Params:
	*   - renderer: the SDL renderer for this player's sprite
	*/
    void markInactive(SDL_Renderer* renderer){
        this.playerSprite.updateImage(renderer,currFilePath);
    }
}
