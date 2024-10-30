/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.timer;

import bindbc.sdl.config, bindbc.sdl.codegen;

enum{
	SDL_MS_PER_SECOND  = 1000,
	SDL_US_PER_SECOND  = 1000000,
	SDL_NS_PER_SECOND  = 1000000000L,
	SDL_NS_PER_MS      = 1000000,
	SDL_NS_PER_US      = 1000,
}

pragma(inline,true) extern(C) nothrow @nogc pure @safe{
	ulong SDL_SECONDS_TO_NS(ulong s)  => cast(ulong)s * SDL_NS_PER_SECOND;
	ulong SDL_NS_TO_SECONDS(ulong ns) => ns / SDL_NS_PER_SECOND;
	ulong SDL_MS_TO_NS(ulong ms)      => cast(ulong)ms * SDL_NS_PER_MS;
	ulong SDL_NS_TO_MS(ulong ns)      => ns / SDL_NS_PER_MS;
	ulong SDL_US_TO_NS(ulong us)      => cast(ulong)us * SDL_NS_PER_US;
	ulong SDL_NS_TO_US(ulong ns)      => ns / SDL_NS_PER_US;
}

alias SDL_TimerID = uint;

extern(C) nothrow{
	alias SDL_TimerCallback = uint function(void* userData, SDL_TimerID timerID, uint interval);
	alias SDL_NSTimerCallback = ulong function(void* userData, SDL_TimerID timerID, ulong interval);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{ulong}, q{SDL_GetTicks}, q{}},
		{q{ulong}, q{SDL_GetTicksNS}, q{}},
		{q{ulong}, q{SDL_GetPerformanceCounter}, q{}},
		{q{ulong}, q{SDL_GetPerformanceFrequency}, q{}},
		{q{void}, q{SDL_Delay}, q{uint ms}},
		{q{void}, q{SDL_DelayNS}, q{ulong ns}},
		{q{SDL_TimerID}, q{SDL_AddTimer}, q{uint interval, SDL_TimerCallback callback, void* userData}},
		{q{SDL_TimerID}, q{SDL_AddTimerNS}, q{ulong interval, SDL_NSTimerCallback callback, void* userData}},
		{q{bool}, q{SDL_RemoveTimer}, q{SDL_TimerID id}},
	];
	return ret;
}()));
