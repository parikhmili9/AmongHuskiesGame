module server.source.model.game_world;

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
