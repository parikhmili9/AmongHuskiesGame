/**
 * Module: server.source.model.husky_playground
 *
 * Description: This module defines the `HuskyPlayGround` class, which represents
 * a game world with players and huskies. It provides methods to initialize the game,
 * move players within the world, pick and drop huskies, and determine the winner.
 */

module server.source.model.husky_playground;

import server.source.model.game_world : GameWorld;
import server.source.model.team_player : TeamPlayer;
import server.source.model.team_husky : TeamHusky;
import std.file;
import std.stdio;
import std.string;
import std.array;
import std.conv;

/**
 * Class: HuskyPlayGround
 *
 * Description: This class represents a game world with players and huskies.
 * Extends the `GameWorld` class for basic world properties.
 */
class HuskyPlayGround : GameWorld!()
{

    private int rowsX;
    private int columnsY;

    private string worldName;

    private string teamAName;
    private int numberOfTeamAPlayers;
    private string teamBName;
    private int numberOfTeamBPlayers;

    private TeamPlayer[] players;
    private TeamHusky[] huskies;

    private string[string] playerHuskyPickedMap;
    private int teamAScore;
    private int teamBScore;
    private bool isHuskyDropped;
    string message;
    string winner;

    /**
     * Constructor: this() 
     * 
     * Description: This constructor initializes the game world 
     * with default values for rows and columns.
     */
    this()
    {
        rowsX = 20;
        columnsY = 25;
    }

    /**
     * Method: initialize
     * 
     * Description: This method reads the configuration 
     * from a text file and initializes the game world.
     */
    void initialize()
    {
        readTextFile("assets/HuskyPlayground.txt");
    }

    /**
     * Method: getRows
     * 
     * Description: This method returns the 
     * number of rows in the game world.
     * 
     * Returns: The number of rows.
     */
    int getRows()
    {
        return this.rowsX;
    }

    /**
     * Method: getColumns
     * 
     * Description: This method returns the 
     * number of columns in the game world.
     * 
     * Returns: The number of columns.
     */
    int getColumns()
    {
        return this.columnsY;
    }

    /**
     * Method: getWorldName
     * 
     * Description: This method returns the 
     * name of the game world.
     * 
     * Returns: The name of the game world.
     */
    string getWorldName()
    {
        return this.worldName;
    }

    /**
     * Method: readTextFile
     * 
     * Description: This method reads the game configuration from a text 
     * file and initializes the game world based on the file content.
     * 
     * Params:
     *      path (string) = The path to the text file containing the game configuration.
     */
    void readTextFile(string path)
    {
        // Check if the file exists
        if (!exists(path))
        {
            writeln("Error: File not found!");
            return;
        }

        // Read all lines from the file
        auto fileContent = cast(string) read(path);

        // Split the content into lines
        auto lines = fileContent.split('\n').array;

        // Read the world name from the first line
        this.worldName = lines.front.strip;
        writeln("World Name: ", worldName);

        // Read team names and number of players
        auto teamALine = lines[1].strip.split(' ');
        this.teamAName = teamALine[0];
        this.numberOfTeamAPlayers = teamALine[1].to!int;

        auto teamBLine = lines[2].strip.split(' ');
        this.teamBName = teamBLine[0];
        this.numberOfTeamBPlayers = teamBLine[1].to!int;

        writeln("Team A Name: ", teamAName);
        writeln("Team A Players: ", numberOfTeamAPlayers);
        writeln("Team B Name: ", teamBName);
        writeln("Team B Players: ", numberOfTeamBPlayers);

        // Process player details
        for (size_t i = 3; i < 7; ++i)
        {
            auto playerDetails = lines[i].strip.split(' ');
            string playerName = cast(string) playerDetails[0];
            string playerTeam = cast(string) playerDetails[1];
            int startX = playerDetails[2].to!int;
            int startY = playerDetails[3].to!int;

            players ~= new TeamPlayer(playerName, playerTeam, startX, startY, startX, startY, false);

            writeln("Player Name: ", playerName);
            writeln("Player Team: ", playerTeam);
            writeln("Starting X Position: ", startX);
            writeln("Starting Y Position: ", startY);
        }

        // Process husky details (Lines 10-13)
        for (size_t i = 7; i < 9; ++i)
        {
            auto huskyDetails = lines[i].strip.split(' ');
            string huskyName = cast(string) huskyDetails[0];
            string huskyTeam = cast(string) huskyDetails[0];
            int startX = huskyDetails[1].to!int;
            int startY = huskyDetails[2].to!int;

            huskies ~= new TeamHusky(huskyName, huskyTeam, startX, startY, startX, startY);

            writeln("Husky Name: ", huskyName);
            writeln("Husky Team: ", huskyTeam);
            writeln("Starting X Position: ", startX);
            writeln("Starting Y Position: ", startY);
        }

    }

