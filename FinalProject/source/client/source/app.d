import std.stdio;
import client : TCPClient;
import packet : Packet, Coord;

void main()
{

	Packet p;
	p.playerCoords[0] = Coord(1, 1);
	p.playerCoords[1] = Coord(1, 2);
	p.playerCoords[2] = Coord(1, 3);
	p.playerCoords[3] = Coord(1, 4);
	p.message = "Hello\0";
	writeln(p.sizeof);

	Packet q;
	writeln(q.sizeof);
	// TCPClient client = new TCPClient();
	// client.run();
}
