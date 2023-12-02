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
    int move_num;

    // Send a message.
    char[80] message;


    this(char client_id, int move_num)
    {
        this.client_id = client_id;
        this.move_num = move_num;
    }
    char[ClientPacket.sizeof] serialize()
    {
        char[ClientPacket.sizeof] payload;
        memmove(&payload, &client_id, client_id.sizeof);
        memmove(&payload[client_id.sizeof], &move_num, move_num.sizeof);
        memmove(&payload[client_id.sizeof + move_num.sizeof], &message, message.sizeof);
        return payload;
    }
}
