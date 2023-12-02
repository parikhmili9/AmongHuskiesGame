module clientpacket;


import core.stdc.string;
// Enables communication by sending a client id and a integer representing the move.
struct ClientPacket
{
    char client_id;

    // 1. Move Left
    // 2. Move Right
    // 3. Move Up
    // 4. Move Down
    // 5. Pick up Ball
    // 6. Drop off Ball
    int move_num;

    // Send a message.
    char[80] message;

    char[ClientPacket.sizeof] serialize()
    {
        char[ClientPacket.sizeof] payload;
        memmove(&payload, &client_id, client_id.sizeof);
        memmove(&payload, &move_num, move_num.sizeof);
        memmove(&payload, &message, message.sizeof);
        return payload;
    }
}
