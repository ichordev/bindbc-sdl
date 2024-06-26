/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.audio;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.iostream;
import sdl.properties;
import sdl.stdinc;

mixin(makeEnumBind(q{SDL_AudioFormat}, q{ushort}, aliases: [q{SDL_Audio}], members: (){
	EnumMember[] ret = [
		{{q{u8},       q{SDL_AUDIO_U8}},     q{0x0008}},
		{{q{s8},       q{SDL_AUDIO_S8}},     q{0x8008}},
		{{q{s16LE},    q{SDL_AUDIO_S16LE}},  q{0x8010}},
		{{q{s16BE},    q{SDL_AUDIO_S16BE}},  q{0x9010}},
		
		{{q{s32LE},    q{SDL_AUDIO_S32LE}},  q{0x8020}},
		{{q{s32BE},    q{SDL_AUDIO_S32BE}},  q{0x9020}},
		
		{{q{f32LE},    q{SDL_AUDIO_F32LE}},  q{0x8120}},
		{{q{f32BE},    q{SDL_AUDIO_F32BE}},  q{0x9120}},
	];
	version(LittleEndian){
		EnumMember[] add = [
			{{q{s16},  q{SDL_AUDIO_S16}},  q{SDL_Audio.s16LE}},
			{{q{s32},  q{SDL_AUDIO_S32}},  q{SDL_Audio.s32LE}},
			{{q{f32},  q{SDL_AUDIO_F32}},  q{SDL_Audio.f32LE}},
		];
		ret ~= add;
	}else{
		EnumMember[] add = [
			{{q{s16},  q{SDL_AUDIO_S16}},  q{SDL_Audio.s16BE}},
			{{q{s32},  q{SDL_AUDIO_S32}},  q{SDL_Audio.s32BE}},
			{{q{f32},  q{SDL_AUDIO_F32}},  q{SDL_Audio.f32BE}},
		];
		ret ~= add;
	}
	return ret;
}()));

enum SDL_AudioMaskBitsize    = 0xFF;
enum SDL_AudioMaskFloat      = 1 << 8;
enum SDL_AudioMaskBigEndian  = 1 << 12;
enum SDL_AudioMaskSigned     = 1 << 15;
alias SDL_AUDIO_MASK_BITSIZE = SDL_AudioMaskBitsize;
alias SDL_AUDIO_MASK_FLOAT = SDL_AudioMaskFloat;
alias SDL_AUDIO_MASK_BIG_ENDIAN = SDL_AudioMaskBigEndian;
alias SDL_AUDIO_MASK_SIGNED = SDL_AudioMaskSigned;

pragma(inline,true) nothrow @nogc pure @safe{
	uint SDL_AudioBitSize(SDL_AudioFormat x)        => x & SDL_AudioMaskBitsize;
	uint SDL_AudioByteSize(SDL_AudioFormat x)       => SDL_AudioBitSize(x) / 8;
	bool SDL_AudioIsFloat(SDL_AudioFormat x)        => (x & SDL_AudioMaskFloat) != 0;
	bool SDL_AudioIsBigEndian(SDL_AudioFormat x)    => (x & SDL_AudioMaskBigEndian) != 0;
	bool SDL_AudioIsLittleEndian(SDL_AudioFormat x) => !SDL_AudioIsBigEndian(x);
	bool SDL_AudioIsSigned(SDL_AudioFormat x)       => (x & SDL_AudioMaskSigned) != 0;
	bool SDL_AudioIsInt(SDL_AudioFormat x)          => !SDL_AudioIsFloat(x);
	bool SDL_AudioIsUnsigned(SDL_AudioFormat x)     => !SDL_AudioIsSigned(x);
	alias SDL_AUDIO_BITSIZE = SDL_AudioBitSize;
	alias SDL_AUDIO_BYTESIZE = SDL_AudioByteSize;
	alias SDL_AUDIO_ISFLOAT = SDL_AudioIsFloat;
	alias SDL_AUDIO_ISBIGENDIAN = SDL_AudioIsBigEndian;
	alias SDL_AUDIO_ISLITTLEENDIAN = SDL_AudioIsLittleEndian;
	alias SDL_AUDIO_ISSIGNED = SDL_AudioIsSigned;
	alias SDL_AUDIO_ISINT = SDL_AudioIsInt;
	alias SDL_AUDIO_ISUNSIGNED = SDL_AudioIsUnsigned;
}

alias SDL_AudioDeviceID = uint;

enum SDL_AudioDeviceDefaultOutput  = cast(SDL_AudioDeviceID)0xFFFF_FFFFU;
enum SDL_AudioDeviceDefaultCapture = cast(SDL_AudioDeviceID)0xFFFF_FFFEU;
alias SDL_AUDIO_DEVICE_DEFAULT_OUTPUT = SDL_AudioDeviceDefaultOutput;
alias SDL_AUDIO_DEVICE_DEFAULT_CAPTURE = SDL_AudioDeviceDefaultCapture;

struct SDL_AudioSpec{
	SDL_AudioFormat format;
	int channels;
	int freq;
}

pragma(inline,true)
uint SDL_AudioFrameSize(SDL_AudioSpec x) nothrow @nogc pure @safe => SDL_AudioByteSize(x.format) * x.channels;
alias SDL_AUDIO_FRAMESIZE = SDL_AudioFrameSize;

