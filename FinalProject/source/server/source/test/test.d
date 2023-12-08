module server.source.test.test;

import server.source.packet.packet;
import server.source.packet.client_packet;
import server.source.packet.deserialize_client;
import std.stdio;


unittest
{
    ClientPacket p;
    p.client_id = 'A';
    p.move_num = 5;

    char[ClientPacket.sizeof] buffer = p.serialize;
    ClientPacket ans = deserialize(buffer);
    assert(ans.client_id == 'A');
}
unittest
{
    ClientPacket p;
    p.client_id = 'A';
    p.move_num = 5;

    char[ClientPacket.sizeof] buffer = p.serialize;
    ClientPacket ans = deserialize(buffer);
    assert( ans.move_num == 5);
}
unittest
{
    ClientPacket p;
    p.client_id = 'A';
    p.move_num = 5;
    p.message = "kjbkbkb";
    char[ClientPacket.sizeof] buffer = p.serialize;
    assert((buffer.sizeof == 88));
}