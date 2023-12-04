module gameworld;

interface GameWorld()
{
    int getRows();
    int getColumns();
    string getWorldName();
    void readTextFile(string path);
    void movePlayerRight(string playerName);
    void movePlayerLeft(string playerName);
    void movePlayerUp(string playerName);
    void movePlayerDown(string playerName);
    void pickHusky(string playerName);
    void dropHusky(string playerName, int x, int y);
    // void setGameTime(int gameTime);
    string endGame();
    void startGame();
    void displayPlayerInfo();
    void displayHusky();
    void getGraphics();
    int getTeamAScore();
    int getTeamBScore();
}
