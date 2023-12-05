module server.source.model.team_husky;

class TeamHusky
{
    private string huskyName;
    private string huskyTeam;
    private int startXPos;
    private int startYPos;
    private int currXPos;
    private int currYPos;

    this(string huskyName, string huskyTeam, int startXPos, int startYPos, int currXPos, int currYPos)
    {
        this.huskyName = huskyName;
        this.huskyTeam = huskyTeam;
        this.startXPos = startXPos;
        this.startYPos = startYPos;
        this.currXPos = currXPos;
        this.currYPos = currYPos;
    }

    string getHuskyName()
    {
        return this.huskyName;
    }

    string getHuskyTeam()
    {
        return this.huskyTeam;
    }

    int getStartXPos()
    {
        return startXPos;
    }

    int getStartYPos()
    {
        return startYPos;
    }

    int getCurrXPos()
    {
        return currXPos;
    }

    void setCurrXPos(int xCurrPos)
    {
        currXPos = xCurrPos;
    }

    int getCurrYPos()
    {
        return currYPos;
    }

    void setCurrYPos(int yCurrPos)
    {
        currYPos = yCurrPos;
    }
}
