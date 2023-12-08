/**
 * Module: server.source.packet.client_packet
 * 
 * Description: This is a module for handling client packets. 
 * This module defines a structure `ClientPacket` representing a packet sent by a client
 * and provides serialization functionality.
 */
module server.source.packet.client_packet;

import core.stdc.string;

/**
 * Description: Structure representing a client packet.
 * It enables communication by sending a client id and a integer representing the move.
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
     * Method: serialize
     *
     * Description: This method converts a ClientPacket to a 
     * character buffer for server communication.
     *
     * Returns: A character buffer containing the serialized data.
     */
    char[ClientPacket.sizeof] serialize()
    {
        char[ClientPacket.sizeof] payload;
        memmove(&payload, &client_id, client_id.sizeof);
        memmove(&payload[client_id.sizeof], &move_num, move_num.sizeof);
        memmove(&payload[move_num.sizeof], &message, message.sizeof);
        return payload;
    }
}
