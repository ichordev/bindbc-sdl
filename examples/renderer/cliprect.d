/*
 * This example creates an SDL window and renderer, and then draws a scene
 * to it every frame, while sliding around a clipping rectangle.
 *
 * This code is public domain. Feel free to use it for any purpose!
 */

import bindbc.sdl;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	if(!loadSDL()){
		import core.stdc.stdio, bindbc.loader;
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

enum WINDOW_WIDTH = 640;
enum WINDOW_HEIGHT = 480;
enum CLIPRECT_SIZE = 250;
enum CLIPRECT_SPEED = 200;   /* pixels per second */

/* We will use this renderer to draw into this window every frame. */
static SDL_Window* window = null;
static SDL_Renderer* renderer = null;
static SDL_Texture* texture = null;
static SDL_FPoint clipRectPosition = {0, 0};
static SDL_FPoint clipRectDirection = {0, 0};
static ulong lastTime = 0;

/* A lot of this program is examples/renderer/02-primitives, so we have a good
   visual that we can slide a clip rect around. The actual new magic in here
   is the SDL_SetRenderClipRect() function. */

/* This function runs once at startup. */
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	SDL_Surface* surface = null;
	char* bmpPath = null;
	
	if(!SDL_Init(SDL_INIT_VIDEO)){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't initialize SDL!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/clipRect", WINDOW_WIDTH, WINDOW_HEIGHT, 0, &window, &renderer)){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't create window/renderer!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	clipRectDirection.x = clipRectDirection.y = 1.0f;
	
	lastTime = SDL_GetTicks();
	
	/* Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
		engines refer to these as "sprites." We'll do a static texture (upload once, draw many
		times) with data from a bitmap file. */
	
	/* SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
		Load a .bmp into a surface, move it to a texture from there. */
	SDL_asprintf(&bmpPath, "%s/../assets/sample.bmp", SDL_GetBasePath());  /* allocate a string of the full file path */
	surface = SDL_LoadBMP(bmpPath);
	if(!surface){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't load bitmap!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	SDL_free(bmpPath);  /* done with this, the file is loaded. */
	
	texture = SDL_CreateTextureFromSurface(renderer, surface);
	if(!texture){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't create static texture!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	SDL_DestroySurface(surface);  /* done with this, the texture has a copy of the pixels now. */
	
	return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs when a new event (mouse input, keypresses, etc) occurs. */
SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	if(event.type == SDL_EVENT_QUIT){
		return SDL_APP_SUCCESS;  /* end the program, reporting success to the OS. */
	}
	return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once per frame, and is the heart of the program. */
SDL_AppResult SDL_AppIterate(void* appState){
	const SDL_Rect clipRect = {
		cast(int)SDL_roundf(clipRectPosition.x),
		cast(int)SDL_roundf(clipRectPosition.y),
		CLIPRECT_SIZE,
		CLIPRECT_SIZE,
	};
	const ulong now = SDL_GetTicks();
	const float elapsed = (cast(float)(now - lastTime)) / 1000.0f;  /* seconds since last iteration */
	const float distance = elapsed * CLIPRECT_SPEED;
	
	/* Set a new clipping rectangle position */
	clipRectPosition.x += distance * clipRectDirection.x;
	if(clipRectPosition.x < 0.0f){
		clipRectPosition.x = 0.0f;
		clipRectDirection.x = 1.0f;
	}else if(clipRectPosition.x >= (WINDOW_WIDTH - CLIPRECT_SIZE)){
		clipRectPosition.x = (WINDOW_WIDTH - CLIPRECT_SIZE) - 1;
		clipRectDirection.x = -1.0f;
	}
	
	clipRectPosition.y += distance * clipRectDirection.y;
	if(clipRectPosition.y < 0.0f){
		clipRectPosition.y = 0.0f;
		clipRectDirection.y = 1.0f;
	}else if(clipRectPosition.y >= (WINDOW_HEIGHT - CLIPRECT_SIZE)){
		clipRectPosition.y = (WINDOW_HEIGHT - CLIPRECT_SIZE) - 1;
		clipRectDirection.y = -1.0f;
	}
	SDL_SetRenderClipRect(renderer, &clipRect);
	
	lastTime = now;
	
	/* okay, now draw! */
	
	/* Note that SDL_RenderClear is _not_ affected by the clipping rectangle! */
	SDL_SetRenderDrawColour(renderer, 33, 33, 33, 255);  /* grey, full alpha */
	SDL_RenderClear(renderer);  /* start with a blank canvas. */
	
	/* stretch the texture across the entire window. Only the piece in the
		clipping rectangle will actually render, though! */
	SDL_RenderTexture(renderer, texture, null, null);
	
	SDL_RenderPresent(renderer);  /* put it all on the screen! */
	
	return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once at shutdown. */
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(texture);
	/* SDL will clean up the window/renderer for us. */
}

