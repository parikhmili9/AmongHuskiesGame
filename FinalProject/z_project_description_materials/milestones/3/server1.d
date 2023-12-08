import std.socket;
import std.stdio;
import core.thread.osthread;

import std.stdio;
import std.socket;
import std.conv;
import std.algorithm;
import std.range;
import std.array;


// Following is the temporary "Game" Class! The actual game itself will be imported to the
// Server in the form of a class called game, that will contain the list of players,
// The game grid, timemaps and other functionalities of that game. 
class Game
{
    public:
        int [] players;
        int[][] grid;

    public:
        this(int[] p = [1,2,3,4]){
            this.players = p;
            for(int i =0; i< 10; i++){
                for (int j = 0; j < 10; j++){
                    this.grid ~= [(i, j)];
                }
            }
        }
        bool isValid(int[][] state) {
            writeln("To Be Implemented");
        }
    
    
}


// The purpose of the TCPServer is to accept multiple client connections. 
// Every client that connects will have its own thread for the server to broadcast information to each client.
class TCPServer{

    /// Constructor
    /// By default I have choosen localhost and a port that is likely to
    /// be free.
    this(string host = "localhost", ushort port=50001, ushort maxConnectionsBacklog=4){
        writeln("Starting server...");
        writeln("Server must be started before clients may join");

        mListeningSocket = new Socket(AddressFamily.INET, SocketType.STREAM);

        mListeningSocket.bind(new InternetAddress(host,port));

        mListeningSocket.listen(maxConnectionsBacklog);
    }

    /// Destructor
    ~this(){
        // Close our server listening socket
        mListeningSocket.close();
    }

    /// Call this after the server has been created to start running the server
    void run(){
        bool serverIsRunning=true;
        while(serverIsRunning){
            // The servers job now is to just accept connections
            writeln("Waiting to accept more connections");
            /// accept is a blocking call.
            auto newClientSocket = mListeningSocket.accept();
            // After a new connection is accepted, let's confirm.
            writeln("Hey, a new client joined!");
            writeln("(me)",newClientSocket.localAddress(),"<---->",newClientSocket.remoteAddress(),"(client)");

            mClientsConnectedToServer ~= newClientSocket;
            // Set the current client to have '0' total messages received.
            mCurrentMessageToSend ~= 0;

            writeln("Friends on server = ",mClientsConnectedToServer.length);
            // Let's send our new client friend a welcome message
            newClientSocket.send("Hello friend\0");

            // Now we'll spawn a new thread for the client that
            // has recently joined.
            // The server will now be running multiple threads and
            // handling a chat here with clients.
            //
            // NOTE: The index sent indicates the connection in our data structures,
            //       this can be useful to identify different clients.
            new Thread({
                    clientLoop(newClientSocket);
                }).start();
        }
    }

    // Function to spawn from a new thread for the client.
    // The purpose is to listen for data sent from the client and then rebroadcast that information to all other clients.
    void clientLoop(Socket clientSocket) {
        writeln("\t Starting clientLoop:(me)", clientSocket.localAddress(), "<---->", clientSocket.remoteAddress(), "(client)");

        try {
            while (true) {
                // Message buffer will be 80 bytes
                char[80] buffer;
                
                // Server is now waiting to handle data from a specific client
                // We'll block the server awaiting to receive a message.
                auto got = clientSocket.receive(buffer);

                // Check if the client disconnected
                if (got == -1) {
                    writeln("Client disconnected");
                    break;
                }

                writeln("Received some data (bytes): ", got);

                // Store data that we receive in our server.
                // We append the buffer to the end of our server data structure.
                mServerData ~= buffer;

                /// After we receive a single message, we'll just 
                /// immediately broadcast out to all clients some data.
                broadcastToAllClients();
            }
        } catch (Throwable t) {
            // Exception occurs when the client disconnects
            writeln("Exception: ", t.msg);
        }

        // Remove the disconnected client from the list
        for (size_t i = 0; i < mClientsConnectedToServer.length; ++i) {
            if (mClientsConnectedToServer[i] == clientSocket) {
                mClientsConnectedToServer = mClientsConnectedToServer[0 .. i] ~ mClientsConnectedToServer[(i + 1) .. $];
                break;
            }
        }
    }

