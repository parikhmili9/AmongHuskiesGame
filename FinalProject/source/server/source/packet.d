module packet;

import core.stdc.string;

struct Packet
{
    // Key is Player Name  -> Value is Coordinate.
    //Coord[char] playerCoords;
    // Coord[4] playerCoords;
    int[2] player1Coords;
    int[2] player2Coords;
    int[2] player3Coords;
    int[2] player4Coords;
    // Key is Player Name -> Value is Team Name (Either R or B).
    //char[char] playerAssignment;
    char[4] playerAssignment;
    // Key is Color Name -> Value is Coordinate.
    //Coord[char] ballCoords;

    // Coord[2] ballCoords;
    int[2] ball1Coords;
    int[2] ball2Coords;

    // Message for chatting.
    char[80] message;

    // Serialize packet
    char[Packet.sizeof] serialize()
    {
        char[Packet.sizeof] payload;
        memmove(&payload, &player1Coords, player1Coords.sizeof);
        memmove(&payload[player1Coords.sizeof], &player2Coords, player2Coords.sizeof);
        memmove(&payload[player1Coords.sizeof + player2Coords.sizeof], &player3Coords, player3Coords.sizeof);
        memmove(&payload[player1Coords.sizeof + player2Coords.sizeof + player3Coords.sizeof], &player4Coords, player4Coords.sizeof);
        size_t playerChordsSize = player1Coords.sizeof + player2Coords.sizeof + player3Coords.sizeof + player4Coords.sizeof;
        memmove(&payload[playerChordsSize], &playerAssignment, playerAssignment.sizeof);

        memmove(&payload[playerChordsSize + playerAssignment.sizeof], &ball1Coords, ball1Coords
                .sizeof);
        memmove(&payload[playerChordsSize + playerAssignment.sizeof + ball1Coords.sizeof], &ball2Coords, ball2Coords
                .sizeof);
        memmove(&payload[playerChordsSize + playerAssignment.sizeof + ball1Coords.sizeof + ball2Coords.sizeof], &message, message
                .sizeof);
        return payload;
    }

}

// byte[] serialize(Packet p)
// {
//     byte[p.sizeof] buffer;
//     auto received = socket.receive(buffer);

//     // writeln("On Connect: ", buffer[0 .. received]);
//     // write(">");
//     foreach (line; stdin.byLine)
//     {
//         Packet data;
//         // The 'with' statement allows us to access an object
//         // (i.e. member variables and member functions)
//         // in a slightly more convenient way
//         with (data)
//         {
//             user = "clientName\0";
//             // Just some 'dummy' data for now
//             // that the 'client' will continuously send
//             x = 7;
//             y = 5;
//             r = 49;
//             g = 50;
//             b = 51;
//             message = "test\0";
//         }
//     }
// }

// Packet deserialize(byte[] b)
// {
//     return null;
// }
