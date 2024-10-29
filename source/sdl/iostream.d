/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.iostream;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.properties: SDL_PropertiesID;

mixin(makeEnumBind(q{SDL_IOStatus}, members: (){
	EnumMember[] ret = [
		{{q{ready},      q{SDL_IO_STATUS_READY}}},
		{{q{error},      q{SDL_IO_STATUS_ERROR}}},
		{{q{eof},        q{SDL_IO_STATUS_EOF}}},
		{{q{notReady},   q{SDL_IO_STATUS_NOT_READY}}},
		{{q{readOnly},   q{SDL_IO_STATUS_READONLY}}},
		{{q{writeOnly},  q{SDL_IO_STATUS_WRITEONLY}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_IOWhence}, aliases: [q{SDL_IOSeek}], members: (){
	EnumMember[] ret = [
		{{q{set},  q{SDL_IO_SEEK_SET}}},
		{{q{cur},  q{SDL_IO_SEEK_CUR}}},
		{{q{end},  q{SDL_IO_SEEK_END}}},
	];
	return ret;
}()));

struct SDL_IOStreamInterface{
	uint version_;
	private extern(C) nothrow{
		alias SizeFn = c_int64 function(void* userData);
		alias SeekFn = c_int64 function(void* userData, c_int64 offset, SDL_IOWhence whence);
		alias ReadFn = size_t function(void* userData, void* ptr, size_t size, SDL_IOStatus* status);
		alias WriteFn = size_t function(void* userData, const(void)* ptr, size_t size, SDL_IOStatus* status);
		alias FlushFn = bool function(void* userData, SDL_IOStatus* status);
		alias CloseFn = bool function(void* userData);
	}
	SizeFn size;
	SeekFn seek;
	ReadFn read;
	WriteFn write;
	FlushFn flush;
	CloseFn close;
}

static assert(
	((void*).sizeof == 4 && SDL_IOStreamInterface.sizeof == 28) ||
	((void*).sizeof == 8 && SDL_IOStreamInterface.sizeof == 56)
);

struct SDL_IOStream;

enum{
	SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER    = "SDL.iostream.windows.handle",
	SDL_PROP_IOSTREAM_STDIO_FILE_POINTER        = "SDL.iostream.stdio.file",
	SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER    = "SDL.iostream.file_descriptor",
	SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER    = "SDL.iostream.android.aasset",
}

enum{
	SDL_PROP_IOSTREAM_MEMORY_POINTER      = "SDL.iostream.memory.base",
	SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER  = "SDL.iostream.memory.size",
}

enum{
	SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER    = "SDL.iostream.dynamic.memory",
	SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER  = "SDL.iostream.dynamic.chunksize",
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_IOStream*}, q{SDL_IOFromFile}, q{const(char)* file, const(char)* mode}},
		{q{SDL_IOStream*}, q{SDL_IOFromMem}, q{void* mem, size_t size}},
		{q{SDL_IOStream*}, q{SDL_IOFromConstMem}, q{const(void)* mem, size_t size}},
		{q{SDL_IOStream*}, q{SDL_IOFromDynamicMem}, q{}},
		{q{SDL_IOStream*}, q{SDL_OpenIO}, q{const(SDL_IOStreamInterface)* iface, void* userData}},
		{q{bool}, q{SDL_CloseIO}, q{SDL_IOStream* context}},
		{q{SDL_PropertiesID}, q{SDL_GetIOProperties}, q{SDL_IOStream* context}},
		{q{SDL_IOStatus}, q{SDL_GetIOStatus}, q{SDL_IOStream* context}},
		{q{c_int64}, q{SDL_GetIOSize}, q{SDL_IOStream* context}},
		{q{c_int64}, q{SDL_SeekIO}, q{SDL_IOStream* context, c_int64 offset, SDL_IOWhence whence}},
		{q{c_int64}, q{SDL_TellIO}, q{SDL_IOStream* context}},
		{q{size_t}, q{SDL_ReadIO}, q{SDL_IOStream* context, void* ptr, size_t size}},
		{q{size_t}, q{SDL_WriteIO}, q{SDL_IOStream* context, const(void)* ptr, size_t size}},
		{q{size_t}, q{SDL_IOprintf}, q{SDL_IOStream* context, const(char)* fmt, ...}},
		{q{size_t}, q{SDL_IOvprintf}, q{SDL_IOStream* context, const(char)* fmt, va_list ap}},
		{q{bool}, q{SDL_FlushIO}, q{SDL_IOStream* context}},
		{q{void*}, q{SDL_LoadFile_IO}, q{SDL_IOStream* src, size_t* dataSize, bool closeIO}},
		{q{void*}, q{SDL_LoadFile}, q{const(char)* file, size_t* dataSize}},
		{q{bool}, q{SDL_ReadU8}, q{SDL_IOStream* src, ubyte* value}},
		{q{bool}, q{SDL_ReadS8}, q{SDL_IOStream* src, byte* value}},
		{q{bool}, q{SDL_ReadU16LE}, q{SDL_IOStream* src, ushort* value}},
		{q{bool}, q{SDL_ReadS16LE}, q{SDL_IOStream* src, short* value}},
		{q{bool}, q{SDL_ReadU16BE}, q{SDL_IOStream* src, ushort* value}},
		{q{bool}, q{SDL_ReadS16BE}, q{SDL_IOStream* src, short* value}},
		{q{bool}, q{SDL_ReadU32LE}, q{SDL_IOStream* src, uint* value}},
		{q{bool}, q{SDL_ReadS32LE}, q{SDL_IOStream* src, int* value}},
		{q{bool}, q{SDL_ReadU32BE}, q{SDL_IOStream* src, uint* value}},
		{q{bool}, q{SDL_ReadS32BE}, q{SDL_IOStream* src, int* value}},
		{q{bool}, q{SDL_ReadU64LE}, q{SDL_IOStream* src, c_uint64* value}},
		{q{bool}, q{SDL_ReadS64LE}, q{SDL_IOStream* src, c_int64* value}},
		{q{bool}, q{SDL_ReadU64BE}, q{SDL_IOStream* src, c_uint64* value}},
		{q{bool}, q{SDL_ReadS64BE}, q{SDL_IOStream* src, c_int64* value}},
		{q{bool}, q{SDL_WriteU8}, q{SDL_IOStream* dst, ubyte value}},
		{q{bool}, q{SDL_WriteS8}, q{SDL_IOStream* dst, byte value}},
		{q{bool}, q{SDL_WriteU16LE}, q{SDL_IOStream* dst, ushort value}},
		{q{bool}, q{SDL_WriteS16LE}, q{SDL_IOStream* dst, short value}},
		{q{bool}, q{SDL_WriteU16BE}, q{SDL_IOStream* dst, ushort value}},
		{q{bool}, q{SDL_WriteS16BE}, q{SDL_IOStream* dst, short value}},
		{q{bool}, q{SDL_WriteU32LE}, q{SDL_IOStream* dst, uint value}},
		{q{bool}, q{SDL_WriteS32LE}, q{SDL_IOStream* dst, int value}},
		{q{bool}, q{SDL_WriteU32BE}, q{SDL_IOStream* dst, uint value}},
		{q{bool}, q{SDL_WriteS32BE}, q{SDL_IOStream* dst, int value}},
		{q{bool}, q{SDL_WriteU64LE}, q{SDL_IOStream* dst, c_uint64 value}},
		{q{bool}, q{SDL_WriteS64LE}, q{SDL_IOStream* dst, c_int64 value}},
		{q{bool}, q{SDL_WriteU64BE}, q{SDL_IOStream* dst, c_uint64 value}},
		{q{bool}, q{SDL_WriteS64BE}, q{SDL_IOStream* dst, c_int64 value}},
	];
	return ret;
}()));
