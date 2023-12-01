import std.stdio;
import client : TCPClient;

void main()
{
	TCPClient client = new TCPClient();
	client.run();
}
