module client;
import std.socket;
import std.stdio;
import core.thread.osthread;

// The purpose of the TCPClient class is to connect to a server and send messages.
class TCPClient
{

    // Constructor
    this(string host = "localhost", ushort port = 50001)
    {
        writeln("Starting client...attempt to create socket");

        // Create a socket for connecting to a server
        mSocket = new Socket(AddressFamily.INET, SocketType.STREAM);

        // Socket needs an 'endpoint', so we determine where we are going to connect to.
        mSocket.connect(new InternetAddress(host, port));
        writeln("Client conncted to server");

        // Our client waits until we receive at least one message confirming that we are connected
        // This will be something like "Hello friend\0"
        char[80] buffer;
        auto received = mSocket.receive(buffer);
        writeln("(incoming from server) ", buffer[0 .. received]);
    }

    /// Destructor 
    ~this()
    {
        // Close the socket
        mSocket.close();
    }

    // Run the client thread to constantly send data to the server.
    void run()
    {
        writeln("Preparing to run client");
        writeln("(me)", mSocket.localAddress(), "<---->", mSocket.remoteAddress(), "(server)");
        // Buffer of data to send out
        // Choose '80' bytes of information to be sent/received

        bool clientRunning = true;

        // Spin up the new thread that will just take in data from the server
        new Thread({ receiveDataFromServer(); }).start();

        write(">");
        while (clientRunning)
        {
            foreach (line; stdin.byLine)
            {
                write(">");

                // Send the packet of information
                mSocket.send(line);
            }
        }
    }

    /// Receive data from the server as it is broadcast out.
    void receiveDataFromServer()
    {
        while (true)
        {

            char[80] buffer;

            auto fromServer = buffer[0 .. mSocket.receive(buffer)];
            if (fromServer.length > 0)
            {
                writeln("(from server)>", fromServer);
            }
        }
    }
    /// The client socket connected to a server
    Socket mSocket;
}
