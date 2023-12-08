module player_test;
import std.stdio;
import client.source.graphics.player.player;
import client.source.graphics.husky.husky;

// Test that the player can tell when the husky is in the same tile
unittest {

    // player takes pixels as starting coordinates, and husky coords come in from the server as tiles.
    // so we need to hack some conversion here.
    auto tileX = 10;
    auto tileY = 15;
    const int TILE_SIZE_IN_PIXELS = 32;

    // create a mock player and some coordinates for it 
    Player player = Player(null, "STANDARD_RED_SPRITE_PATH", "ACTIVE_RED_SPRITE_PATH", tileX * TILE_SIZE_IN_PIXELS, tileY * TILE_SIZE_IN_PIXELS, 'A');
    int[] huskyCoords = [tileX, tileY];
    bool IsHoldingBall = player.isHoldingOpponentBall(huskyCoords);
    assert(IsHoldingBall);
}