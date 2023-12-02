import std.stdio;
import source.server : TCPServer;
import clientpacket;
import deserializeClient;



void main()
{
	TCPServer server = new TCPServer;
	server.run();

}
