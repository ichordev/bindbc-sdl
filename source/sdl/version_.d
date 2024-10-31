/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.version_;

import bindbc.sdl.config, bindbc.sdl.codegen;

enum{
	SDL_MAJOR_VERSION = sdlVersion.major,
	SDL_MINOR_VERSION = sdlVersion.minor,
	SDL_MICRO_VERSION = sdlVersion.patch,
}

enum SDL_VERSION = SDL_VERSIONNUM(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION);

pragma(inline,true) extern(C) nothrow @nogc pure @safe{
	int SDL_VERSIONNUM(int major, int minor, int patch) =>
		(major * 1_000_000 + minor * 1_000 + patch);
	
	short SDL_VERSIONNUM_MAJOR(int version_) => cast(short)( version_ / 1_000_000);
	short SDL_VERSIONNUM_MINOR(int version_) => cast(short)((version_ / 1_000) % 1_000);
	short SDL_VERSIONNUM_MICRO(int version_) => cast(short)( version_ % 1_000);
	
	bool SDL_VERSION_ATLEAST(int x, int y, int z) =>
		SDL_VERSION >= SDL_VERSIONNUM(x, y, z);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetVersion}, q{}},
		{q{const(char)*}, q{SDL_GetRevision}, q{}},
	];
	return ret;
}()));
