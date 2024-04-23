/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.assert_;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc;

enum SDL_LilEndian = 1234;
enum SDL_BigEndian = 4321;
alias SDL_LIL_ENDIAN = SDL_LilEndian;
alias SDL_BIG_ENDIAN = SDL_BigEndian;

enum SDL_ByteOrder = (){
	version(LittleEndian)   return SDL_LilEndian;
	else version(BigEndian) return SDL_BigEndian;
	else static assert(0, "Unsupported endianness");
}();

enum SDL_FloatWordOrder = (){
	#elif defined(__MAVERICK__)
	/* For Maverick, float words are always little-endian. */
	#define SDL_FLOATWORDORDER   SDL_LIL_ENDIAN
	#elif (defined(__arm__) || defined(__thumb__)) && !defined(__VFP_FP__) && !defined(__ARM_EABI__)
	/* For FPA, float words are always big-endian. */
	#define SDL_FLOATWORDORDER   SDL_BIG_ENDIAN
	#else
	else return SDL_ByteOrder;
}();
alias SDL_FLOATWORDORDER = SDL_FloatWordOrder;

pragma(inline,true) nothrow @nogc pure @safe{
	ushort SDL_Swap16(ushort x) => cast(ushort)(
		(x << 8) | (x >> 8)
	);
	uint SDL_Swap32(uint x) => cast(uint32)(
		(x << 24) | ((x << 8) & 0x00FF0000) | ((x >> 8) & 0x0000FF00) | (x >> 24)
	);
	ulong SDL_Swap64(ulong x){
		uint lo = cast(uint)(x & 0xFFFFFFFF);
		x >>= 32;
		uint hi = cast(uint)(x & 0xFFFFFFFF);
		x = SDL_Swap32(lo);
		x <<= 32;
		x |= SDL_Swap32(hi);
		return x;
	}
	float SDL_SwapFloat(float x){
		union Swapper_{
			float f;
			uint ui32;
		}
		Swapper_ swapper;
		swapper.f = x;
		swapper.ui32 = SDL_Swap32(swapper.ui32);
		return swapper.f;
	}
	static if(SDL_ByteOrder == SDL_LilEndian){
		ushort SDL_SwapLE16(ushort x) => x;
		uint SDL_SwapLE32(uint x) => x;
		ulong SDL_SwapLE64(ulong x) => x;
		float SDL_SwapFloatLE(float x) => x;
		alias SDL_SwapBE16 = SDL_Swap16;
		alias SDL_SwapBE32 = SDL_Swap32;
		alias SDL_SwapBE64 = SDL_Swap64;
		alias SDL_SwapFloatBE = SDL_SwapFloat;
	}else{
		alias SDL_SwapLE16 = SDL_Swap16;
		alias SDL_SwapLE32 = SDL_Swap32;
		alias SDL_SwapLE64 = SDL_Swap64;
		alias SDL_SwapFloatLE = SDL_SwapFloat;
		ushort SDL_SwapBE16(ushort x) => x;
		uint SDL_SwapBE32(uint x) => x;
		ulong SDL_SwapBE64(ulong x) => x;
		float SDL_SwapFloatBE(float x) => x;
	}
}
