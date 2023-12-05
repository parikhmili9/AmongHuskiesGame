module server.source.packet.client_packet;

import core.stdc.string;

// Enables communication by sending a client id and a integer representing the move.
struct ClientPacket
{
    char client_id;

    // 1. Move Left
    // 2. Move Right
    // 3. Move Up
    // 4. Move Down
    int move_num;

    // Send a message.
    char[80] message;

    // Converts a ClientPacket to a character buffer to be passed to the server.
    char[ClientPacket.sizeof] serialize()
    {
        char[ClientPacket.sizeof] payload;
        memmove(&payload, &client_id, client_id.sizeof);
        memmove(&payload[client_id.sizeof], &move_num, move_num.sizeof);
        memmove(&payload[move_num.sizeof], &message, message.sizeof);
        return payload;
    }
}
