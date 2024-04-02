/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.version_;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

struct SDL_Version{
	ubyte major;
	ubyte minor;
	ubyte patch;
}

enum SDL_MajorVersion  = sdlVersion.major;
enum SDL_MinorVersion  = sdlVersion.minor;
enum SDL_PatchLevel    = sdlVersion.patch;
alias SDL_MAJOR_VERSION  = SDL_MajorVersion;
alias SDL_MINOR_VERSION  = SDL_MinorVersion;
alias SDL_PATCHLEVEL     = SDL_PatchLevel;

pragma(inline,true) nothrow @nogc pure @safe{
	void SDL_GetCompiledVersion(scope ref SDL_Version x){
		x.major = SDL_MajorVersion;
		x.minor = SDL_MinorVersion;
		x.patch = SDL_PatchLevel;
	}
	alias SDL_VERSION = SDL_GetCompiledVersion;
	
	uint SDL_VersionNum(uint x, uint y, uint z) =>
		x << 24 | y << 8 | z << 0;
	alias SDL_VERSIONNUM = SDL_VersionNum;
	
	bool SDL_VersionAtLeast(uint x, uint y, uint z) =>
		SDL_CompiledVersionNum >= SDL_VersionNum(x, y, z);
	alias SDL_VERSION_ATLEAST = SDL_VersionAtLeast;
}

enum SDL_CompiledVersionNum = SDL_VersionNum(SDL_MajorVersion, SDL_MinorVersion, SDL_PatchLevel);
alias SDL_COMPILEDVERSION = SDL_CompiledVersionNum;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetVersion}, q{SDL_Version* ver}},
		{q{const(char)*}, q{SDL_GetRevision}, q{}},
	];
	return ret;
}()));
