// Import
import client.source.client : TCPClient;

/**
 * This function creates an instance of TCPClient and starts it.
 */
void main()
{
	// Create an instance of TCPClient
	TCPClient client = new TCPClient();

	// Run the client
	client.run();
}
