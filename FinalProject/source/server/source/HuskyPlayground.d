module huskyplayground;

import gameworld : GameWorld;
import teamplayer : TeamPlayer;
import teamhusky : TeamHusky;
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
    // private TeamBPlayer[] teamBplayers;
    private TeamHusky[] huskies;
    // private TeamBHusky[] teamBHuskies;
    private string[string] playerHuskyPickedMap;
    private int teamAScore;
    private int teamBScore;
    private bool isHuskyDropped;
    string message;
    string winner;

    this()
    {
        rowsX = 50; //temp - change later
        columnsY = 100;
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
            string playerName = cast(string)playerDetails[0];
            string playerTeam = cast(string)playerDetails[1];
            int startX = playerDetails[2].to!int;
            int startY = playerDetails[3].to!int;

            players ~= new TeamPlayer(playerName, playerTeam, startX, startY, startX, startY, false);

            // if(playerTeam == "TeamA"){
            //     teamAPlayers ~= new TeamAPlayer(playerName, startX, startY, startX, startY, false);
            // }

            // if(playerTeam == "TeamB"){
            //     teamBplayers ~= new TeamBplayer(playerName, startX, startY, startX, startY, false);
            // }

            writeln("Player Name: ", playerName);
            writeln("Player Team: ", playerTeam);
            writeln("Starting X Position: ", startX);
            writeln("Starting Y Position: ", startY);
        }

        // Process husky details (Lines 10-13)
        for (size_t i = 7; i < 9; ++i)
        {
            auto huskyDetails = lines[i].strip.split(' ');
            string huskyName = cast(string)huskyDetails[0];
            string huskyTeam = cast(string)huskyDetails[0];
            int startX = huskyDetails[1].to!int;
            int startY = huskyDetails[2].to!int;

            huskies ~= new TeamHusky(huskyName, huskyTeam, startX, startY, startX, startY);

            // if(huskyTeam == "TeamA") {
            //     teamAHuskies ~= new TeamAHusky(huskyName, startX, startY, startX, startY);
            // }

            // if(huskyTeam == "TeamB") {
            //     teamBHuskies ~= new TeamBHusky(huskyName, startX, startY, startX, startY);
            // }

            writeln("Husky Name: ", huskyName);
            writeln("Husky Team: ", huskyTeam);
            writeln("Starting X Position: ", startX);
            writeln("Starting Y Position: ", startY);
        }

        // Rest of the file processing...
    }

    void movePlayerRight(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName() == playerName)
            {
                int currXPos = player.getCurrXPos();
                int currYPos = player.getCurrYPos();
                player.setCurrXPos(currXPos);
                player.setCurrYPos(currYPos + 1);

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
        }
    }

    void movePlayerLeft(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName == playerName)
            {
                int currXPos = player.getCurrXPos;
                int currYPos = player.getCurrYPos;
                player.setCurrXPos(currXPos);
                player.setCurrYPos(currYPos - 1);

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
        }
    }

    void movePlayerUp(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName == playerName)
            {
                int currXPos = player.getCurrXPos;
                int currYPos = player.getCurrYPos;
                player.setCurrXPos(currXPos - 1);
                player.setCurrYPos(currYPos);

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
        }
    }

    void movePlayerDown(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName == playerName)
            {
                int currXPos = player.getCurrXPos;
                int currYPos = player.getCurrYPos;
                player.setCurrXPos(currXPos + 1);
                player.setCurrYPos(currYPos);

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
        }
    }

    int[2][4] getUpdatedPlayerLocations(){
        int[2][4] res;
        int count = 0;
        foreach(player ; players)
        {
            int[2] tempres;
            tempres[0] =  player.getCurrXPos();
            tempres[1] = player.getCurrYPos();

            res[count] = tempres;
            count++;
        }
        return res;
    }

    char[4] getPlayerNames(){
        char[4] res;
        int i = 0;
        foreach (player; players)
        {
            res[i] = player.getPlayerName()[0];
            i++;
        }
        return res;
    }

    int[2][2] getBallCoords(){
        int[2][2] res;
        int i = 0;
        foreach (husky; huskies){
            int[2] tempres;
            tempres[0] = husky.getCurrXPos();
            tempres[1] = husky.getCurrYPos();
            res[i] = tempres;
            i++;
        }
        return res;
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
                        }
                    }
                }
            }
        }
    }

    void dropHusky(string playerName)
    {
        foreach (TeamPlayer player; players)
        {
            if (player.getPlayerName() == playerName && player.hasHuskyPicked() == true)
            {
                if (player.getCurrYPos() == 1)
                {
                    if (playerName in playerHuskyPickedMap)
                    {
                        string huskyN = playerHuskyPickedMap[playerName];
                        foreach (TeamHusky husky; huskies)
                        {
                            husky.setCurrXPos(player.getCurrXPos());
                            husky.setCurrYPos(player.getCurrYPos());
                            isHuskyDropped = true;
                            string team = player.getPlayerTeam();
                            if (team == "TeamA")
                            {
                                teamAScore = teamAScore + 1;
                            }
                            if (team == "TeamB")
                            {
                                teamBScore = teamBScore + 1;
                            }
                        }
                    }
                }
                else
                {
                    message = "Invalid move. Not your home destination";
                }
            }
        }
    }

    string endGame()
    {
        if (teamAScore == 2)
        {
            winner = "Team A";
        }
        if (teamBScore == 2)
        {
            cast(void) message;
            winner = "Team B";
        }
        return winner;
    }

    void startGame()
    {

    }

    void displayPlayerInfo()
    {

    }

    void displayHusky()
    {

    }

    void getGraphics()
    {

    }

    int getTeamAScore()
    {
        return teamAScore;
    }

    int getTeamBScore()
    {
        return teamBScore;
    }
}

// void main()
// {
//     //Just to test all methods here are working!!
//     HuskyPlayGround ground = new HuskyPlayGround();
//     ground.readTextFile("source/HuskyPlayground.txt");
// }
