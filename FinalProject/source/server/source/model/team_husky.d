/**
 * Module: server.source.model.team_husky
 *
 * Description: This module contains the definition of the TeamHusky class, which represents
 * a husky in a team with its position information.
 */
module server.source.model.team_husky;

/**
 * Class: TeamHusky
 *
 * Description: This class represents a husky in a team with its position information.
 */
class TeamHusky
{
    /**
     * Private member: huskyName
     *
     * Description: The name of the husky.
     */
    private string huskyName;

    /**
     * Private member: huskyTeam
     *
     * Description: The team to which the husky belongs.
     */
    private string huskyTeam;

    /**
     * Private member: startXPos
     *
     * Description: The starting X position of the husky.
     */
    private int startXPos;

    /**
     * Private member: startYPos
     *
     * Description: The starting Y position of the husky.
     */
    private int startYPos;

    /**
     * Private member: currXPos
     *
     * Description: The current X position of the husky.
     */
    private int currXPos;

    /**
     * Private member: currYPos
     *
     * Description: The current Y position of the husky.
     */
    private int currYPos;

    /**
     * Constructor: this
     *
     * Description: The constructor initializes a new instance 
     * of the TeamHusky class with the provided parameters.
     *
     * Params:
     *      huskyName = The name of the husky.
     *      huskyTeam = The team to which the husky belongs.
     *      startXPos = The starting X position of the husky.
     *      startYPos = The starting Y position of the husky.
     *      currXPos  = The current X position of the husky.
     *      currYPos  = The current Y position of the husky.
     */
    this(string huskyName, string huskyTeam, int startXPos, int startYPos, int currXPos, int currYPos)
    {
        this.huskyName = huskyName;
        this.huskyTeam = huskyTeam;
        this.startXPos = startXPos;
        this.startYPos = startYPos;
        this.currXPos = currXPos;
        this.currYPos = currYPos;
    }

    /**
     * Method: getHuskyName
     *
     * Description: This method gets the name of the husky.
     *
     * Returns: The husky name.
     */
    string getHuskyName()
    {
        return this.huskyName;
    }

    /**
     * Method: getHuskyTeam
     *
     * Description: This method gets the team to which the husky belongs.
     *
     * Returns: The husky team.
     */
    string getHuskyTeam()
    {
        return this.huskyTeam;
    }

    /**
     * Method: getStartXPos
     *
     * Description: This method gets the starting X position of the husky.
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
     * Description: This method gets the starting Y position of the husky.
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
     * Description: This method gets the current X position of the husky.
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
     * Description: This method sets the current X position of the husky.
     *
     * Params:
     *   xCurrPos - The new X position.
     */
    void setCurrXPos(int xCurrPos)
    {
        currXPos = xCurrPos;
    }

    /**
     * Method: getCurrYPos
     *
     * Description: This method gets the current Y position of the husky.
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
     * Description: This method sets the current Y position of the husky.
     *
     * Params:
     *   yCurrPos - The new Y position.
     */
    void setCurrYPos(int yCurrPos)
    {
        currYPos = yCurrPos;
    }
}
