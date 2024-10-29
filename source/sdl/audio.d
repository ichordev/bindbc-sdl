/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.audio;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.iostream: SDL_IOStream;
import sdl.properties: SDL_PropertiesID;

enum{
	SDL_AUDIO_MASK_BITSIZE     = 0xFFU,
	SDL_AUDIO_MASK_FLOAT       = 1U <<  8,
	SDL_AUDIO_MASK_BIG_ENDIAN  = 1U << 12,
	SDL_AUDIO_MASK_SIGNED      = 1U << 15,
}
static if(dStyleEnums){
	alias maskBitSize = SDL_AUDIO_MASK_BITSIZE;
	alias maskFloat = SDL_AUDIO_MASK_FLOAT;
	alias maskBigEndian = SDL_AUDIO_MASK_BIG_ENDIAN;
	alias maskSigned = SDL_AUDIO_MASK_SIGNED;
}

pragma(inline,true) extern(C)
auto SDL_DEFINE_AUDIO_FORMAT(bool signed, bool bigEndian, bool float_, uint size) nothrow @nogc pure @safe =>
	(cast(ushort)signed << 15) | (cast(ushort)bigEndian << 12) | (cast(ushort)float_ << 8) | (size & SDL_AUDIO_MASK_BITSIZE);

mixin(makeEnumBind(q{SDL_AudioFormat}, aliases: [q{SDL_Audio}], members: (){
	EnumMember[] ret = [
		{{q{unknown},  q{SDL_AUDIO_UNKNOWN}},  q{0x0000U}},
		{{q{u8},       q{SDL_AUDIO_U8}},       q{0x0008U}},
		{{q{s8},       q{SDL_AUDIO_S8}},       q{0x8008U}},
		{{q{s16LE},    q{SDL_AUDIO_S16LE}},    q{0x8010U}},
		{{q{s16BE},    q{SDL_AUDIO_S16BE}},    q{0x9010U}},
		{{q{s32LE},    q{SDL_AUDIO_S32LE}},    q{0x8020U}},
		{{q{s32BE},    q{SDL_AUDIO_S32BE}},    q{0x9020U}},
		{{q{f32LE},    q{SDL_AUDIO_F32LE}},    q{0x8120U}},
		{{q{f32BE},    q{SDL_AUDIO_F32BE}},    q{0x9120U}},
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

pragma(inline,true) extern(C) nothrow @nogc pure @safe{
	ubyte SDL_AUDIO_BITSIZE(uint x)  => cast(ubyte)(x & SDL_AUDIO_MASK_BITSIZE);
	ubyte SDL_AUDIO_BYTESIZE(uint x) => cast(ubyte)(SDL_AUDIO_BITSIZE(x) / 8);
	bool SDL_AUDIO_ISFLOAT(uint x)        => (x & SDL_AUDIO_MASK_FLOAT) != 0;
	bool SDL_AUDIO_ISBIGENDIAN(uint x)    => (x & SDL_AUDIO_MASK_BIG_ENDIAN) != 0;
	bool SDL_AUDIO_ISSIGNED(uint x)       => (x & SDL_AUDIO_MASK_SIGNED) != 0;
	bool SDL_AUDIO_ISINT(uint x)          => (x & SDL_AUDIO_MASK_FLOAT) == 0;
	bool SDL_AUDIO_ISLITTLEENDIAN(uint x) => (x & SDL_AUDIO_MASK_BIG_ENDIAN) == 0;
	bool SDL_AUDIO_ISUNSIGNED(uint x)     => (x & SDL_AUDIO_MASK_SIGNED) == 0;
}
alias bitSize = SDL_AUDIO_BITSIZE;
alias byteSize = SDL_AUDIO_BYTESIZE;
alias isFloat = SDL_AUDIO_ISFLOAT;
alias isBigEndian = SDL_AUDIO_ISBIGENDIAN;
alias isSigned = SDL_AUDIO_ISSIGNED;
alias isInt = SDL_AUDIO_ISINT;
alias isLittleEndian = SDL_AUDIO_ISLITTLEENDIAN;
alias isUnsigned = SDL_AUDIO_ISUNSIGNED;

alias SDL_AudioDeviceID = uint;

enum: SDL_AudioDeviceID{
	SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK  = cast(SDL_AudioDeviceID)0xFFFF_FFFFU,
	SDL_AUDIO_DEVICE_DEFAULT_RECORDING = cast(SDL_AudioDeviceID)0xFFFF_FFFEU,
}
static if(dStyleEnums){
	alias deviceDefaultPlayback = SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK;
	alias deviceDefaultRecording = SDL_AUDIO_DEVICE_DEFAULT_RECORDING;
}

struct SDL_AudioSpec{
	SDL_AudioFormat format;
	int channels;
	int freq;
}

pragma(inline,true) extern(C)
int SDL_AUDIO_FRAMESIZE(SDL_AudioSpec x) nothrow @nogc pure @safe =>
	SDL_AUDIO_BYTESIZE(x.format)* x.channels;
alias frameSize = SDL_AUDIO_FRAMESIZE;

struct SDL_AudioStream;

extern(C) nothrow{
	alias SDL_AudioStreamCallback = void function(void* userData, SDL_AudioStream* stream, int additionalAmount, int totalAmount);
	alias SDL_AudioPostmixCallback = void function(void* userData, const(SDL_AudioSpec)* spec, float* buffer, int bufLen);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumAudioDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetAudioDriver}, q{int index}},
		{q{const(char)*}, q{SDL_GetCurrentAudioDriver}, q{}},
		{q{SDL_AudioDeviceID*}, q{SDL_GetAudioPlaybackDevices}, q{int* count}},
		{q{SDL_AudioDeviceID*}, q{SDL_GetAudioRecordingDevices}, q{int* count}},
		{q{const(char)*}, q{SDL_GetAudioDeviceName}, q{SDL_AudioDeviceID devID}},
		{q{bool}, q{SDL_GetAudioDeviceFormat}, q{SDL_AudioDeviceID devID, SDL_AudioSpec* spec, int* sampleFrames}},
		{q{int*}, q{SDL_GetAudioDeviceChannelMap}, q{SDL_AudioDeviceID devID, int* count}},
		{q{SDL_AudioDeviceID}, q{SDL_OpenAudioDevice}, q{SDL_AudioDeviceID devID, const(SDL_AudioSpec)* spec}},
		{q{bool}, q{SDL_PauseAudioDevice}, q{SDL_AudioDeviceID dev}},
		{q{bool}, q{SDL_ResumeAudioDevice}, q{SDL_AudioDeviceID dev}},
		{q{bool}, q{SDL_AudioDevicePaused}, q{SDL_AudioDeviceID dev}},
		{q{float}, q{SDL_GetAudioDeviceGain}, q{SDL_AudioDeviceID devID}},
		{q{bool}, q{SDL_SetAudioDeviceGain}, q{SDL_AudioDeviceID devID, float gain}},
		{q{void}, q{SDL_CloseAudioDevice}, q{SDL_AudioDeviceID devID}},
		{q{bool}, q{SDL_BindAudioStreams}, q{SDL_AudioDeviceID devID, SDL_AudioStream** streams, int numStreams}},
		{q{bool}, q{SDL_BindAudioStream}, q{SDL_AudioDeviceID devID, SDL_AudioStream* stream}},
		{q{void}, q{SDL_UnbindAudioStreams}, q{SDL_AudioStream** streams, int numStreams}},
		{q{void}, q{SDL_UnbindAudioStream}, q{SDL_AudioStream* stream}},
		{q{SDL_AudioDeviceID}, q{SDL_GetAudioStreamDevice}, q{SDL_AudioStream* stream}},
		{q{SDL_AudioStream*}, q{SDL_CreateAudioStream}, q{const(SDL_AudioSpec)* srcSpec, const(SDL_AudioSpec)* dstSpec}},
		{q{SDL_PropertiesID}, q{SDL_GetAudioStreamProperties}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_GetAudioStreamFormat}, q{SDL_AudioStream* stream, SDL_AudioSpec* srcSpec, SDL_AudioSpec* dstSpec}},
		{q{bool}, q{SDL_SetAudioStreamFormat}, q{SDL_AudioStream* stream, const(SDL_AudioSpec)* srcSpec, const(SDL_AudioSpec)* dstSpec}},
		{q{float}, q{SDL_GetAudioStreamFrequencyRatio}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_SetAudioStreamFrequencyRatio}, q{SDL_AudioStream* stream, float ratio}},
		{q{float}, q{SDL_GetAudioStreamGain}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_SetAudioStreamGain}, q{SDL_AudioStream* stream, float gain}},
		{q{int*}, q{SDL_GetAudioStreamInputChannelMap}, q{SDL_AudioStream* stream, int* count}},
		{q{int*}, q{SDL_GetAudioStreamOutputChannelMap}, q{SDL_AudioStream* stream, int* count}},
		{q{bool}, q{SDL_SetAudioStreamInputChannelMap}, q{SDL_AudioStream* stream, const(int)* chMap, int count}},
		{q{bool}, q{SDL_SetAudioStreamOutputChannelMap}, q{SDL_AudioStream* stream, const(int)* chMap, int count}},
		{q{bool}, q{SDL_PutAudioStreamData}, q{SDL_AudioStream* stream, const(void)* buf, int len}},
		{q{int}, q{SDL_GetAudioStreamData}, q{SDL_AudioStream* stream, void* buf, int len}},
		{q{int}, q{SDL_GetAudioStreamAvailable}, q{SDL_AudioStream* stream}},
		{q{int}, q{SDL_GetAudioStreamQueued}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_FlushAudioStream}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_ClearAudioStream}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_PauseAudioStreamDevice}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_ResumeAudioStreamDevice}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_LockAudioStream}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_UnlockAudioStream}, q{SDL_AudioStream* stream}},
		{q{bool}, q{SDL_SetAudioStreamGetCallback}, q{SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userData}},
		{q{bool}, q{SDL_SetAudioStreamPutCallback}, q{SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userData}},
		{q{void}, q{SDL_DestroyAudioStream}, q{SDL_AudioStream* stream}},
		{q{SDL_AudioStream*}, q{SDL_OpenAudioDeviceStream}, q{SDL_AudioDeviceID devID, const(SDL_AudioSpec)* spec, SDL_AudioStreamCallback callback, void* userData}},
		{q{bool}, q{SDL_SetAudioPostmixCallback}, q{SDL_AudioDeviceID devID, SDL_AudioPostmixCallback callback, void* userData}},
		{q{bool}, q{SDL_LoadWAV_IO}, q{SDL_IOStream* src, bool closeIO, SDL_AudioSpec* spec, ubyte** audioBuf, uint* audioLen}},
		{q{bool}, q{SDL_LoadWAV}, q{const(char)* path, SDL_AudioSpec* spec, ubyte** audioBuf, uint* audioLen}},
		{q{bool}, q{SDL_MixAudio}, q{ubyte* dst, const(ubyte)* src, SDL_AudioFormat format, uint len, float volume}},
		{q{bool}, q{SDL_ConvertAudioSamples}, q{const(SDL_AudioSpec)* srcSpec, const(ubyte)* srcData, int srcLen, const(SDL_AudioSpec)* dstSpec, ubyte** dstData, int* dstLen}},
		{q{const(char)*}, q{SDL_GetAudioFormatName}, q{SDL_AudioFormat format}},
		{q{int}, q{SDL_GetSilenceValueForFormat}, q{SDL_AudioFormat format}},
	];
	return ret;
}()));
