module teamplayer;

class TeamPlayer
{
    private string playerName;
    private string playerTeam;
    private int startXPos;
    private int startYPos;
    private int currXPos;
    private int currYPos;
    private bool hasHusky;

    this(string playerName, string playerTeam, int startXPos, int startYPos, int currXPos, int currYPos, bool hasHusky)
    {
        this.playerName = playerName;
        this.playerTeam = playerTeam;
        this.startXPos = startXPos;
        this.startYPos = startYPos;
        this.currXPos = currXPos;
        this.currYPos = currYPos;
        this.hasHusky = hasHusky;
    }

    string getPlayerName()
    {
        return this.playerName;
    }

    string getPlayerTeam()
    {
        return this.playerTeam;
    }

    int getStartXPos()
    {
        return startXPos;
    }

    // void setStartXPos(int xStartPos) {
    //     startXPos = xStartPos;
    // }

    int getStartYPos()
    {
        return startYPos;
    }

    // void setStartYPos(int yStartPos) {
    //     startYPos = yStartPos;
    // }

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

    bool hasHuskyPicked()
    {
        if (hasHusky == true)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    void setPickedHusky()
    {
        hasHusky = true;
    }
}
