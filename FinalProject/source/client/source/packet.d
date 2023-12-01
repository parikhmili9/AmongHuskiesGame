module packet;

import core.stdc.string;

struct Packet
{
    // Key is Player Name  -> Value is Coordinate.
    //Coord[char] playerCoords;
    Coord[4] playerCoords;
    // Key is Player Name -> Value is Team Name (Either R or B).
    //char[char] playerAssignment;
    char[4] playerAssignment;
    // Key is Color Name -> Value is Coordinate.
    //Coord[char] ballCoords;
    Coord[2] ballCoords;
    // Message for chatting.
    char[200] message;

    // Serialize packet
    char[Packet.sizeof] serialize()
    {
        char[Packet.sizeof] payload;
        memmove(&payload, &playerCoords, playerCoords.sizeof);
        memmove(&payload[playerCoords.sizeof], &playerAssignment, playerAssignment.sizeof);
        memmove(&payload[playerCoords.sizeof + playerAssignment.sizeof], &ballCoords, ballCoords
                .sizeof);
        memmove(&payload[playerCoords.sizeof + playerAssignment.sizeof + ballCoords.sizeof], &message, message
                .sizeof);

        return payload;
    }

}

struct Coord
{
    int x;
    int y;
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
