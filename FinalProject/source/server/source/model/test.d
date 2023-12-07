module test;

import std.stdio;
import server.source.model.game_world : GameWorld;
import server.source.model.team_player : TeamPlayer;
import server.source.model.team_husky : TeamHusky;
import server.source.model.husky_playground : HuskyPlayGround;

@("Test the initialization of HuskyPlayGround")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();

    assert(huskyPlayground.getRows() == 20);
    assert(huskyPlayground.getColumns() == 25);
}

@("Test reading from the HuskyPlayground.txt file and initial scores of Team A and Team B")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.initialize();

    assert(huskyPlayground.getWorldName() == "HuskyPlayground");
    assert(huskyPlayground.getTeamAScore() == 0);
    assert(huskyPlayground.getTeamBScore() == 0);
}

@("Test getPlayerPositions method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.initialize();

    int[] posA = huskyPlayground.getPlayerPosition("A");
    int[] posB = huskyPlayground.getPlayerPosition("B");
    int[] posC = huskyPlayground.getPlayerPosition("C");
    int[] posD = huskyPlayground.getPlayerPosition("D");

    assert(posA == [3, 10]);
    assert(posB == [10, 10]);
    assert(posC == [17, 3]);
    assert(posD == [17, 20]);
}

@("Test getPlayerNames method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.initialize();

    char[] playerNames = huskyPlayground.getPlayerNames();

    assert(playerNames[0] == 'A');
    assert(playerNames[1] == 'B');
    assert(playerNames[2] == 'C');
    assert(playerNames[3] == 'D');
}

@("Test getBallCoords method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.initialize();

    int[2][2] ballCoords = huskyPlayground.getBallCoords();

    assert(ballCoords[0] == [17, 0]);
    assert(ballCoords[1] == [3, 24]);
}

@("Test movePlayerRight method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    auto oldPosRight = huskyPlayground.getPlayerPosition("A");

    for (int i = 0; i < 3; i++)
    {
        huskyPlayground.movePlayerRight("A");
    }

    auto newPosRight = huskyPlayground.getPlayerPosition("A");

    assert(newPosRight[0] == oldPosRight[0] + 3);
    assert(newPosRight[1] == oldPosRight[1]);
}

@("Test movePlayerLeft method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    auto oldPosLeft = huskyPlayground.getPlayerPosition("B");

    for (int i = 0; i < 10; i++)
    {
        huskyPlayground.movePlayerLeft("B");
    }

    auto newPosLeft = huskyPlayground.getPlayerPosition("B");

    assert(newPosLeft[0] == oldPosLeft[0] - 10);
    assert(newPosLeft[1] == oldPosLeft[1]);
}

@("Test movePlayerRight, movePlayerLeft, and reading from .txt file")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.initialize();

    huskyPlayground.movePlayerRight("A");
    auto pos = huskyPlayground.getUpdatedPlayerLocations();
    assert(pos[0] == [4, 10]);

    huskyPlayground.movePlayerLeft("A");
    auto newPos = huskyPlayground.getUpdatedPlayerLocations();
    assert(newPos[0] == [3, 10]);
}

@("Test movePlayerUp method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    auto oldPosUp = huskyPlayground.getPlayerPosition("C");

    huskyPlayground.movePlayerUp("C");

    auto newPosUp = huskyPlayground.getPlayerPosition("C");
    assert(newPosUp[0] == oldPosUp[0]);
    assert(newPosUp[1] == oldPosUp[1] - 1);
}

@("Test movePlayerDown method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    auto oldPosDown = huskyPlayground.getPlayerPosition("D");

    huskyPlayground.movePlayerDown("D");

    auto newPosDown = huskyPlayground.getPlayerPosition("D");
    assert(newPosDown[0] == oldPosDown[0]);
    assert(newPosDown[1] == oldPosDown[1] + 1);
}

@("Test moveplayerUp and movePlayerDown methods")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    auto oldPos = huskyPlayground.getPlayerPosition("C");

    huskyPlayground.movePlayerUp("C");
    huskyPlayground.movePlayerUp("C");
    huskyPlayground.movePlayerUp("C");

    for (int i = 0; i < 24; i++)
    {
        huskyPlayground.movePlayerDown("C");
    }

    auto newPos = huskyPlayground.getPlayerPosition("C");
    assert(newPos[0] == oldPos[0]);
    assert(newPos[1] == oldPos[1] + 21);
}

@("Test pickHusky and dropHusky")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    auto oldPos = huskyPlayground.getPlayerPosition("D");

    for (int i = 0; i < 20; i++)
    {
        huskyPlayground.movePlayerUp("D");
    }

    huskyPlayground.pickHusky("D");

    for (int i = 0; i < 24; i++)
    {
        huskyPlayground.movePlayerDown("D");
    }

    huskyPlayground.dropHusky("D", 17, 24);
    
    auto newPos = huskyPlayground.getPlayerPosition("D");

    assert(newPos[0] == oldPos[0]);
    assert(newPos[1] == oldPos[1] + 4);
    assert(huskyPlayground.getTeamBScore() == 2);
}

@("Test endGame method")
unittest
{
    HuskyPlayGround huskyPlayground = new HuskyPlayGround();
    huskyPlayground.readTextFile("assets/HuskyPlayground.txt");

    for (int i = 0; i < 14; i++)
    {
        huskyPlayground.movePlayerDown("A");
    }

    for (int i = 0; i < 24; i++)
    {
        huskyPlayground.movePlayerUp("A");
    }

    assert(huskyPlayground.getTeamAScore() == 1);
    assert(huskyPlayground.endGame());
}

// unittest
// {
//     HuskyPlayGround huskyPlayground = new HuskyPlayGround();
//     huskyPlayground.initialize();

//     huskyPlayground.movePlayerRight("A");
//     huskyPlayground.movePlayerDown("B");
//     huskyPlayground.movePlayerUp("C");
//     huskyPlayground.movePlayerLeft("D");

//     assert(huskyPlayground.noCollisions("A") == true);
//     assert(huskyPlayground.noCollisions("B") == true);
//     assert(huskyPlayground.noCollisions("C") == true);
//     assert(huskyPlayground.noCollisions("D") == true);
// }

// unittest
// {
//     HuskyPlayGround huskyPlayground = new HuskyPlayGround();
//     huskyPlayground.initialize();

//     for (int i = 0; i < 7 ; i++)
//     {
//         huskyPlayground.movePlayerRight("A");
//     }

//     writeln(huskyPlayground.getPlayerPosition("A"));

//     assert(huskyPlayground.noCollisions("A") == false);
// }