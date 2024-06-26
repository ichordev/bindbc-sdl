/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.iostream;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.properties;
import sdl.stdinc;

mixin(makeEnumBind(q{SDL_IOStatus}, members: (){
	EnumMember[] ret = [
		{{q{ready},        q{SDL_IO_STATUS_READY}}},
		{{q{error},        q{SDL_IO_STATUS_ERROR}}},
		{{q{eof},          q{SDL_IO_STATUS_EOF}}},
		{{q{notReady},     q{SDL_IO_STATUS_NOT_READY}}},
		{{q{readOnly},     q{SDL_IO_STATUS_READONLY}}},
		{{q{writeOnly},    q{SDL_IO_STATUS_WRITEONLY}}},
	];
	return ret;
}()));

struct SDL_IOStreamInterface{
	alias SizeFn = extern(C) long function(void* userData) nothrow;
	alias SeekFn = extern(C) long function(void* userData, long offset, int whence) nothrow;
	alias ReadFn = extern(C) size_t function(void* userData, void* ptr, size_t size, SDL_IOStatus* status) nothrow;
	alias WriteFn = extern(C) size_t function(void* userData, const(void)* ptr, size_t size, SDL_IOStatus* status) nothrow;
	alias CloseFn = extern(C) int function(void* userData) nothrow;
	SizeFn size;
	SeekFn seek;
	ReadFn read;
	WriteFn write;
	CloseFn close;
}

struct SDL_IOStream;

enum: const(char)*{
	SDL_PropIOStreamWindowsHandlePointer      = "SDL.iostream.windows.handle",
	SDL_PropIOStreamStdIOFilePointer          = "SDL.iostream.stdio.file",
	SDL_PropIOStreamAndroidAassetPointer      = "SDL.iostream.android.aasset",
	SDL_PropIOStreamDynamicMemoryPointer      = "SDL.iostream.dynamic.memory",
	SDL_PropIOStreamDynamicChunkSizeNumber    = "SDL.iostream.dynamic.chunksize",
}
alias SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER = SDL_PropIOStreamWindowsHandlePointer;
alias SDL_PROP_IOSTREAM_STDIO_FILE_POINTER = SDL_PropIOStreamStdIOFilePointer;
alias SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER = SDL_PropIOStreamAndroidAassetPointer;
alias SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER = SDL_PropIOStreamDynamicMemoryPointer;
alias SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER = SDL_PropIOStreamDynamicChunkSizeNumber;

