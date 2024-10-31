/*
 * This example creates an SDL window and renderer, and then draws some points
 * to it every frame.
 *
 * This code is public domain. Feel free to use it for any purpose!
 */

import bindbc.sdl;

/* We will use this renderer to draw into this window every frame. */
SDL_Window* window = null;
SDL_Renderer* renderer = null;
ulong last_time = 0;

enum WINDOW_WIDTH = 640;
enum WINDOW_HEIGHT = 480;

enum NUM_POINTS = 500;
enum MIN_PIXELS_PER_SECOND = 30  /* move at least this many pixels per second. */;
enum MAX_PIXELS_PER_SECOND = 60  /* move this many pixels per second at most. */;

/* (track everything as parallel arrays instead of a array of structs,
	so we can pass the coordinates to the renderer in a single function call.) */

/* Points are plotted as a set of X and Y coordinates.
	(0, 0) is the top left of the window, and larger numbers go down
	and to the right. This isn't how geometry works, but this is pretty
	standard in 2D graphics. */
SDL_FPoint[NUM_POINTS] points;
float[NUM_POINTS] pointSpeeds;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	if(!loadSDL()){
		import core.stdc.stdio, bindbc.loader;
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

/* This function runs once at startup. */
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	int i;
	
	if(!SDL_Init(SDL_INIT_VIDEO)){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't initialise SDL!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/points", WINDOW_WIDTH, WINDOW_HEIGHT, 0, &window, &renderer)){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't create window/renderer!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	/* set up the data for a bunch of points. */
	for(i = 0; i < points.length; i++){
		points[i].x = SDL_randf() * (cast(float)WINDOW_WIDTH);
		points[i].y = SDL_randf() * (cast(float)WINDOW_HEIGHT);
		pointSpeeds[i] = MIN_PIXELS_PER_SECOND + (SDL_randf() * (MAX_PIXELS_PER_SECOND - MIN_PIXELS_PER_SECOND));
	}
	
	last_time = SDL_GetTicks();
	
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
	const ulong now = SDL_GetTicks();
	const float elapsed = (cast(float)(now - last_time)) / 1000.0f;  /* seconds since last iteration */
	int i;
	
	/* let's move all our points a little for a new frame. */
	for(i = 0; i < points.length; i++){
		const float distance = elapsed * pointSpeeds[i];
		points[i].x += distance;
		points[i].y += distance;
		if((points[i].x >= WINDOW_WIDTH) || (points[i].y >= WINDOW_HEIGHT)){
			/* off the screen; restart it elsewhere! */
			if(SDL_rand(2)){
				points[i].x = SDL_randf() * (cast(float)WINDOW_WIDTH);
				points[i].y = 0.0f;
			}else{
				points[i].x = 0.0f;
				points[i].y = SDL_randf() * (cast(float)WINDOW_HEIGHT);
			}
			pointSpeeds[i] = MIN_PIXELS_PER_SECOND + (SDL_randf() * (MAX_PIXELS_PER_SECOND - MIN_PIXELS_PER_SECOND));
		}
	}
	
	last_time = now;
	
	/* as you can see from this, rendering draws over whatever was drawn before it. */
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255);  /* black, full alpha */
	SDL_RenderClear(renderer);  /* start with a blank canvas. */
	SDL_SetRenderDrawColour(renderer, 255, 255, 255, 255);  /* white, full alpha */
	SDL_RenderPoints(renderer, &points[0], points.length);  /* draw all the points! */
	
	/* You can also draw single points with SDL_RenderPoint(), but it's
		cheaper (sometimes significantly so) to do them all at once. */
	
	SDL_RenderPresent(renderer);  /* put it all on the screen! */
	
	return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once at shutdown. */
void SDL_AppQuit(void* appState, SDL_AppResult result){
	/* SDL will clean up the window/renderer for us. */
}

