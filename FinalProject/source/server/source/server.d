/**
 * Module: source.server
 *
 * Description: This module defines a TCPServer class for a simple multiplayer game server.
 * The server accepts multiple client connections, assigns player IDs, and
 * broadcasts game state information to connected clients.
 */
module source.server;

// Import
import std.socket;
import std.stdio;
import std.range;
import core.thread.osthread;
import server.source.packet.packet;
import server.source.packet.client_packet;
import server.source.packet.deserialize_client;
import server.source.model.husky_playground : HuskyPlayGround;

/**
 * Class: TCPServer
 *
 * Description: The purpose of TCPServer is to accept multiple client connections.
 * Each connected client has its own thread for server communication.
 */
class TCPServer
{
    HuskyPlayGround h;

    char[4] playersList;
    char[] playerListDup;
    Packet serverPacket;

    /// The listening socket is responsible for handling new client connections.
    Socket mListeningSocket;

    /// Stores the clients that are currently connected to the server.
    Socket[] mClientsConnectedToServer;

    /// Stores all of the data on the server. Ideally, we'll 
    /// Use this to broadcast out to clients connected.
    char[ClientPacket.sizeof][] mServerData;

    /// Keeps track of the last message that was broadcast out to each client.
    uint[] mCurrentMessageToSend;

    /**
    * Constructor: this
    *
    * Description: Initializes the TCPServer with default values.
    *
    * Params:
    *      host = Hostname (default is "localhost").
    *      port = Port number (default is 50001).
    *      maxConnectionsBacklog = Maximum connections backlog (default is 4).
    */
    this(string host = "localhost", ushort port = 50001, ushort maxConnectionsBacklog = 4)
    {
        writeln("Starting server...");
        writeln("Server must be started before clients may join");

        h = new HuskyPlayGround();
        h.initialize();
        playersList = h.getPlayerNames();
        playerListDup = playersList.dup;

        mListeningSocket = new Socket(AddressFamily.INET, SocketType.STREAM);

        mListeningSocket.bind(new InternetAddress(host, port));

        mListeningSocket.listen(maxConnectionsBacklog);
    }

    /**
    * Destructor: ~this
    *
    * Description: Closes the server listening socket.
    */
    ~this()
    {
        // Close our server listening socket
        mListeningSocket.close();
    }

    /**
    * Method: run
    *
    * Description: This method is called after the server has been created to start running 
    * the server. Listens for new connections and spawns threads for each connected client.
    */
    void run()
    {
        bool serverIsRunning = true;
        while (serverIsRunning)
        {
            // Accept connections
            writeln("Waiting to accept more connections");

            /// Accept is a blocking call.
            auto newClientSocket = mListeningSocket.accept();

            // Confirm after a new connection is accepted.
            writeln("Hey, a new client joined!");
            writeln("(me)", newClientSocket.localAddress(), "<---->", newClientSocket.remoteAddress(), "(client)");

            mClientsConnectedToServer ~= newClientSocket;

            // Set the current client to have '0' total messages received.
            mCurrentMessageToSend ~= 0;

            writeln("Friends on server = ", mClientsConnectedToServer.length);

            char clientIdToSend;
            if (!playerListDup.empty)
            {
                clientIdToSend = playerListDup[0];
                playerListDup.popFront();
                ubyte[] data_clientIdToSend = [cast(ubyte) clientIdToSend];
                newClientSocket.send(data_clientIdToSend);
                writeln("Sent to client: ", clientIdToSend);
            }
            else
            {
                char specId = '$';
                ubyte[] data_clientIdToSendForSpec = [cast(ubyte) specId];
                newClientSocket.send(data_clientIdToSendForSpec);
                write("Send to spectator clients: ", specId);
            }

            newClientSocket.send(initialPacketToClients());
            writeln("Initial packet send to clients");

            // Spawn a new thread for the client that has recently joined.
            // The server will now be running multiple threads and
            // handling a chat here with clients.
            new Thread({ clientLoop(newClientSocket); }).start();
        }
    }

    /**
    * Method: clientLoop
    *
    * Description: This is a function to spawn from a new thread for each client.
    * Listens for data from the client and rebroadcasts it to all other clients.
    *
    * Params:
    *      clientSocket = Socket for the connected client.
    */
    void clientLoop(Socket clientSocket)
    {
        writeln("\t Starting clientLoop:(me)", clientSocket.localAddress(), "<---->", clientSocket.remoteAddress(), "(client)");

        try
        {
            while (true)
            {
                // Message buffer will be 80 bytes
                char[ClientPacket.sizeof] buffer;

                // Server is now waiting to handle data from a specific client
                // We'll block the server awaiting to receive a message.
                auto got = clientSocket.receive(buffer);

                // Check if the client disconnected
                if (got == -1)
                {
                    writeln("Client disconnected");
                    break;
                }
                writeln("Received some data (bytes): ", got);

                // Store data that we receive in our server.
                // We append the buffer to the end of our received data queue. Dlang doesn't have queues
                // So we have to use arrays!
                if (buffer[0] == '~')
                {
                    ClientPacket message = deserialize(buffer);
                    char[Packet.sizeof] sen;
                    sen = packetToBeSent(h.getUpdatedPlayerLocations(), h.getPlayerNames(), h.getBallCoords(), message
                            .message);
                    broadcastMessage(sen);
                }
                else
                {
                    mServerData ~= buffer;
                    writeln("Got this from client:");
                    writeln(buffer);

                    /// After we receive a single message, we'll just 
                    /// immediately broadcast out to all clients some data.
                    broadcastToAllClients();
                }
            }
        }
        catch (Throwable t)
        {
            // Exception occurs when the client disconnects
            writeln("Exception: ", t.msg);
        }

        // Remove the disconnected client from the list
        for (size_t i = 0; i < mClientsConnectedToServer.length; ++i)
        {
            if (mClientsConnectedToServer[i] == clientSocket)
            {
                mClientsConnectedToServer = mClientsConnectedToServer[0 .. i] ~ mClientsConnectedToServer[(
                        i + 1) .. $];
                break;
            }
        }
    }

