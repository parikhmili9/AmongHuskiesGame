module server.source.model.husky_playground;

import server.source.model.game_world : GameWorld;
import server.source.model.team_player : TeamPlayer;
import server.source.model.team_husky : TeamHusky;
import std.file;
import std.stdio;
import std.string;
import std.array;
import std.conv;

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

    this()
    {
        rowsX = 20; //temp - change later
        columnsY = 25;
    }

    void initialize()
    {
        readTextFile("assets/HuskyPlayground.txt");
    }

    int getRows()
    {
        return this.rowsX;
    }

    int getColumns()
    {
        return this.columnsY;
    }

    string getWorldName()
    {
        return this.worldName;
    }

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

        // Process player details (Lines 4-9)
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

    int getTeamAScore()
    {
        return teamAScore;
    }

    int getTeamBScore()
    {
        return teamBScore;
    }

    // Return the position of a single player, as specified by their ID.
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