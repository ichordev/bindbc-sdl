/*
 * Logic implementation of the Snake game. It is designed to efficiently
 * represent in memory the state of the game.
 *
 * This code is public domain. Feel free to use it for any purpose!
 */

import bindbc.sdl;

enum STEP_RATE_IN_MILLISECONDS = 125;
enum SNAKE_BLOCK_SIZE_IN_PIXELS = 24;
enum SDL_WINDOW_WIDTH  = SNAKE_BLOCK_SIZE_IN_PIXELS * SNAKE_GAME_WIDTH;
enum SDL_WINDOW_HEIGHT = SNAKE_BLOCK_SIZE_IN_PIXELS * SNAKE_GAME_HEIGHT;

enum SNAKE_GAME_WIDTH  = 24U;
enum SNAKE_GAME_HEIGHT = 18U;
enum SNAKE_MATRIX_SIZE = (SNAKE_GAME_WIDTH * SNAKE_GAME_HEIGHT);

enum THREE_BITS = 0x7U; /* ~CHAR_MAX >> (CHAR_BIT - SNAKE_CELL_MAX_BITS) */

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	if(!loadSDL()){
		import core.stdc.stdio, bindbc.loader;
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

auto SHIFT(byte x, byte y) => (x + (y * SNAKE_GAME_WIDTH)) * SNAKE_CELL_MAX_BITS;

alias SnakeCell = uint;
enum{
	SNAKE_CELL_NOTHING = 0U,
	SNAKE_CELL_SRIGHT = 1U,
	SNAKE_CELL_SUP = 2U,
	SNAKE_CELL_SLEFT = 3U,
	SNAKE_CELL_SDOWN = 4U,
	SNAKE_CELL_FOOD = 5U,
}

enum SNAKE_CELL_MAX_BITS = 3U; /* floor(log2(SNAKE_CELL_FOOD)) + 1 */

alias SnakeDirection = byte;
enum: byte{
	SNAKE_DIR_RIGHT,
	SNAKE_DIR_UP,
	SNAKE_DIR_LEFT,
	SNAKE_DIR_DOWN,
}

struct SnakeContext{
	ubyte[(SNAKE_MATRIX_SIZE * SNAKE_CELL_MAX_BITS) / 8U] cells;
	byte headXPos;
	byte headYPos;
	byte tailXPos;
	byte tailYPos;
	SnakeDirection nextDir;
	byte inhibitTailStep;
	uint occupiedCells;
}

struct AppState{
	SDL_Window* window;
	SDL_Renderer* renderer;
	SDL_TimerID stepTimer;
	SnakeContext snakeCtx;
}

SnakeCell snake_cell_at(const SnakeContext* ctx, byte x, byte y){
	const int shift = SHIFT(x, y);
	ushort range;
	SDL_memcpy(&range, &ctx.cells[0] + (shift / 8), range.sizeof);
	return cast(SnakeCell)((range >> (shift % 8)) & THREE_BITS);
}

void set_rect_xy_(SDL_FRect* r, short x, short y){
	r.x = cast(float)(x * SNAKE_BLOCK_SIZE_IN_PIXELS);
	r.y = cast(float)(y * SNAKE_BLOCK_SIZE_IN_PIXELS);
}

void put_cell_at_(SnakeContext* ctx, byte x, byte y, SnakeCell ct){
	const int shift = SHIFT(x, y);
	const int adjust = shift % 8;
	ubyte* pos = &ctx.cells[0] + (shift / 8);
	ushort range;
	SDL_memcpy(&range, pos, range.sizeof);
	range &= ~(THREE_BITS << adjust); /* clear bits */
	range |= (ct & THREE_BITS) << adjust;
	SDL_memcpy(pos, &range, range.sizeof);
}

int are_cells_full_(SnakeContext* ctx){
	return ctx.occupiedCells == SNAKE_GAME_WIDTH * SNAKE_GAME_HEIGHT;
}

void new_food_pos_(SnakeContext* ctx){
	while(true){
		const byte x = cast(byte)SDL_rand(SNAKE_GAME_WIDTH);
		const byte y = cast(byte)SDL_rand(SNAKE_GAME_HEIGHT);
		if(snake_cell_at(ctx, x, y) == SNAKE_CELL_NOTHING){
			put_cell_at_(ctx, x, y, SNAKE_CELL_FOOD);
			break;
		}
	}
}

void snakeInitialise(SnakeContext* ctx){
	int i;
	ctx.cells[] = 0;
	ctx.headXPos = ctx.tailXPos = SNAKE_GAME_WIDTH / 2;
	ctx.headYPos = ctx.tailYPos = SNAKE_GAME_HEIGHT / 2;
	ctx.nextDir = SNAKE_DIR_RIGHT;
	ctx.inhibitTailStep = ctx.occupiedCells = 4;
	--ctx.occupiedCells;
	put_cell_at_(ctx, ctx.tailXPos, ctx.tailYPos, SNAKE_CELL_SRIGHT);
	for(i = 0; i < 4; i++){
		new_food_pos_(ctx);
		++ctx.occupiedCells;
	}
}

void snake_redir(SnakeContext* ctx, SnakeDirection dir){
	SnakeCell ct = snake_cell_at(ctx, ctx.headXPos, ctx.headYPos);
	if((dir == SNAKE_DIR_RIGHT && ct != SNAKE_CELL_SLEFT) ||
		(dir == SNAKE_DIR_UP && ct != SNAKE_CELL_SDOWN) ||
		(dir == SNAKE_DIR_LEFT && ct != SNAKE_CELL_SRIGHT) ||
		(dir == SNAKE_DIR_DOWN && ct != SNAKE_CELL_SUP)){
		ctx.nextDir = dir;
	}
}

void wrap_around_(byte* val, byte max){
	if(*val < 0){
		*val = cast(byte)(max - 1);
	}else if(*val > max - 1){
		*val = 0;
	}
}

void snake_step(SnakeContext* ctx){
	const SnakeCell dir_as_cell = (SnakeCell)(ctx.nextDir + 1);
	SnakeCell ct;
	byte prevXPos;
	byte prevYPos;
	/* Move tail forward */
	if(--ctx.inhibitTailStep == 0){
		++ctx.inhibitTailStep;
		ct = snake_cell_at(ctx, ctx.tailXPos, ctx.tailYPos);
		put_cell_at_(ctx, ctx.tailXPos, ctx.tailYPos, SNAKE_CELL_NOTHING);
		switch(ct){
		case SNAKE_CELL_SRIGHT:
			ctx.tailXPos++;
			break;
		case SNAKE_CELL_SUP:
			ctx.tailYPos--;
			break;
		case SNAKE_CELL_SLEFT:
			ctx.tailXPos--;
			break;
		case SNAKE_CELL_SDOWN:
			ctx.tailYPos++;
			break;
		default:
			break;
		}
		wrap_around_(&ctx.tailXPos, SNAKE_GAME_WIDTH);
		wrap_around_(&ctx.tailYPos, SNAKE_GAME_HEIGHT);
	}
	/* Move head forward */
	prevXPos = ctx.headXPos;
	prevYPos = ctx.headYPos;
	switch(ctx.nextDir){
		case SNAKE_DIR_RIGHT:
			++ctx.headXPos;
			break;
		case SNAKE_DIR_UP:
			--ctx.headYPos;
			break;
		case SNAKE_DIR_LEFT:
			--ctx.headXPos;
			break;
		case SNAKE_DIR_DOWN:
			++ctx.headYPos;
			break;
		default:
	}
	wrap_around_(&ctx.headXPos, SNAKE_GAME_WIDTH);
	wrap_around_(&ctx.headYPos, SNAKE_GAME_HEIGHT);
	/* Collisions */
	ct = snake_cell_at(ctx, ctx.headXPos, ctx.headYPos);
	if(ct != SNAKE_CELL_NOTHING && ct != SNAKE_CELL_FOOD){
		snakeInitialise(ctx);
		return;
	}
	put_cell_at_(ctx, prevXPos, prevYPos, dir_as_cell);
	put_cell_at_(ctx, ctx.headXPos, ctx.headYPos, dir_as_cell);
	if(ct == SNAKE_CELL_FOOD){
		if(are_cells_full_(ctx)){
			snakeInitialise(ctx);
			return;
		}
		new_food_pos_(ctx);
		++ctx.inhibitTailStep;
		++ctx.occupiedCells;
	}
}

uint sdl_timer_callback_(void* payload, SDL_TimerID timerID, uint interval){
	/* NOTE: snake_step is not called here directly for multithreaded concerns. */
	SDL_Event event;
	(cast(ubyte*)&event)[0..SDL_Event.sizeof] = 0;
	event.type = SDL_EVENT_USER;
	SDL_PushEvent(&event);
	return interval;
}

int handle_key_event_(SnakeContext* ctx, SDL_Scancode keyCode){
	switch(keyCode){
		/* Quit. */
		case SDL_SCANCODE_ESCAPE:
		case SDL_SCANCODE_Q:
			return SDL_APP_SUCCESS;
		/* Restart the game as if the program was launched. */
		case SDL_SCANCODE_R:
			snakeInitialise(ctx);
			break;
		/* Decide new direction of the snake. */
		case SDL_SCANCODE_RIGHT:
			snake_redir(ctx, SNAKE_DIR_RIGHT);
			break;
		case SDL_SCANCODE_UP:
			snake_redir(ctx, SNAKE_DIR_UP);
			break;
		case SDL_SCANCODE_LEFT:
			snake_redir(ctx, SNAKE_DIR_LEFT);
			break;
		case SDL_SCANCODE_DOWN:
			snake_redir(ctx, SNAKE_DIR_DOWN);
			break;
		default:
	}
	return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppIterate(void* appState){
	AppState* as;
	SnakeContext* ctx;
	SDL_FRect r;
	ubyte i, j;
	int ct;
	as = cast(AppState*)appState;
	ctx = &as.snakeCtx;
	r.w = r.h = SNAKE_BLOCK_SIZE_IN_PIXELS;
	SDL_SetRenderDrawColour(as.renderer, 0, 0, 0, 255);
	SDL_RenderClear(as.renderer);
	for(i = 0; i < SNAKE_GAME_WIDTH; i++){
		for(j = 0; j < SNAKE_GAME_HEIGHT; j++){
			ct = snake_cell_at(ctx, i, j);
			if(ct == SNAKE_CELL_NOTHING)
				continue;
			set_rect_xy_(&r, i, j);
			if(ct == SNAKE_CELL_FOOD)
				SDL_SetRenderDrawColour(as.renderer, 80, 80, 255, 255);
			else /* body */
				SDL_SetRenderDrawColour(as.renderer, 0, 128, 0, 255);
			SDL_RenderFillRect(as.renderer, &r);
		}
	}
	SDL_SetRenderDrawColour(as.renderer, 255, 255, 0, 255); /*head*/
	set_rect_xy_(&r, ctx.headXPos, ctx.headYPos);
	SDL_RenderFillRect(as.renderer, &r);
	SDL_RenderPresent(as.renderer);
	return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	if(!SDL_Init(SDL_INIT_VIDEO)){
		return SDL_APP_FAILURE;
	}
	
	AppState* as = cast(AppState*)SDL_calloc(1, AppState.sizeof);
	
	*appState = as;
	
	if(!SDL_CreateWindowAndRenderer("examples/game/snake", SDL_WINDOW_WIDTH, SDL_WINDOW_HEIGHT, 0, &as.window, &as.renderer)){
		return SDL_APP_FAILURE;
	}
	
	snakeInitialise(&as.snakeCtx);
	
	as.stepTimer = SDL_AddTimer(STEP_RATE_IN_MILLISECONDS, &sdl_timer_callback_, null);
	if(as.stepTimer == 0){
		return SDL_APP_FAILURE;
	}
	
	return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	SnakeContext* ctx = &(cast(AppState*)appState).snakeCtx;
	switch(event.type){
		case SDL_EVENT_QUIT:
			return SDL_APP_SUCCESS;
		case SDL_EVENT_USER:
			snake_step(ctx);
			break;
		case SDL_EVENT_KEY_DOWN:
			return cast(SDL_AppResult)handle_key_event_(ctx, event.key.scancode);
		default:
	}
	return SDL_APP_CONTINUE;
}

void SDL_AppQuit(void* appState, SDL_AppResult result){
	if(auto as = cast(AppState*)appState){
		SDL_RemoveTimer(as.stepTimer);
		SDL_DestroyRenderer(as.renderer);
		SDL_DestroyWindow(as.window);
		SDL_free(as);
	}
}
