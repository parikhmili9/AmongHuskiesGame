# Building Software

- [ ] Instructions on how to build your software should be written in this file
	- This is especially important if you have added additional dependencies.
	- Assume someone who has not taken this class (i.e. you on the first day) would have read, build, and run your software from scratch.
- You should have at a minimum in your project
	- [ ] A dub.json in a root directory
    	- [ ] This should generate a 'release' version of your software
  - [ ] Run your code with the latest version of d-scanner before committing your code (could be a github action)

# Platform
- Our program has been tested primarily on a machine running Windows 11.
 
# Building and running software
### Note - to build this software, not 1, but 2 dub projects have been built, the client, and the server.
1. navigate to <code>FinalProject/source/server</code>
2. run <code>dub run</code>
3. navigate to <code>FinalProject/source/client</code>
4. RUN 4 INSTANCES OF THIS CLIENT (critical for the program to work, otherwise the graphical application will not start)
	- This will start the main graphical application
5. To use the chat feature: In any client's terminal (spectator or player), writing text into the terminal and hitting <code>Enter</code> will broadcast that text to all other clients

# Demoing the application:
1. Take a red (orange-ish) client and use your keyboard to navigate them to the blue husky at the bottom of the tilemap.
2. Focus on other client's screens to see that they are updated with the main player's position.
3. Return your focus to the main client that you were initially moving.
4. Once you cross and pet the blue husky, you will glow with elation and your sprite will turn bright red from orange.
5. Navigate to your red teammate's client screen - let's see if we can win this game.
6. Navigate this client to the blue husky and move over it again - the program will now end
7. The idea here is that the characters can <b>share</b> the joy of petting the husky
8. If you re-run the program as the blue clients, you will see that the red husky will follow the blue players, and they can share in the joy of their husky companion forever

