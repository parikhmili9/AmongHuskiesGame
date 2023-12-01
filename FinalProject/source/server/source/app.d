import std.stdio;
import server : TCPServer;

void main()
{
	TCPServer server = new TCPServer;
	server.run();
}
