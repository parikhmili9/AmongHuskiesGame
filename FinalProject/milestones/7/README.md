# Building Software
## Platform
- Our program has been tested primarily on a machine running Windows 11.
 
## Building and running software
### Note - to build this software, not 1, but 2 dub projects have been built, the client, and the server.
1. navigate to <code>FinalProject/source/server</code>
2. run <code>dub run</code>
3. navigate to <code>FinalProject/source/client</code>
4. use <code>dub run</code> to RUN 4 INSTANCES OF THIS CLIENT (critical for the program to work, otherwise the graphical application will not start)
	- This will start the main graphical application
5. To use the chat feature: In any client's terminal (spectator or player), writing text into the terminal and hitting <code>Enter</code> will broadcast that text to all other clients

## Demoing the application:
1. Take a red (orange-ish) client and use your keyboard to navigate them to the blue husky at the bottom of the tilemap.
2. Focus on other client's screens to see that they are updated with the main player's position.
3. Return your focus to the main client that you were initially moving.
4. Once you cross and pet the blue husky, you will glow with elation and your sprite will turn bright red from orange.
5. From this point, you can continue testing but know that the 'victory condition' for this game is both players of 1 team touching the husky of the opposing team. Meeting this condition will end the game and also remove any ability to chat.
6. [known bug] If the husky is fully collided into, as opposed to just tapped, it will like you so much that it will follow you
