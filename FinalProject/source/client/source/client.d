module client.source.client;
import std.socket;
import std.stdio;
import core.thread.osthread;
import client.source.packet.packet: Packet;
import client.source.packet.deserialize_server;
import client.source.packet.client_packet;
import client.source.deque;

// The purpose of the TCPClient class is to connect to a server and send messages.
class TCPClient
{
    /// The client socket connected to a server
    Socket mSocket;

    char clientId;
    Deque!(Packet) recieved_packets;
    // Packet[] recieved_packets;

    // Constructor
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

        auto received1 = mSocket.receive(buffer);
        writeln("(client id from server)", buffer);
        clientId = buffer[0];
        writeln("Client id is: ", clientId);
        // Spin up the new thread that will just take in data from the server
        new Thread({ receiveDataFromServer(); }).start();
        writeln("Data From the server: ", recieved_packets.size());
    }

    /// Destructor 
    ~this()
    {
        // Close the socket
        mSocket.close();
    }

    /// For now this works but the server needs to send 
    /// The spawn location to the client as well for all the players
    /// Its better to do that 
    char intitalize_self(){
        return clientId;
    }

    // Run the client thread to constantly send data to the server.
    void run()
    {
        writeln("Preparing to run client");
        writeln("(me)", mSocket.localAddress(), "<---->", mSocket.remoteAddress(), "(server)");
        // Buffer of data to send out
        // Choose '80' bytes of information to be sent/received

        bool clientRunning = true;

        // // Spin up the new thread that will just take in data from the server
        // new Thread({ receiveDataFromServer(); }).start();

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

    /// Receive data from the server as it is broadcast out.
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

    void sendMove(ClientPacket info)
    {
        char[ClientPacket.sizeof] buffer;
        /// Remove the line below ---------------

        buffer = info.serialize();
        /// ------------------------
        /// Some logic comes here

        mSocket.send(buffer);
    }

}
