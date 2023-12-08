/**
 * Module: server.source.model.team_player
 *
 * Description: This module defines a TeamPlayer class that 
 * represents a player in a team-based game.
 */
module server.source.model.team_player;

/**
 * Class: TeamPlayer
 *
 * Description: Represents a player in a team-based game with information 
 * such as name, team, positions, and husky status.
 */
class TeamPlayer
{
    /**
     * Private member: playerName
     *
     * Description: The name of the player.
     */
    private string playerName;

    /**
     * Private member: playerTeam
     *
     * Description: The player team.
     */
    private string playerTeam;

    /**
     * Private member: startXPos
     *
     * Description: The starting X position of the player.
     */
    private int startXPos;

    /**
     * Private member: startYPos
     *
     * Description: The starting Y position of the player.
     */
    private int startYPos;

    /**
     * Private member: currXPos
     *
     * Description: The current X position of the player.
     */
    private int currXPos;

    /**
     * Private member: currYPos
     *
     * Description: The current Y position of the player.
     */
    private int currYPos;

    /**
     * Private member: hasHusky
     *
     * Description: Whether the player has the husky or does not.
     */
    private bool hasHusky;

    /**
     * Constructor: this
     * 
     * Description: The constructor initializes a TeamPlayer object 
     * with the provided parameters.
     *
     * Params:
     *      playerName = The name of the player.
     *      playerTeam = The team to which the player belongs.
     *      startXPos = The starting X position of the player.
     *      startYPos = The starting Y position of the player.
     *      currXPos = The current X position of the player.
     *      currYPos = The current Y position of the player.
     *      hasHusky = A boolean indicating whether the player has picked up a husky.
     */
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

    /**
     * Method: getPlayerName
     *
     * Description: Gets the name of the player.
     *
     * Returns: The player's name.
     */
    string getPlayerName()
    {
        return this.playerName;
    }

    /**
     * Method: getPlayerTeam
     *
     * Description: Gets the team to which the player belongs.
     *
     * Returns: The player's team.
     */
    string getPlayerTeam()
    {
        return this.playerTeam;
    }

    /**
     * Method: getStartXPos
     *
     * Description: This method gets the starting X position of the player.
     *
     * Returns: The starting X position.
     */
    int getStartXPos()
    {
        return startXPos;
    }

    /**
     * Method: getStartYPos
     *
     * Description: This method gets the starting Y position of the player.
     *
     * Returns: The starting Y position.
     */
    int getStartYPos()
    {
        return startYPos;
    }

    /**
     * Method: getCurrXPos
     *
     * Description: Gets the current X position of the player.
     *
     * Returns: The current X position.
     */
    int getCurrXPos()
    {
        return currXPos;
    }

    /**
     * Method: setCurrXPos
     *
     * Description: Sets the current X position of the player.
     *
     * Params:
     *      xCurrPos = The new X position to set.
     */
    void setCurrXPos(int xCurrPos)
    {
        currXPos = xCurrPos;
    }

    /**
     * Method: getCurrYPos
     *
     * Description: Gets the current Y position of the player.
     *
     * Returns: The current Y position.
     */
    int getCurrYPos()
    {
        return currYPos;
    }

    /**
     * Method: setCurrYPos
     *
     * Description: Sets the current Y position of the player.
     *
     * Params:
     *      yCurrPos: The new Y position to set.
     */
    void setCurrYPos(int yCurrPos)
    {
        currYPos = yCurrPos;
    }

    /**
     * Method: hasHuskyPicked
     *
     * Description: Checks if the player has picked up a husky.
     *
     * Returns: True if the player has a husky, false otherwise.
     */
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

    /**
     * Method: setPickedHusky
     *
     * Description: Sets the husky status of the player to true, 
     * indicating that the player has picked up a husky.
     */
    void setPickedHusky()
    {
        hasHusky = true;
    }
}
