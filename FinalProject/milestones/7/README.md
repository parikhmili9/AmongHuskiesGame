# Building Software

- [ ] Instructions on how to build your software should be written in this file
	- This is especially important if you have added additional dependencies.
	- Assume someone who has not taken this class (i.e. you on the first day) would have read, build, and run your software from scratch.
- You should have at a minimum in your project
	- [ ] A dub.json in a root directory
    	- [ ] This should generate a 'release' version of your software
  - [ ] Run your code with the latest version of d-scanner before committing your code (could be a github action)
 
# Building and running software
### Note - to build this software, not 1, but 2 dub projects have been built, the client, and the server.
- To run the whole program:
1. navigate to <code>FinalProject/source/server</code>
2. run <code>dub run</code>
3. navigate to <code>FinalProject/source/client</code>
4. RUN 4 INSTANCES OF THIS CLIENT (critical for the program to work, otherwise the graphical application will not start)
	- This will start the main graphical application
5. To use the chat feature: In any client's terminal (spectator or player), writing text into the terminal and hitting <code>Enter</code> will broadcast that text to all other clients

# To demo the application...
1. Take a red client and use your keyboard to navigate them to the blue husky at the bottom of the tilemap.
   
*Modify this file to include instructions on how to build and run your software. Specify which platform you are running on. Running your software involves launching a server and connecting at least 2 clients to the server.*
