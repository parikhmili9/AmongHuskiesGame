module source.server;

import std.socket;
import std.stdio;
import core.thread.osthread;
import packet;
import clientpacket;
import deserializeClient;

// import model.source.huskyplayground: HuskyPlayGround;
import huskyplayground : HuskyPlayGround;

// The purpose of the TCPServer is to accept multiple client connections. 
// Every client that connects will have its own thread for the server to broadcast information to each client.
class TCPServer
{

    /// Constructor
    /// By default I have choosen localhost and a port that is likely to
    /// be free.
    this(string host = "localhost", ushort port = 50001, ushort maxConnectionsBacklog = 4)
    {
        writeln("Starting server...");
        writeln("Server must be started before clients may join");

        mListeningSocket = new Socket(AddressFamily.INET, SocketType.STREAM);

        mListeningSocket.bind(new InternetAddress(host, port));

        mListeningSocket.listen(maxConnectionsBacklog);
    }

    /// Destructor
    ~this()
    {
        // Close our server listening socket
        mListeningSocket.close();
    }

    /// Call this after the server has been created to start running the server
    void run()
    {
        bool serverIsRunning = true;
        while (serverIsRunning)
        {
            // The servers job now is to just accept connections
            writeln("Waiting to accept more connections");
            /// accept is a blocking call.
            auto newClientSocket = mListeningSocket.accept();
            // After a new connection is accepted, let's confirm.
            writeln("Hey, a new client joined!");
            writeln("(me)", newClientSocket.localAddress(), "<---->", newClientSocket.remoteAddress(), "(client)");

            mClientsConnectedToServer ~= newClientSocket;
            // Set the current client to have '0' total messages received.
            mCurrentMessageToSend ~= 0;

            writeln("Friends on server = ", mClientsConnectedToServer.length);
            // Let's send our new client friend a welcome message
            newClientSocket.send("Hello friend\0");

            // Now we'll spawn a new thread for the client that
            // has recently joined.
            // The server will now be running multiple threads and
            // handling a chat here with clients.
            //
            // NOTE: The index sent indicates the connection in our data structures,
            //       this can be useful to identify different clients.
            new Thread({ clientLoop(newClientSocket); }).start();
        }
    }

    // Function to spawn from a new thread for the client.
    // The purpose is to listen for data sent from the client and then rebroadcast that information to all other clients.
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

    // This is the packet that is to be sent by the server to each client. 
    //  This has to be in the form of server packet. 
    // The information to this packet will be fed by the game logic

    // Also note that in this language, 2d array is as follows: int[num Columns][num rows]!
    char[Packet.sizeof] packetToBeSent(int[2][4] playerCoords, char[4] playerAssignment, int[2][2] ballCoords, char[80] message)
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

    void broadcastMessage(char[Packet.sizeof] buffer)
    {
        foreach (clientSocket; mClientsConnectedToServer)
        {
            // Don't send the message back to the sender
            // if (clientSocket != senderSocket)
            // {
            // Assuming serializeClient is a function that serializes a string as a ClientPacket

            clientSocket.send(buffer);
            // }
        }
    }

    /// Take out the server data from the list and process it.  
    void broadcastToAllClients()
    {
        char[Packet.sizeof] send;

        /// Processes each data as soon as it sees it and if there's a queue,
        /// The mcurrentMessageToSend takes the one that came first and processes it 
        /// Before processing the latest one. 

        writeln("Broadcasting to :", mClientsConnectedToServer.length);
        foreach (idx, serverToClient; mClientsConnectedToServer)
        {
            // Send whatever the latest data was to all the 
            // clients.
            while (mCurrentMessageToSend[idx] <= mServerData.length - 1)
            {

                char[ClientPacket.sizeof] msg = mServerData[mCurrentMessageToSend[idx]];
                send = checkValid(deserialize(msg));
                writeln("Sending this");
                writeln(send);
                serverToClient.send(send);
                // Important to increment the message only after sending
                // the previous message to as many clients as exist.
                mCurrentMessageToSend[idx]++;
            }
        }
    }

    // _--------------- [ToDO]----------------------------
    /// If the processed data is valid, give the transformed data
    /// In the form of serialized server packet, and if not, 
    /// Return the serialized packet to be unchanged.
    char[Packet.sizeof] checkValid(ClientPacket data)
    {
        char[Packet.sizeof] sen; /// Use the function "packet to be sent" to serialize this.
        char clientId = data.client_id;
        int command = data.move_num;
        char[80] msg = data.message;

        // 1. Move Left
        // 2. Move Right
        // 3. Move Up
        // 4. Move Down
        // 5. Pick up Ball
        // 6. Drop off Ball

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
    // ----------------[ToDO Ends]------------------------

    Packet serverPacket;

    /// The listening socket is responsible for handling new client connections.
    Socket mListeningSocket;
    /// Stores the clients that are currently connected to the server.
    Socket[] mClientsConnectedToServer;

    /// Stores all of the data on the server. Ideally, we'll 
    /// use this to broadcast out to clients connected.
    char[ClientPacket.sizeof][] mServerData;

    /// Keeps track of the last message that was broadcast out to each client.
    uint[] mCurrentMessageToSend;
    HuskyPlayGround h = new HuskyPlayGround();
}

// void main()
// {
//     // Note: I'm just using the defaults here.
//     TCPServer server = new TCPServer;
//     HuskyPlayGround h = new HuskyPlayGround();
//     string path = "HuskyPlayground.txt";
//     h.readTextFile(path);
//     server.run();
// }