struct SDL_AudioStream;

extern(C) nothrow{
	alias SDL_AudioStreamCallback  = void function(void* userData, SDL_AudioStream* stream, int additionalAmount, int totalAmount);
	alias SDL_AudioPostmixCallback = void function(void* userData, const(SDL_AudioSpec)* spec, float* buffer, int bufLen);
}

enum SDL_MixMaxVolume = 128;
alias SDL_MIX_MAXVOLUME = SDL_MixMaxVolume;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumAudioDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetAudioDriver}, q{int index}},
		{q{const(char)*}, q{SDL_GetCurrentAudioDriver}, q{}},
		{q{SDL_AudioDeviceID*}, q{SDL_GetAudioOutputDevices}, q{int* count}},
		{q{SDL_AudioDeviceID*}, q{SDL_GetAudioCaptureDevices}, q{int* count}},
		{q{char*}, q{SDL_GetAudioDeviceName}, q{SDL_AudioDeviceID devID}},
		{q{int}, q{SDL_GetAudioDeviceFormat}, q{SDL_AudioDeviceID devID, SDL_AudioSpec* spec, int* sampleFrames}},
		{q{SDL_AudioDeviceID}, q{SDL_OpenAudioDevice}, q{SDL_AudioDeviceID devID, const(SDL_AudioSpec)* spec}},
		{q{int}, q{SDL_PauseAudioDevice}, q{SDL_AudioDeviceID dev}},
		{q{int}, q{SDL_ResumeAudioDevice}, q{SDL_AudioDeviceID dev}},
		{q{SDL_Bool}, q{SDL_AudioDevicePaused}, q{SDL_AudioDeviceID dev}},
		{q{void}, q{SDL_CloseAudioDevice}, q{SDL_AudioDeviceID devID}},
		{q{int}, q{SDL_BindAudioStreams}, q{SDL_AudioDeviceID devID, SDL_AudioStream** streams, int numStreams}},
		{q{int}, q{SDL_BindAudioStream}, q{SDL_AudioDeviceID devID, SDL_AudioStream* stream}},
		{q{void}, q{SDL_UnbindAudioStreams}, q{SDL_AudioStream** streams, int numStreams}},
		{q{void}, q{SDL_UnbindAudioStream}, q{SDL_AudioStream* stream}},
		{q{SDL_AudioDeviceID}, q{SDL_GetAudioStreamDevice}, q{SDL_AudioStream* stream}},
		{q{SDL_AudioStream*}, q{SDL_CreateAudioStream}, q{const(SDL_AudioSpec)* srcSpec, const(SDL_AudioSpec)* dstSpec}},
		{q{SDL_PropertiesID}, q{SDL_GetAudioStreamProperties}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_GetAudioStreamFormat}, q{SDL_AudioStream* stream, SDL_AudioSpec* srcSpec, SDL_AudioSpec* dstSpec}},
		{q{int}, q{SDL_SetAudioStreamFormat}, q{SDL_AudioStream* stream, const(SDL_AudioSpec)* srcSpec, const(SDL_AudioSpec)* dstSpec}},
		{q{float}, q{SDL_GetAudioStreamFrequencyRatio}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_SetAudioStreamFrequencyRatio}, q{SDL_AudioStream* stream, float ratio}},
		{q{int}, q{SDL_PutAudioStreamData}, q{SDL_AudioStream* stream, const(void)* buf, int len}},
		{q{int}, q{SDL_GetAudioStreamData}, q{SDL_AudioStream* stream, void* buf, int len}},
		{q{int}, q{SDL_GetAudioStreamAvailable}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_GetAudioStreamQueued}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_FlushAudioStream}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_ClearAudioStream}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_LockAudioStream}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_UnlockAudioStream}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_SetAudioStreamGetCallback}, q{SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userData}},
		{q{int}, q{SDL_SetAudioStreamPutCallback}, q{SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userData}},
		{q{void}, q{SDL_DestroyAudioStream}, q{SDL_AudioStream* stream}},
		{q{SDL_AudioStream*}, q{SDL_OpenAudioDeviceStream}, q{SDL_AudioDeviceID devID, const(SDL_AudioSpec)* spec, SDL_AudioStreamCallback callback, void* userData}},
		{q{int}, q{SDL_SetAudioPostmixCallback}, q{SDL_AudioDeviceID devID, SDL_AudioPostmixCallback callback, void* userData}},
		{q{int}, q{SDL_LoadWAV_IO}, q{SDL_IOStream* src, SDL_Bool closeIO, SDL_AudioSpec* spec, ubyte** audioBuf, uint* audioLen}},
		{q{int}, q{SDL_LoadWAV}, q{const(char)* path, SDL_AudioSpec* spec, ubyte** audioBuf, uint* audioLen}},
		{q{int}, q{SDL_MixAudioFormat}, q{ubyte* dst, const(ubyte)* src, SDL_AudioFormat format, uint len, int volume}},
		{q{int}, q{SDL_ConvertAudioSamples}, q{const(SDL_AudioSpec)* srcSpec, const(ubyte)* srcData, int srcLen, const(SDL_AudioSpec)* dstSpec, ubyte** dstData, int* dstLen}},
		{q{int}, q{SDL_GetSilenceValueForFormat}, q{SDL_AudioFormat format}},
	];
	return ret;
}()));