    /**
    * Method: packetToBeSent
    * 
    * Description: This method constructs a serialized packet to be sent to the server.
    * It takes various game-related data, such as player coordinates,
    * player assignments, ball coordinates, and a message, and constructs a packet
    * to be sent to the server. The packet is then serialized using the `serialize()`
    * method of the `serverPacket` struct.
    *
    * Params: 
    *      playerCoords = A 2D array representing the coordinates of four players.
    *      playerAssignment = An array representing player assignments (char[4]).
    *      ballCoords = A 2D array representing the coordinates of two balls.
    *      message = A string message with a maximum length of 80 characters.
    *
    * Returns: A serialized packet ready to be sent to the server.
    */
    char[Packet.sizeof] packetToBeSent(
        int[2][4] playerCoords,
        char[4] playerAssignment,
        int[2][2] ballCoords,
        char[80] message
    )
    {
        char[Packet.sizeof] sending;

        serverPacket.player1Coords = playerCoords[0];
        serverPacket.player2Coords = playerCoords[1];
        serverPacket.player3Coords = playerCoords[2];
        serverPacket.player4Coords = playerCoords[3];

        serverPacket.playerAssignment = playerAssignment;

        serverPacket.ball1Coords = ballCoords[0];
        serverPacket.ball2Coords = ballCoords[1];
        serverPacket.message = message;

        sending = serverPacket.serialize();

        return sending;
    }

    /**
    * Method: dummyPacket
    *
    * Description: This method generates a dummy packet for testing purposes.
    * It creates a dummy packet with predefined player coordinates,
    * ball coordinates, player labels, and an empty message.
    *
    * Returns: A char array representing the dummy packet.
    */
    char[Packet.sizeof] dummyPacket()
    {
        int[2][4] pCoords = [[3, 10], [10, 10], [17, 3], [17, 20]];
        int[2][2] bCoords = [[17, 0], [20, 25]];
        char[4] players = ['A', 'B', 'C', 'D'];
        char[80] msg = '\0';
        return packetToBeSent(pCoords, players, bCoords, msg);
    }

    /**
    * Method: initialPacketToClients
    *
    * Description: This method generates an initial packet to be sent to clients.
    * It retrieves updated player locations, ball coordinates, and player names
    * to construct an initial packet for communication with clients.
    *
    * Returns: A character array representing the packet to be sent.
    */
    char[Packet.sizeof] initialPacketToClients()
    {
        int[2][4] pCoords = h.getUpdatedPlayerLocations();
        writeln(pCoords);
        int[2][2] bCoords = h.getBallCoords();
        char[4] playerChar = h.getPlayerNames();
        char[80] msg = '\0';
        return packetToBeSent(pCoords, playerChar, bCoords, msg);
    }

    /**
    * Method: broadcastMessage
    *
    * Description: This method broadcasts a message to all connected clients.
    * This function sends a provided buffer (message packet) to all clients
    * currently connected to the server. It utilizes a foreach loop to iterate
    * through the list of client sockets and sends the message to each client.
    *
    * Params:
    *      buffer = A character array representing the message packet to be broadcasted.
    */
    void broadcastMessage(char[Packet.sizeof] buffer)
    {
        foreach (clientSocket; mClientsConnectedToServer)
        {
            clientSocket.send(buffer);
        }
    }

    /**
    * Method: broadcastToAllClients
    *
    * Description: This is a method that takes out the server data 
    * from the list and process it.
    */
    void broadcastToAllClients()
    {
        char[Packet.sizeof] send;

        /// Processes each data as soon as it sees it and if there's a queue,
        /// The mcurrentMessageToSend takes the one that came first and processes it 
        /// Before processing the latest one. 
        writeln("Broadcasting to :", mClientsConnectedToServer.length);
        foreach (idx, serverToClient; mClientsConnectedToServer)
        {
            // Send whatever the latest data was to all the clients.
            while (mCurrentMessageToSend[idx] <= mServerData.length - 1)
            {
                char[ClientPacket.sizeof] msg = mServerData[mCurrentMessageToSend[idx]];
                send = checkValid(deserialize(msg));
                writeln("Sending this");
                writeln(send);
                serverToClient.send(send);
                mCurrentMessageToSend[idx]++;
            }
        }
    }

    /**
    * Method: checkValid
    *
    * Description: Checks the validity of a ClientPacket and performs corresponding actions.
    * It takes a ClientPacket as input, extracts relevant information such as
    * client ID, move number, and message. It then processes the move based on the command
    * received and updates player locations, player names, ball coordinates, and the message.
    *
    * Params: 
    *      data = The ClientPacket to be validated and processed.
    * 
    * Returns: A char array representing the packet to be sent as a response.
    */
    char[Packet.sizeof] checkValid(ClientPacket data)
    {
        char[Packet.sizeof] sen;
        char clientId = data.client_id;
        int command = data.move_num;
        char[80] msg = data.message;

        string playerName = "";
        playerName ~= clientId;
        if (command == 1)
        {
            h.movePlayerLeft(playerName);
        }
        else if (command == 2)
        {
            h.movePlayerRight(playerName);
        }
        else if (command == 3)
        {
            h.movePlayerUp(playerName);
        }
        else if (command == 4)
        {
            h.movePlayerDown(playerName);
        }

        sen = packetToBeSent(h.getUpdatedPlayerLocations(), h.getPlayerNames(), h.getBallCoords(), msg);
        return sen;
    }
}