mixin(makeEnumBind(q{SDL_IOSeek}, members: (){
	EnumMember[] ret = [
		{{q{set}, q{SDL_IO_SEEK_SET}}, q{0}},
		{{q{cur}, q{SDL_IO_SEEK_CUR}}, q{1}},
		{{q{end}, q{SDL_IO_SEEK_END}}, q{2}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_IOStream*}, q{SDL_IOFromFile}, q{const(char)* file, const(char)* mode}},
		{q{SDL_IOStream*}, q{SDL_IOFromMem}, q{void* mem, size_t size}},
		{q{SDL_IOStream*}, q{SDL_IOFromConstMem}, q{const(void)* mem, size_t size}},
		{q{SDL_IOStream*}, q{SDL_IOFromDynamicMem}, q{}},
		{q{SDL_IOStream*}, q{SDL_OpenIO}, q{const(SDL_IOStreamInterface)* iFace, void* userdata}},
		{q{int}, q{SDL_CloseIO}, q{SDL_IOStream* context}},
		{q{SDL_PropertiesID}, q{SDL_GetIOProperties}, q{SDL_IOStream* context}},
		{q{SDL_IOStatus}, q{SDL_GetIOStatus}, q{SDL_IOStream* context}},
		{q{long}, q{SDL_GetIOSize}, q{SDL_IOStream* context}},
		{q{long}, q{SDL_SeekIO}, q{SDL_IOStream* context, long offset, int whence}},
		{q{long}, q{SDL_TellIO}, q{SDL_IOStream* context}},
		{q{size_t}, q{SDL_ReadIO}, q{SDL_IOStream* context, void* ptr, size_t size}},
		{q{size_t}, q{SDL_WriteIO}, q{SDL_IOStream* context, const(void)* ptr, size_t size}},
		{q{size_t}, q{SDL_IOprintf}, q{SDL_IOStream* context, const(char)* fmt, ...}},
		{q{size_t}, q{SDL_IOvprintf}, q{SDL_IOStream* context, const(char)* fmt, va_list ap}},
		{q{void*}, q{SDL_LoadFile_IO}, q{SDL_IOStream* src, size_t* dataSize, SDL_Bool closeIO}},
		{q{void*}, q{SDL_LoadFile}, q{const(char)* file, size_t* dataSize}},
		{q{SDL_Bool}, q{SDL_ReadU8}, q{SDL_IOStream* src, ubyte* value}},
		{q{SDL_Bool}, q{SDL_ReadU16LE}, q{SDL_IOStream* src, ushort* value}},
		{q{SDL_Bool}, q{SDL_ReadS16LE}, q{SDL_IOStream* src, short* value}},
		{q{SDL_Bool}, q{SDL_ReadU16BE}, q{SDL_IOStream* src, ushort* value}},
		{q{SDL_Bool}, q{SDL_ReadS16BE}, q{SDL_IOStream* src, short* value}},
		{q{SDL_Bool}, q{SDL_ReadU32LE}, q{SDL_IOStream* src, uint* value}},
		{q{SDL_Bool}, q{SDL_ReadS32LE}, q{SDL_IOStream* src, int* value}},
		{q{SDL_Bool}, q{SDL_ReadU32BE}, q{SDL_IOStream* src, uint* value}},
		{q{SDL_Bool}, q{SDL_ReadS32BE}, q{SDL_IOStream* src, int* value}},
		{q{SDL_Bool}, q{SDL_ReadU64LE}, q{SDL_IOStream* src, ulong* value}},
		{q{SDL_Bool}, q{SDL_ReadS64LE}, q{SDL_IOStream* src, long* value}},
		{q{SDL_Bool}, q{SDL_ReadU64BE}, q{SDL_IOStream* src, ulong* value}},
		{q{SDL_Bool}, q{SDL_ReadS64BE}, q{SDL_IOStream* src, long* value}},
		{q{SDL_Bool}, q{SDL_WriteU8}, q{SDL_IOStream* dst, ubyte value}},
		{q{SDL_Bool}, q{SDL_WriteU16LE}, q{SDL_IOStream* dst, ushort value}},
		{q{SDL_Bool}, q{SDL_WriteS16LE}, q{SDL_IOStream* dst, short value}},
		{q{SDL_Bool}, q{SDL_WriteU16BE}, q{SDL_IOStream* dst, ushort value}},
		{q{SDL_Bool}, q{SDL_WriteS16BE}, q{SDL_IOStream* dst, short value}},
		{q{SDL_Bool}, q{SDL_WriteU32LE}, q{SDL_IOStream* dst, uint value}},
		{q{SDL_Bool}, q{SDL_WriteS32LE}, q{SDL_IOStream* dst, int value}},
		{q{SDL_Bool}, q{SDL_WriteU32BE}, q{SDL_IOStream* dst, uint value}},
		{q{SDL_Bool}, q{SDL_WriteS32BE}, q{SDL_IOStream* dst, int value}},
		{q{SDL_Bool}, q{SDL_WriteU64LE}, q{SDL_IOStream* dst, ulong value}},
		{q{SDL_Bool}, q{SDL_WriteS64LE}, q{SDL_IOStream* dst, long value}},
		{q{SDL_Bool}, q{SDL_WriteU64BE}, q{SDL_IOStream* dst, ulong value}},
		{q{SDL_Bool}, q{SDL_WriteS64BE}, q{SDL_IOStream* dst, long value}},
	];
	return ret;
}()));
