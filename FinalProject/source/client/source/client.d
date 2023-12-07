/**
 * Module: client.source.client
 *
 * Description: This module defines a TCP client class that 
 * connects to a server and sends/receives messages.
 */
module client.source.client;

// Import
import std.socket;
import std.stdio;
import core.thread.osthread;
import client.source.packet.packet;
import client.source.packet.deserialize_server;
import client.source.packet.client_packet;

/**
 * Class: TCPClient
 *
 * Description: The purpose of the TCPClient class is to connect to a server and send messages.
 */
class TCPClient
{
    /**
     * Constructor: this
     * 
     * Description: Creates a new instance of the TCPClient class.
     *
     * Params:
     *      host = The IP address of the server to connect to. Default is "localhost".
     *      port = The port number to connect to. Default is 50001.
     */
    this(string host = "localhost", ushort port = 50001)
    {
        writeln("Starting client...attempt to create socket");

        // Create a socket for connecting to a server
        mSocket = new Socket(AddressFamily.INET, SocketType.STREAM);

        writeln(port);

        // Socket needs an 'endpoint', so we determine where we are going to connect to.
        mSocket.connect(new InternetAddress(host, port));

        writeln("Client conncted to server");

        // Our client waits until we receive at least one message confirming that we are connected
        // This will be something like "Hello friend\0"
        char[80] buffer;

        auto received1 = mSocket.receive(buffer);
        writeln("(client id from server)", buffer);

        clientId = buffer[0];
        writeln("Client id is: ", clientId);
    }

    /**
     * Destructor: ~this
     * 
     * Description: Cleans up resources when the object is no longer in use.
     */
    ~this()
    {
        // Close the socket
        mSocket.close();
    }

    /**
     * Method: run
     *
     * Description: This method runs the client thread to constantly send data to the server.
     */
    void run()
    {
        writeln("Preparing to run client");
        writeln("(me)", mSocket.localAddress(), "<---->", mSocket.remoteAddress(), "(server)");
        // Buffer of data to send out
        // Choose '80' bytes of information to be sent/received

        bool clientRunning = true;

        // Spin up the new thread that will just take in data from the server
        new Thread({ receiveDataFromServer(); }).start();

        // sendMove();
        writeln("Packet sent");

        write(">");
        while (clientRunning)
        {
            foreach (line; stdin.byLine)
            {
                write(">");

                // Send the packet of information
                char[80] fixedLine;
                foreach (i, charElement; line)
                {
                    fixedLine[i] = charElement;
                }

                ClientPacket p = ClientPacket('~', -1, fixedLine);
                mSocket.send(p.serialize());
            }
        }
    }

    /**
     * Method: receiveDataFromServer
     *
     * Description: This method receives data from the server as it is broadcast out.
     */
    void receiveDataFromServer()
    {
        while (true)
        {

            char[Packet.sizeof] buffer;

            auto fromServer = buffer[0 .. mSocket.receive(buffer)];
            if (fromServer.length > 0)
            {
                Packet serverData = deserialize(buffer);
                updateGameState(serverData);
                writeln("(from server)>", serverData.message);
            }
        }
    }

    /**
     * Method: sendMove
     *
     * Description: This method sends a move to the server.
     */
    void sendMove()
    {
        char[ClientPacket.sizeof] buffer;
        /// Remove the line below ---------------

        ClientPacket pac;
        pac.client_id = 'A';
        pac.move_num = 2;
        buffer = pac.serialize();
        /// ------------------------
        /// Some logic comes here

        mSocket.send(buffer);
    }
    /// The client socket connected to a server
    Socket mSocket;

    char clientId;
}
