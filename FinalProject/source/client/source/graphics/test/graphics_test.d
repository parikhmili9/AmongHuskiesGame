module graphics_test;
import source.graphics.sdl_client;

// verify the creation of a window for our client app
unittest {
   	SDLClient client = new SDLClient();
    assert(client.window != null);
}