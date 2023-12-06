import client.source.client : TCPClient;
import source.graphics.sdl_client;
void main()
{
	// TCPClient client = new TCPClient();
	// client.run();
	SDLClient client = new SDLClient();
	client.mainApplicationLoop();
}
