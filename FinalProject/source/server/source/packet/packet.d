module server.source.packet.packet;

import core.stdc.string;

struct Packet
{
        int[2] player1Coords;
        int[2] player2Coords;
        int[2] player3Coords;
        int[2] player4Coords;

        char[4] playerAssignment;

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
                memmove(&payload[player1Coords.sizeof + player2Coords.sizeof], &player3Coords, player3Coords
                                .sizeof);
                memmove(&payload[player1Coords.sizeof + player2Coords.sizeof + player3Coords.sizeof], &player4Coords,
                        player4Coords.sizeof);

                size_t playerChordsSize =
                        player1Coords.sizeof +
                        player2Coords.sizeof +
                        player3Coords.sizeof +
                        player4Coords.sizeof;

                memmove(&payload[playerChordsSize], &playerAssignment, playerAssignment.sizeof);

                memmove(&payload[playerChordsSize + playerAssignment.sizeof], &ball1Coords, ball1Coords
                                .sizeof);
                memmove(&payload[playerChordsSize + playerAssignment.sizeof + ball1Coords.sizeof], &ball2Coords,
                        ball2Coords.sizeof);
                memmove(&payload[playerChordsSize + playerAssignment.sizeof + ball1Coords.sizeof + ball2Coords.sizeof],
                        &message, message.sizeof);
                return payload;
        }

}
