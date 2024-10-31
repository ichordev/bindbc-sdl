/*
 * This example creates an SDL window and renderer, and draws a
 * rotating texture to it, reads back the rendered pixels, converts them to
 * black and white, and then draws the converted image to a corner of the
 * screen.
 *
 * This isn't necessarily an efficient thing to do--in real life one might
 * want to do this sort of thing with a render target--but it's just a visual
 * example of how to use SDL_RenderReadPixels().
 *
 * This code is public domain. Feel free to use it for any purpose!
 */

import bindbc.sdl;

/* We will use this renderer to draw into this window every frame. */
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Texture* texture = null;
int textureWidth = 0;
int textureHeight = 0;
SDL_Texture* convertedTexture = null;
int convertedTextureWidth = 0;
int convertedTextureHeight = 0;

enum WINDOW_WIDTH = 640;
enum WINDOW_HEIGHT = 480;

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
	SDL_Surface* surface = null;
	char* bmpPath = null;
	
	if(!SDL_Init(SDL_INIT_VIDEO)){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't initialise SDL!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/read-pixels", WINDOW_WIDTH, WINDOW_HEIGHT, 0, &window, &renderer)){
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't create window/renderer!", SDL_GetError(), null);
		return SDL_APP_FAILURE;
	}
	
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
	
	textureWidth = surface.w;
	textureHeight = surface.h;
	
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
	const ulong now = SDL_GetTicks();
	SDL_Surface* surface;
	SDL_FPoint centre;
	SDL_FRect dst_rect;
	
	/* we'll have a texture rotate around over 2 seconds (2000 milliseconds). 360 degrees in a circle! */
	const float rotation = ((cast(float)(cast(int)(now % 2000))) / 2000.0f) * 360.0f;
	
	/* as you can see from this, rendering draws over whatever was drawn before it. */
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255);  /* black, full alpha */
	SDL_RenderClear(renderer);  /* start with a blank canvas. */
	
	/* Centre this one, and draw it with some rotation so it spins! */
	dst_rect.x = (cast(float)(WINDOW_WIDTH - textureWidth)) / 2.0f;
	dst_rect.y = (cast(float)(WINDOW_HEIGHT - textureHeight)) / 2.0f;
	dst_rect.w = cast(float)textureWidth;
	dst_rect.h = cast(float)textureHeight;
	/* rotate it around the centre of the texture; you can rotate it from a different point, too! */
	centre.x = textureWidth / 2.0f;
	centre.y = textureHeight / 2.0f;
	SDL_RenderTextureRotated(renderer, texture, null, &dst_rect, rotation, &centre, SDL_FLIP_NONE);
	
	/* this next whole thing is _super_ expensive. Seriously, don't do this in real life. */
	
	/* Download the pixels of what has just been rendered. This has to wait for the GPU to finish rendering it and everything before it,
		and then make an expensive copy from the GPU to system RAM! */
	surface = SDL_RenderReadPixels(renderer, null);
	
	/* This is also expensive, but easier: convert the pixels to a format we want. */
	if(surface && (surface.format != SDL_PIXELFORMAT_RGBA8888) && (surface.format != SDL_PIXELFORMAT_BGRA8888)){
		SDL_Surface* converted = SDL_ConvertSurface(surface, SDL_PIXELFORMAT_RGBA8888);
		SDL_DestroySurface(surface);
		surface = converted;
	}
	
	if(surface){
		/* Rebuild convertedTexture if the dimensions have changed (window resized, etc). */
		if((surface.w != convertedTextureWidth) || (surface.h != convertedTextureHeight)){
			SDL_DestroyTexture(convertedTexture);
			convertedTexture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, surface.w, surface.h);
			if(!convertedTexture){
				SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Couldn't (re)create conversion texture!", SDL_GetError(), null);
				return SDL_APP_FAILURE;
			}
			convertedTextureWidth = surface.w;
			convertedTextureHeight = surface.h;
		}
		
		/* Turn each pixel into either black or white. This is a lousy technique but it works here.
			In real life, something like Floyd-Steinberg dithering might work
			better: https://en.wikipedia.org/wiki/Floyd%E2%80%93Steinberg_dithering*/
		int x, y;
		for(y = 0; y < surface.h; y++){
			uint* pixels = cast(uint*)((cast(ubyte*)surface.pixels) + (y * surface.pitch));
			for(x = 0; x < surface.w; x++){
				ubyte* p = cast(ubyte*)&pixels[x];
				const uint average = (cast(uint)p[1] + cast(uint)p[2] + cast(uint)p[3]) / 3;
				if(average == 0){
					p[0] = p[3] = 0xFF; p[1] = p[2] = 0;  /* make pure black pixels red. */
				}else{
					p[1] = p[2] = p[3] = (average > 50) ? 0xFF : 0x00;  /* make everything else either black or white. */
				}
			}
		}
		
		/* upload the processed pixels back into a texture. */
		SDL_UpdateTexture(convertedTexture, null, surface.pixels, surface.pitch);
		SDL_DestroySurface(surface);
		
		/* draw the texture to the top-left of the screen. */
		dst_rect.x = dst_rect.y = 0.0f;
		dst_rect.w = (cast(float)WINDOW_WIDTH) / 4.0f;
		dst_rect.h = (cast(float)WINDOW_HEIGHT) / 4.0f;
		SDL_RenderTexture(renderer, convertedTexture, null, &dst_rect);
	}
	
	SDL_RenderPresent(renderer);  /* put it all on the screen! */
	
	return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once at shutdown. */
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(convertedTexture);
	SDL_DestroyTexture(texture);
	/* SDL will clean up the window/renderer for us. */
}