    /**
    * Method: movePlayerRight
    *
    * Description: This method moves the player to the right on the game board.
    *
    * Params: 
    *      playerName (string) = The name of the player to move.
    */
    void movePlayerRight(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName() == playerName 
            && player.getCurrXPos() < rowsX
            && player.getCurrYPos() < columnsY)
            {
                if (!isCollision(playerName))
                {
                    int currXPos = player.getCurrXPos();
                    int currYPos = player.getCurrYPos();
                    player.setCurrXPos(currXPos + 1);
                    player.setCurrYPos(currYPos);

                    //checks if after the move there is a ball then picks it up
                    checkPickHusky(playerName);
                    checkDropHusky(playerName);

                    //If player has already picked the opposite team's ball then it 
                    //also updates the husky ball's positions along with the player positions
                    if (player.hasHuskyPicked())
                    {
                        if (playerName in playerHuskyPickedMap)
                        {
                            string huskyN = playerHuskyPickedMap[playerName];
                            foreach (TeamHusky husky; huskies)
                            {
                                if (husky.getHuskyName() == huskyN)
                                {
                                    husky.setCurrXPos(currXPos);
                                    husky.setCurrYPos(currYPos + 1);
                                }
                            }
                        }
                    }
                }
            } else {
                player.setCurrXPos(player.getCurrXPos());
                player.setCurrYPos(player.getCurrYPos());
            }
        }
    }

    /**
    * Method: movePlayerLeft
    *
    * Description: This method moves the player to the left on the game board.
    *
    * Params: 
    *      playerName (string) = The name of the player to move.
    */
    void movePlayerLeft(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName == playerName
            && player.getCurrXPos() < rowsX
            && player.getCurrYPos() < columnsY)
            {
                if (!isCollision(playerName))
                {
                    int currXPos = player.getCurrXPos;
                    int currYPos = player.getCurrYPos;
                    player.setCurrXPos(currXPos - 1);
                    player.setCurrYPos(currYPos);

                    //checks if after the move there is a ball then picks it up
                    checkPickHusky(playerName);
                    checkDropHusky(playerName);

                    //If player has already picked the opposite team's ball then it 
                    //also updates the husky ball's positions along with the player positions
                    if (player.hasHuskyPicked())
                    {
                        if (playerName in playerHuskyPickedMap)
                        {
                            string huskyN = playerHuskyPickedMap[playerName];
                            foreach (TeamHusky husky; huskies)
                            {
                                if (husky.getHuskyName() == huskyN)
                                {
                                    husky.setCurrXPos(currXPos);
                                    husky.setCurrYPos(currYPos - 1);
                                }
                            }
                        }
                    }
                }
            } else {
                player.setCurrXPos(player.getCurrXPos());
                player.setCurrYPos(player.getCurrYPos());
            }
        }
    }

    /**
    * Method: movePlayerUp
    *
    * Description: This method moves the player up on the game board.
    *
    * Params: 
    *      playerName (string) = The name of the player to move.
    */
    void movePlayerUp(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName == playerName
            && player.getCurrXPos() < rowsX
            && player.getCurrYPos() < columnsY)
            {
                if (!isCollision(playerName))
                {
                    int currXPos = player.getCurrXPos;
                    int currYPos = player.getCurrYPos;
                    player.setCurrXPos(currXPos);
                    player.setCurrYPos(currYPos - 1);

                    writeln("Moved up");
                    writeln("Player X:", currXPos);
                    writeln("Player Y:", currYPos);

                    //checks if after the move there is a ball then picks it up
                    checkPickHusky(playerName);
                    checkDropHusky(playerName);

                    //If player has already picked the opposite team's ball then it 
                    //also updates the husky ball's positions along with the player positions
                    if (player.hasHuskyPicked())
                    {
                        if (playerName in playerHuskyPickedMap)
                        {
                            string huskyN = playerHuskyPickedMap[playerName];
                            foreach (TeamHusky husky; huskies)
                            {
                                if (husky.getHuskyName() == huskyN)
                                {
                                    husky.setCurrXPos(currXPos - 1);
                                    husky.setCurrYPos(currYPos);
                                }
                            }
                        }
                    }
                }
            } else {
                player.setCurrXPos(player.getCurrXPos());
                player.setCurrYPos(player.getCurrYPos());
            }
        }
    }

    /**
    * Method: movePlayerDown
    *
    * Description: This method moves the player down on the game board.
    *
    * Params: 
    *      playerName (string) = The name of the player to move.
    */
    void movePlayerDown(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName == playerName
            && player.getCurrXPos() < rowsX
            && player.getCurrYPos() < columnsY)
            {
                if (!isCollision(playerName))
                {
                    int currXPos = player.getCurrXPos;
                    int currYPos = player.getCurrYPos;
                    player.setCurrXPos(currXPos);
                    player.setCurrYPos(currYPos + 1);
                    writeln("Moved down");
                    //checks if after the move there is a ball then picks it up
                    checkPickHusky(playerName);
                    checkDropHusky(playerName);

                    //If player has already picked the opposite team's ball then it 
                    //also updates the husky ball's positions along with the player positions
                    if (player.hasHuskyPicked())
                    {
                        if (playerName in playerHuskyPickedMap)
                        {
                            string huskyN = playerHuskyPickedMap[playerName];
                            foreach (TeamHusky husky; huskies)
                            {
                                if (husky.getHuskyName() == huskyN)
                                {
                                    husky.setCurrXPos(currXPos + 1);
                                    husky.setCurrYPos(currYPos);
                                }
                            }
                        }
                    }
                }
            } else {
                player.setCurrXPos(player.getCurrXPos());
                player.setCurrYPos(player.getCurrYPos());
            }
        }
    }

    /**
    * Method: getUpdatedPlayerLocations
    *
    * Description: This method returns an array containing 
    * the updated positions of all players.
    *
    * Returns: A 2D array representing the current positions of all players.
    */
    int[2][4] getUpdatedPlayerLocations()
    {
        int[2][4] res;
        int count = 0;
        foreach (player; players)
        {
            int[2] tempres;
            tempres[0] = player.getCurrXPos();
            tempres[1] = player.getCurrYPos();

            res[count] = tempres;
            count++;
        }
        return res;
    }

    /**
    * Method: getPlayerNames
    *
    * Description: This method returns an array containing the names of all players.
    *
    * Returns: An array containing the names of all players.
    */
    char[4] getPlayerNames()
    {
        char[4] res;
        int i = 0;
        foreach (player; players)
        {
            res[i] = player.getPlayerName()[0];
            i++;
        }
        return res;
    }

    /**
    * Method: getBallCoords
    *
    * Description: This method returns a 2D array containing 
    * the current positions of all husky balls on the game board.
    *
    * Returns: A 2D array representing the current positions of husky balls.
    */
    int[2][2] getBallCoords()
    {
        int[2][2] res;
        int i = 0;
        foreach (husky; huskies)
        {
            int[2] tempres;
            tempres[0] = husky.getCurrXPos();
            tempres[1] = husky.getCurrYPos();
            res[i] = tempres;
            i++;
        }
        return res;
    }

    /**
    * Method: checkPickHusky
    *
    * Description: This method checks if a player can pick up a 
    * husky ball and updates the game state accordingly.
    *
    * Params: 
    *      playerName (string) = The name of the player attempting to pick up a husky ball.
    */
    void checkPickHusky(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName() == playerName)
            {
                int xP = player.getCurrXPos();
                int yP = player.getCurrYPos();
                string playerTeam = player.getPlayerTeam();

                foreach (TeamHusky husky; huskies)
                {
                    if (husky.getCurrXPos() == xP
                        && husky.getCurrYPos() == yP
                        && husky.getHuskyTeam() != playerTeam)
                    {
                        pickHusky(playerName);
                        writeln("Picked husky");
                    }
                }
            }
        }
    }

    /**
    * Method: checkDropHusky
    *
    * Description: This method checks if a player can drop a 
    * husky ball and updates the game state accordingly.
    *
    * Params: 
    *      playerName (string) = The name of the player attempting to drop a husky ball.
    */
    void checkDropHusky(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName() == playerName && player.getPlayerTeam() == "R")
            {
                int xP = player.getCurrXPos();
                int yP = player.getCurrYPos();
                if (xP >= 0 && xP < 25 && yP == 0 && player.hasHuskyPicked())
                {
                    dropHusky(playerName, xP, yP);
                    writeln("Dropped Husky");
                }
            }
            if (player.getPlayerName() == playerName && player.getPlayerTeam() == "B")
            {
                int xP = player.getCurrXPos();
                int yP = player.getCurrYPos();
                if (xP >= 0 && xP < 25 && yP == 24 && player.hasHuskyPicked())
                {
                    dropHusky(playerName, xP, yP);
                    writeln("Dropped Husky");
                }
            }
        }
    }

    /**
    * Method: pickHusky
    *
    * Description: This method picks up a husky ball and updates the game state.
    *
    * Params: 
    *      playerName (string) = The name of the player picking up the husky ball.
    */
    void pickHusky(string playerName)
    {
        if (isHuskyDropped == false)
        {
            foreach (TeamPlayer player; players)
            {
                if (player.getPlayerName() == playerName)
                {
                    int playerCurrXPos = player.getCurrXPos();
                    int playerCurrYPos = player.getCurrYPos();

                    foreach (TeamHusky husky; huskies)
                    {
                        if (husky.getCurrXPos() == playerCurrXPos
                            && husky.getCurrYPos() == playerCurrYPos
                            && husky.getCurrXPos() == husky.getStartXPos()
                            && husky.getCurrYPos() == husky.getStartYPos()
                            && husky.getHuskyTeam() != player.getPlayerTeam())
                        {

                            player.setPickedHusky();
                            husky.setCurrXPos(player.getCurrXPos());
                            husky.setCurrYPos(player.getCurrYPos());
                            playerHuskyPickedMap[player.getPlayerName()] = husky.getHuskyName();

                            writeln("Pick husky----------");
                            writeln("Player x: ", playerCurrXPos);
                            writeln("Player y: ", playerCurrYPos);
                            writeln("Husky x: ", husky.getCurrXPos());
                            writeln("Husky y: ", husky.getCurrYPos());
                        }
                    }
                }
            }
        }
    }

    /**
    * Method: dropHusky
    *
    * Description: This method drops a husky ball and updates the game state.
    *
    * Params: 
    *      playerName (string) = The name of the player dropping the husky ball.
    */
    void dropHusky(string playerName, int x, int y)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName() == playerName && player.hasHuskyPicked() == true)
            {
                if (playerName in playerHuskyPickedMap)
                {
                    string huskyN = playerHuskyPickedMap[playerName];
                    foreach (TeamHusky husky; huskies)
                    {
                        if (huskyN == husky.getHuskyName()){
                            // husky.setCurrXPos(player.getCurrXPos());
                            // husky.setCurrYPos(player.getCurrYPos());
                            husky.setCurrXPos(x);
                            husky.setCurrYPos(y);
                            isHuskyDropped = true;

                            writeln("Drop husky--------------");
                            writeln("Player x: ", player.getCurrXPos());
                            writeln("Player y: ", player.getCurrYPos());
                            writeln("Husky x: ", husky.getCurrXPos());
                            writeln("Husky y: ", husky.getCurrYPos());

                            string team = player.getPlayerTeam();

                            if(isHuskyDropped && ((player.getCurrXPos >= 0 && player.getCurrXPos < 25 && player.getCurrYPos == 0) || 
                                (player.getCurrXPos >= 0 && player.getCurrXPos < 25 && player.getCurrYPos == 24))){
                                
                                if (team == "R")
                                {
                                    teamAScore = teamAScore + 1;
                                }
                                if (team == "B")
                                {
                                    teamBScore = teamBScore + 1;
                                }
                            }
                            
                            break; 
                        }                       
                    }
                }
            }
        }
    }

    /**
    * Method: isCollision
    *
    * Description: This method checks if there is 
    * a collision between players on the game board.
    *
    * Params: 
    *      playerName (string) = The name of the player to check for collisions.
    *
    * Returns: True if a collision is detected, otherwise false.
    */
    bool isCollision(string playerName)
    {
        foreach (TeamPlayer player1; players)
        {
            if (player1.getPlayerName() == playerName)
            {
                foreach (TeamPlayer player2; players)
                {
                    if (player1.getCurrXPos() == player2.getCurrXPos()
                        && player1.getCurrYPos() == player2.getCurrYPos()
                        && player1.getPlayerName() != player2.getPlayerName())
                        return true;
                }
            }
        }
        return false;
    }

    /**
    * Method: endGame
    *
    * Description: This method ends the game and determines the winner based on the scores.
    *
    * Returns: The name of the winning team or an empty string if there is no winner yet.
    */
    string endGame()
    {
        if (teamAScore == 1)
        {
            winner = "Team A";
        }
        if (teamBScore == 1)
        {
            cast(void) message;
            winner = "Team B";
        }
        return winner;
    }

    /**
    * Method: getTeamAScore
    *
    * Description: This method gets the score of Team A.
    *
    * Returns: The score of Team A.
    */
    int getTeamAScore()
    {
        return teamAScore;
    }

    /**
    * Method: getTeamBScore
    *
    * Description: This method gets the score of Team B.
    *
    * Returns: The score of Team B.
    */
    int getTeamBScore()
    {
        return teamBScore;
    }

    /**
    * Method: getPlayerPosition
    *
    * Description: This method returns the position of a single player, as specified by their ID.
    *
    * Params: 
    *      player_id (string) = The name of the player to get the position for.
    *
    * Returns: An array containing the x and y coordinates of the player's position.
    */
    int[] getPlayerPosition(string player_id)
    {
        foreach (TeamPlayer p; players)
        {
            if (p.getPlayerName() == player_id)
            {
                return [p.getCurrXPos(), p.getCurrYPos()];
            }
        }
        return [];
    }
}