import std.stdio;
import client : TCPClient;
import packet : Packet, Coord;
import sdl_app : SDLApp;

void main()
{

	SDLApp myApp = new SDLApp();
	myApp.mainApplicationLoop();
	// TCPClient client = new TCPClient();
	// client.run();
}
