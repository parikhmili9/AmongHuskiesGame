/**
 * Module: client.source.client
 *
 * Description: This module defines a TCP client class that 
 * connects to a server and sends/receives messages.
 */
module client.source.client;

import std.socket;
import std.stdio;
import core.thread.osthread;
import client.source.packet.packet: Packet;
import client.source.packet.deserialize_server;
import client.source.packet.client_packet;
import client.source.deque;

/**
 * Class: TCPClient
 *
 * Description: The purpose of the TCPClient class is to connect to a server and send messages.
 */
class TCPClient
{
    /// The client socket connected to a server
    Socket mSocket;

    char clientId;
    Deque!(Packet) recieved_packets;

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
        recieved_packets = new Deque!(Packet);
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

        mSocket.receive(buffer);

        clientId = buffer[0];
        // Spin up the new thread that will just take in data from the server
        new Thread({ receiveDataFromServer(); }).start();
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
     * Getter for client Id.
     */
    char intitalize_self(){
        return clientId;
    }

    // Run the client thread to constantly send data to the server.
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

        write(">");
        while (clientRunning)
        {
            foreach (line; stdin.byLine)
            {
                write(">");

                // Send the packet of information
                char[80] fixedLine;
                fixedLine[0] = clientId;
                fixedLine[1] = ' ';
                fixedLine[2] = ':';
                fixedLine[3] =  ' ';
                foreach (i, charElement; line)
                {
                    fixedLine[i+4] = charElement;
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
                recieved_packets.push_back(serverData);
            }
        }
    }

    Packet server_packet_recieved()
    {
        Packet toBeSent;
        /// Update add the new state to the list. 
        if(recieved_packets.size() == 0){
            toBeSent.player1Coords = [-999,-999];
            return toBeSent;
        }
        toBeSent = recieved_packets.pop_front();

        return toBeSent;

    }

    /**
     * Method: sendMove
     *
     * Description: This method sends a move to the server.
     */
    void sendMove(ClientPacket info)
    {
        char[ClientPacket.sizeof] buffer;

        buffer = info.serialize();

        mSocket.send(buffer);
    }
}
