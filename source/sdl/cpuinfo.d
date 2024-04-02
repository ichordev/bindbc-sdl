/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.cpuinfo;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc;

enum SDL_CacheLineSize = 128;
alias SDL_CACHELINE_SIZE = SDL_CacheLineSize;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetCPUCount}, q{}},
		{q{int}, q{SDL_GetCPUCacheLineSize}, q{}},
		{q{SDL_Bool}, q{SDL_HasAltiVec}, q{}},
		{q{SDL_Bool}, q{SDL_HasMMX}, q{}},
		{q{SDL_Bool}, q{SDL_HasSSE}, q{}},
		{q{SDL_Bool}, q{SDL_HasSSE2}, q{}},
		{q{SDL_Bool}, q{SDL_HasSSE3}, q{}},
		{q{SDL_Bool}, q{SDL_HasSSE41}, q{}},
		{q{SDL_Bool}, q{SDL_HasSSE42}, q{}},
		{q{SDL_Bool}, q{SDL_HasAVX}, q{}},
		{q{SDL_Bool}, q{SDL_HasAVX2}, q{}},
		{q{SDL_Bool}, q{SDL_HasAVX512F}, q{}},
		{q{SDL_Bool}, q{SDL_HasARMSIMD}, q{}},
		{q{SDL_Bool}, q{SDL_HasNEON}, q{}},
		{q{SDL_Bool}, q{SDL_HasLSX}, q{}},
		{q{SDL_Bool}, q{SDL_HasLASX}, q{}},
		{q{int}, q{SDL_GetSystemRAM}, q{}},
		{q{size_t}, q{SDL_SIMDGetAlignment}, q{}},
	];
	return ret;
}()));
