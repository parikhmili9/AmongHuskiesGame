/**
 * Module: server.source.model.game_world
 *
 * Description: This module defines the GameWorld interface, 
 * which represents the game world and provides methods to interact with it.
 */
module server.source.model.game_world;

/**
 * Interface: GameWorld
 *
 * Description: The GameWorld interface defines methods to interact with the game world.
 */
interface GameWorld()
{
    int getRows();
    int getColumns();
    string getWorldName();
    string endGame();
    int getTeamAScore();
    int getTeamBScore();

    void readTextFile(string path);

    void movePlayerRight(string playerName);
    void movePlayerLeft(string playerName);
    void movePlayerUp(string playerName);
    void movePlayerDown(string playerName);
    void pickHusky(string playerName);
    void dropHusky(string playerName, int x, int y);
}