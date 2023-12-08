/**
 * Module: client.source.packet.client_packet
 *
 * Description: This module defines the `ClientPacket` struct, which is used for communication
 * by sending a client ID, a move number, and a message.
 */
module client.source.packet.client_packet;

// Import
import core.stdc.string;

/**
 * Struct ClientPacket
 *
 * Description: Structure representing a client packet.
 * It enables communication by sending a client ID, a move number, and a message.
 * The packet includes a client identifier, a move number, and a message.
 */
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

    /**
     * Constructor: this()
     * 
     * Description: This constructor is for creating a ClientPacket 
     * with a client ID and a move number.
     *
     * Params:
     *      client_id = The ID of the client.
     *      move_num = The number representing the move.
     */
    this(char client_id, int move_num)
    {
        this.client_id = client_id;
        this.move_num = move_num;
    }

    /**
     * Constructor: this()
     * 
     * Description: This constructor is for creating a ClientPacket 
     * with a client ID, a move number, and a message.
     *
     * Params:
     *      client_id = The ID of the client.
     *      move_num = The number representing the move.
     *      message = An optional message associated with the packet.
     */
    this(char client_id, int move_num, char[80] message)
    {
        this.client_id = client_id;
        this.move_num = move_num;
        this.message = message;
    }

    /**
     * Method: serialize 
     * 
     * Description: This method is to serialize the ClientPacket into a char array.
     *
     * Returns: A char array representing the serialized form of the ClientPacket.
     */
    char[ClientPacket.sizeof] serialize()
    {
        char[ClientPacket.sizeof] payload;
        memmove(&payload, &client_id, client_id.sizeof);
        memmove(&payload[client_id.sizeof], &move_num, move_num.sizeof);
        memmove(&payload[client_id.sizeof + move_num.sizeof], &message, message.sizeof);
        return payload;
    }
}
