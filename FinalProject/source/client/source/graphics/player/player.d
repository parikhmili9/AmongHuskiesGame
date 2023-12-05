module client.source.graphics.player.player;

import bindbc.sdl;
import client.source.graphics.player.sprite;
import client.source.packet.client_packet : ClientPacket;

struct Player
{

    Sprite playerSprite;
    char player_id;

    this(SDL_Renderer* renderer, string filepath, int startX, int startY, char player_id)
    {
        playerSprite = Sprite(renderer, filepath, startX, startY);
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
}
