/**
 * Module: server.source.packet.deserialize_client
 *
 * Description: This module provides functionality for deserializing client packets.
 */
module server.source.packet.deserialize_client;

// Import
import server.source.packet.client_packet;

/**
 * Method: deserialize
 *
 * Description: This method deserializes the client packet buffer to its corresponding struct.
 *
 * Params:
 *      packet = A buffer containing the serialized client packet data.
 *
 * Returns: A ClientPacket struct representing the deserialized data.
 * If the packet size is less than 2, an empty ClientPacket is returned.
 */
ClientPacket deserialize(char[ClientPacket.sizeof] packet)
{
    ClientPacket depacket;

    if (packet.sizeof < 2)
    {
        return depacket;
    }

    depacket.client_id = packet[0];
    depacket.move_num = packet[1];
    depacket.message = packet[2 .. 82];

    return depacket;
}
