module client.source.packet.deserialize_server;

import std.stdio;
import client.source.packet.packet;

Packet deserialize(char[Packet.sizeof] pac)
{
    Packet result;
    if (pac.sizeof < Packet.sizeof - 200)
    {
        writeln("Not Enough information provided");
        return result;
    }

    result.player1Coords = cast(int[]) pac[0 .. 8];
    result.player2Coords = cast(int[]) pac[8 .. 16];
    result.player3Coords = cast(int[]) pac[16 .. 24];
    result.player4Coords = cast(int[]) pac[24 .. 32];

    result.playerAssignment = pac[32 .. 36];

    result.ball1Coords = cast(int[]) pac[36 .. 44];
    result.ball2Coords = cast(int[]) pac[44 .. 52];

    result.message = pac[52 .. pac.sizeof];

    return result;

}