    /// The purpose of this function is to broadcast
    /// messages to all of the clients that are currently
    /// connected.
    void broadcastToAllClients(){
        writeln("Broadcasting to :", mClientsConnectedToServer.length);
        foreach(idx,serverToClient; mClientsConnectedToServer){
            // Send whatever the latest data was to all the 
            // clients.
            while(mCurrentMessageToSend[idx] <= mServerData.length-1){
                char[80] msg = mServerData[mCurrentMessageToSend[idx]];
                serverToClient.send(msg[0 .. 80]);	
                // Important to increment the message only after sending
                // the previous message to as many clients as exist.
                mCurrentMessageToSend[idx]++;
            }
        }
    }

    /// The listening socket is responsible for handling new client connections.
    Socket 		mListeningSocket;
    /// Stores the clients that are currently connected to the server.
    Socket[] 	mClientsConnectedToServer;

    /// Stores all of the data on the server. Ideally, we'll 
    /// use this to broadcast out to clients connected.
    char[80][] mServerData;
    /// Keeps track of the last message that was broadcast out to each client.
    uint[] 			mCurrentMessageToSend;
}

class UDPServer
{
    private:
        UdpSocket serverSocket;
        UdpSocket[] gClientsConnectedToServer;
        ushort port;
        Game game;
        // InternetAddress[] connectedClients;

    public:
        this(string host = "localhost", ushort port=50002, ushort maxConnectionsBacklog=4)
        {
            this.port = port;
            this.game = new game();
            // this.connectedClients = InterneatAddress[];

            // Create a UDP socket
            serverSocket = new UdpSocket();

            // Bind the socket to a specific port
            serverSocket.bind(new InternetAddress(host, port));

            writeln("UDP Server is running on port ", port);

            serverSocket.listen(maxConnectionsBacklog);
        }

        ~this()
        {
            // Close the server socket
            serverSocket.close();
            writeln("UDP Server closed.");
        }

        void run()
        {
            // Check the status of the server
            bool isRunning = true;
            while (isRunning)
            {
                // The servers job now is to just accept connections
                writeln("Waiting to accept more connections");
                /// accept is a blocking call.
                auto newClientSocket = mListeningSocket.accept();
                // After a new connection is accepted, let's confirm.
                writeln("Hey, a new client joined!");

                gClientsConnectedToServer ~= newClientSocket;

                auto connected = gClientsConnectedToServer.length == 4;

                gameLoop(connected);

                new Thread({
                    listenForMessages(newClientSocket);
                }).start();


            }

            private void listenForMessages(Socket clientSocket){
                try{
                    while(true){
                        char[200] buffer;
                        // Receive incoming UDP messages
                        auto clientMessageStatus = clientSocket.receive(buffer);
                        handleMessage(clientMessageStatus, buffer);
                    }
                } catch (Throwable t){
                    writeln("Exception: ", t.msg);
                }

                 // Remove the disconnected client from the list
                for (size_t i = 0; i < gClientsConnectedToServer.length; ++i) {
                    if (gClientsConnectedToServer[i] == clientSocket) {
                        gClientsConnectedToServer = gClientsConnectedToServer[0 .. i] ~ gClientsConnectedToServer[(i + 1) .. $];
                        break;
                    }
                }
            }

            private void handlemessage(int status, char[200] buffer){
                // Implement logic for handling incoming messages
                // For example, decode the message, update game state, 
                // handle player actions, etc.
                
                
                if (status = -1){
                    writeln("Client disconnected");
                    return;
                }

                auto newState = buffer;
                //  check if the newState is a valid game state or not.
                // Practically should do it inside of the game class itself.
                if(game.isValid(newState)){
                    game.grid = newState;
                    sendGameState();
                }

            }

            // For now let the new state be just 2d int.
            private void gameLoop(bool allConnected){
                while (allConnected){
                    // Implement game logic.

                }
            }

            // Change this once we put in the correct type for the player
            private void sendGameState(){
                // Send Updated Game state to all the player.                
                serverSocket.send(game);   
                
            }
        }

}

// Entry point to Server
void main(){
	// Note: I'm just using the defaults here.
	TCPServer server = new TCPServer;
    // UDPServer udp = new UDPServer;
	server.run();
    // udp.run();
}
