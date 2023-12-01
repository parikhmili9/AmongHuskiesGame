import std.stdio;
// import server : TCPServer;
import clientpacket;
import deserializeClient;



void main()
{
	// TCPServer server = new TCPServer;
	// server.run();
	char[ClientPacket.sizeof] buffer;

	ClientPacket p;
	p.client_id = 'c';
	p.move_num = 2;
	p.message = "bvjdsbvjb";

	buffer = p.serialize();

	writeln(buffer);
	ClientPacket r = deserialize(buffer);
	writeln(r.move_num);

}
