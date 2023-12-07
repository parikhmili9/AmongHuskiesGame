// Import
import source.server : TCPServer;

/**
 * This function creates an instance of TCPServer and starts it.
 */
void main()
{
	// Create an instance of TCPServer
	TCPServer server = new TCPServer;

	// Run the server to start listening for incoming connections
	server.run();
}
