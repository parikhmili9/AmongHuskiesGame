import std.stdio;
import client : TCPClient;
import packet;

// import sdl_app : SDLApp;

// void main()
// {

// 	SDLApp myApp = new SDLApp();
// 	myApp.mainApplicationLoop();

import deserializeServer;



void main()
{
	writeln("hello");
	// char[Packet.sizeof] buffer;

	// Packet p; 

	// int[][] cords = new int[][](4,2);
	// cords[0] = [1,2];
	// cords[1] = [1,3];
	// cords[2] = [1,4];
	// cords[3] = [1,2];

	// p.player1Coords = [1,1];
	// p.player2Coords = [1,2];
	// p.player3Coords = [1,3];
	// p.player4Coords = [1,4];
	// int[][] player; 
	// // p.playerCoords[0][] = rowVal;
	// // p.playerCoords[1][] = [1, 2];
	// // p.playerCoords[2] = [1, 3];
	// // p.playerCoords[3] = [1, 4];
	// p.playerAssignment[0] = 'R';
	// p.playerAssignment[1] = 'R';
	// p.playerAssignment[2] = 'G';
	// p.playerAssignment[3] = 'G';
	// p.ball1Coords = [0,0];
	// p.ball2Coords = [25,25];
	// p.message = "Hello";
	// buffer = p.serialize();
	// writeln(buffer);
	// // writeln(p.sizeof);
	// // writeln(player.sizeof);
	// // writeln(cords.sizeof);
	// writeln(deserialize(buffer));
	TCPClient client = new TCPClient();
	client.run();
}
