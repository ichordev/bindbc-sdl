/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlstdinc;

import bindbc.sdl.config;

version(WebAssembly){
}else import core.stdc.stdarg: va_list;

alias SDL_bool = int;
enum: SDL_bool{
	SDL_FALSE = 0,
	SDL_TRUE  = 1
}

deprecated("Please use `byte` instead.") alias Sint8 = byte;
deprecated("Please use `ubyte` instead.") alias Uint8 = ubyte;
deprecated("Please use `short` instead.") alias Sint16 = short;
deprecated("Please use `ushort` instead.") alias Uint16 = ushort;
deprecated("Please use `int` instead.") alias Sint32 = int;
deprecated("Please use `uint` instead.") alias Uint32 = uint;
deprecated("Please use `long` instead.") alias Sint64 = long;
deprecated("Please use `ulong` instead.") alias Uint64 = ulong;

static if(sdlSupport >= SDLSupport.sdl2022){
	enum SDL_FLT_EPSILON = 1.1920928955078125e-07F;
}

extern(C) @nogc nothrow{
	alias SDL_malloc_func = void* function(size_t size);
	alias SDL_calloc_func = void* function(size_t nmemb, size_t size);
	alias SDL_realloc_func = void* function(void* mem, size_t size);
	alias SDL_free_func = void function(void* mem);
}

enum SDL_PI = 3.14159265358979323846264338327950288;

enum: size_t{
	SDL_ICONV_ERROR     = -1,
	SDL_ICONV_E2BIG     = -2,
	SDL_ICONV_EILSEQ    = -3,
	SDL_ICONV_EINVAL    = -4,
}

struct SDL_iconv_t;

@nogc nothrow pragma(inline, true){
	dchar SDL_FOURCC(char A, char B, char C, char D) pure{
		return (A << 0) | (B << 8) | (C << 16) | (D << 24);
	}
	
	T SDL_min(T)(T x, T y) pure{ return ((x) < (y)) ? (x) : (y); }
	T SDL_max(T)(T x, T y) pure{ return ((x) > (y)) ? (x) : (y); }
	T SDL_clamp(T)(T x, T a, T b) pure{ return ((x) < (a)) ? (a) : (((x) > (b)) ? (b) : (x)); }
	
	void* SDL_zero(T)(T x){  return SDL_memset(&x, 0, x.sizeof); }
	void* SDL_zerop(T)(T x){ return SDL_memset(x, 0, (*x).sizeof); }
	void* SDL_zeroa(T)(T x){ return SDL_memset(x, 0, x.sizeof); }
	
	char*   SDL_iconv_utf8_locale(const(char)* S){ return SDL_iconv_string("", "UTF-8", S, SDL_strlen(S)+1); }
	ushort* SDL_iconv_utf8_ucs2(const(char)* S){   return cast(ushort*)SDL_iconv_string("UCS-2-INTERNAL", "UTF-8", S, SDL_strlen(S)+1); }
	uint*   SDL_iconv_utf8_ucs4(const(char)* S){   return cast(uint*)SDL_iconv_string("UCS-4-INTERNAL", "UTF-8", S, SDL_strlen(S)+1); }
	char*   SDL_iconv_wchar_utf8(const(dchar)* S){  return SDL_iconv_string("UTF-8", "WCHAR_T", cast(char*)S, (SDL_wcslen(S)+1)*(dchar.sizeof)); }
}
deprecated("Please use the non-template variant instead."){
	enum SDL_FOURCC(char A, char B, char C, char D) =
		((A << 0) | (B << 8) | (C << 16) | (D << 24));
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{void*}, q{SDL_malloc}, q{size_t size}],
		[q{void*}, q{SDL_calloc}, q{size_t nmemb, size_t size}],
		[q{void*}, q{SDL_realloc}, q{void* mem, size_t size}],
		[q{void}, q{SDL_free}, q{void* mem}],
		[q{char*}, q{SDL_getenv}, q{const(char)* name}],
		[q{int}, q{SDL_setenv}, q{const(char)* name, const(char)* value, int overwrite}],
		[q{void}, q{SDL_qsort}, q{void* base, size_t nmemb, size_t size, int function(const(void)*, const(void)*) compare}],
		[q{void*}, q{SDL_bsearch}, q{const(void)* key, const(void)* base, size_t nmemb, size_t size, int function(const(void)*, const(void)*) compare}],
		[q{int}, q{SDL_abs}, q{int x}],
		[q{int}, q{SDL_isalpha}, q{int x}],
		[q{int}, q{SDL_isalnum}, q{int x}],
		[q{int}, q{SDL_isblank}, q{int x}],
		[q{int}, q{SDL_iscntrl}, q{int x}],
		[q{int}, q{SDL_isdigit}, q{int x}],
		[q{int}, q{SDL_isxdigit}, q{int x}],
		[q{int}, q{SDL_ispunct}, q{int x}],
		[q{int}, q{SDL_isspace}, q{int x}],
		[q{int}, q{SDL_isupper}, q{int x}],
		[q{int}, q{SDL_islower}, q{int x}],
		[q{int}, q{SDL_isprint}, q{int x}],
		[q{int}, q{SDL_isgraph}, q{int x}],
		[q{int}, q{SDL_toupper}, q{int x}],
		[q{int}, q{SDL_tolower}, q{int x}],
		[q{ushort}, q{SDL_crc16}, q{ushort crc, const(void)* data, size_t len}],
		[q{uint}, q{SDL_crc32}, q{uint crc, const(void)* data, size_t len}],
		[q{void*}, q{SDL_memset}, q{void* dst, int c, size_t len}],
		[q{void*}, q{SDL_memcpy}, q{void* dst, const(void)* src, size_t len}],
		[q{void*}, q{SDL_memmove}, q{void* dst, const(void)* src, size_t len}],
		[q{int}, q{SDL_memcmp}, q{const(void)* s1, const(void)* s2, size_t len}],
		[q{size_t}, q{SDL_wcslen}, q{const(dchar)* wstr}],
		[q{size_t}, q{SDL_wcslcpy}, q{dchar* dst, const(dchar)* src, size_t maxlen}],
		[q{size_t}, q{SDL_wcslcat}, q{dchar* dst, const(dchar)* src, size_t maxlen}],
		[q{dchar*}, q{SDL_wcsdup}, q{const(dchar)* wstr}],
		[q{dchar*}, q{SDL_wcsstr}, q{const(dchar)* haystack, const(dchar)* needle}],
		[q{int}, q{SDL_wcscmp}, q{const(dchar)* str1, const(dchar)* str2}],
		[q{int}, q{SDL_wcsncmp}, q{const(dchar)* str1, const(dchar)* str2, size_t maxlen}],
		[q{int}, q{SDL_wcscasecmp}, q{const(dchar)* str1, const(dchar)* str2}],
		[q{int}, q{SDL_wcsncasecmp}, q{const(dchar)* str1, const(dchar)* str2, size_t len}],
		[q{size_t}, q{SDL_strlen}, q{const(char)* str}],
		[q{size_t}, q{SDL_strlcpy}, q{char* dst, const(char)* src, size_t maxlen}],
		[q{size_t}, q{SDL_utf8strlcpy}, q{char* dst, const(char)* src, size_t dst_bytes}],
		[q{size_t}, q{SDL_strlcat}, q{char* dst, const(char)* src, size_t maxlen}],
		[q{char*}, q{SDL_strdup}, q{const(char)* str}],
		[q{char*}, q{SDL_strrev}, q{char* str}],
		[q{char*}, q{SDL_strupr}, q{char* str}],
		[q{char*}, q{SDL_strlwr}, q{char* str}],
		[q{char*}, q{SDL_strchr}, q{const(char)* str, int c}],
		[q{char*}, q{SDL_strrchr}, q{const(char)* str, int c}],
		[q{char*}, q{SDL_strstr}, q{const(char)* haystack, const(char)* needle}],
		[q{char*}, q{SDL_strcasestr}, q{const(char)* haystack, const(char)* needle}],
		[q{char*}, q{SDL_strtokr}, q{char* s1, const(char)* s2, char** saveptr}],
		[q{size_t}, q{SDL_utf8strlen}, q{const(char)* str}],
		[q{size_t}, q{SDL_utf8strnlen}, q{const(char)* str, size_t bytes}],
		[q{char*}, q{SDL_itoa}, q{int value, char* str, int radix}],
		[q{char*}, q{SDL_uitoa}, q{uint value, char* str, int radix}],
		[q{char*}, q{SDL_ltoa}, q{long value, char* str, int radix}],
		[q{char*}, q{SDL_ultoa}, q{ulong value, char* str, int radix}],
		[q{char*}, q{SDL_lltoa}, q{long value, char* str, int radix}],
		[q{char*}, q{SDL_ulltoa}, q{ulong value, char* str, int radix}],
		[q{int}, q{SDL_atoi}, q{const(char)* str}],
		[q{double}, q{SDL_atof}, q{const(char)* str}],
		[q{long}, q{SDL_strtol}, q{const(char)* str, char** endp, int base}],
		[q{ulong}, q{SDL_strtoul}, q{const(char)* str, char** endp, int base}],
		[q{long}, q{SDL_strtoll}, q{const(char)* str, char** endp, int base}],
		[q{ulong}, q{SDL_strtoull}, q{const(char)* str, char** endp, int base}],
		[q{double}, q{SDL_strtod}, q{const(char)* str, char** endp}],
		[q{int}, q{SDL_strcmp}, q{const(char)* str1, const(char)* str2}],
		[q{int}, q{SDL_strncmp}, q{const(char)* str1, const(char)* str2, size_t maxlen}],
		[q{int}, q{SDL_strcasecmp}, q{const(char)* str1, const(char)* str2}],
		[q{int}, q{SDL_strncasecmp}, q{const(char)* str1, const(char)* str2, size_t len}],
		[q{int}, q{SDL_sscanf}, q{const(char)* text, const(char)* fmt, ...}],
		[q{int}, q{SDL_snprintf}, q{char* text, size_t maxlen, const(char)* fmt, ...}],
		[q{int}, q{SDL_asprintf}, q{char** strp, const(char)* fmt, ...}],
		[q{double}, q{SDL_acos}, q{double x}],
		[q{float}, q{SDL_acosf}, q{float x}],
		[q{double}, q{SDL_asin}, q{double x}],
		[q{float}, q{SDL_asinf}, q{float x}],
		[q{double}, q{SDL_atan}, q{double x}],
		[q{float}, q{SDL_atanf}, q{float x}],
		[q{double}, q{SDL_atan2}, q{double y, double x}],
		[q{float}, q{SDL_atan2f}, q{float y, float x}],
		[q{double}, q{SDL_ceil}, q{double x}],
		[q{float}, q{SDL_ceilf}, q{float x}],
		[q{double}, q{SDL_copysign}, q{double x, double y}],
		[q{float}, q{SDL_copysignf}, q{float x, float y}],
		[q{double}, q{SDL_cos}, q{double x}],
		[q{float}, q{SDL_cosf}, q{float x}],
		[q{double}, q{SDL_exp}, q{double x}],
		[q{float}, q{SDL_expf}, q{float x}],
		[q{double}, q{SDL_fabs}, q{double x}],
		[q{float}, q{SDL_fabsf}, q{float x}],
		[q{double}, q{SDL_floor}, q{double x}],
		[q{float}, q{SDL_floorf}, q{float x}],
		[q{double}, q{SDL_trunc}, q{double x}],
		[q{float}, q{SDL_truncf}, q{float x}],
		[q{double}, q{SDL_fmod}, q{double x, double y}],
		[q{float}, q{SDL_fmodf}, q{float x, float y}],
		[q{double}, q{SDL_log}, q{double x}],
		[q{float}, q{SDL_logf}, q{float x}],
		[q{double}, q{SDL_log10}, q{double x}],
		[q{float}, q{SDL_log10f}, q{float x}],
		[q{double}, q{SDL_pow}, q{double x, double y}],
		[q{float}, q{SDL_powf}, q{float x, float y}],
		[q{double}, q{SDL_round}, q{double x}],
		[q{float}, q{SDL_roundf}, q{float x}],
		[q{long}, q{SDL_lround}, q{double x}],
		[q{long}, q{SDL_lroundf}, q{float x}],
		[q{double}, q{SDL_scalbn}, q{double x, int n}],
		[q{float}, q{SDL_scalbnf}, q{float x, int n}],
		[q{double}, q{SDL_sin}, q{double x}],
		[q{float}, q{SDL_sinf}, q{float x}],
		[q{double}, q{SDL_sqrt}, q{double x}],
		[q{float}, q{SDL_sqrtf}, q{float x}],
		[q{double}, q{SDL_tan}, q{double x}],
		[q{float}, q{SDL_tanf}, q{float x}],
		[q{SDL_iconv_t*}, q{SDL_iconv_open}, q{const(char)* tocode, const(char)* fromcode}],
		[q{int}, q{SDL_iconv_close}, q{SDL_iconv_t* cd}],
		[q{size_t}, q{SDL_iconv}, q{SDL_iconv_t* cd, const(char)** inbuf, size_t* inbytesleft, char** outbuf, size_t* outbytesleft}],
		[q{char*}, q{SDL_iconv_string}, q{const(char)* tocode, const(char)* fromcode, const(char)* inbuf, size_t inbytesleft}],
	]);
	version(WebAssembly){
	}else{
		ret ~= makeFnBinds([
			[q{int}, q{SDL_vsscanf}, q{const(char)* text, const(char)* fmt, va_list ap}],
			[q{int}, q{SDL_vsnprintf}, q{char* text, size_t maxlen, const(char)* fmt, va_list ap}],
			[q{int}, q{SDL_vasprintf}, q{char** strp, const(char)* fmt, va_list ap}],
		]);
	}
	static if(sdlSupport >= SDLSupport.sdl207){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GetMemoryFunctions}, q{SDL_malloc_func* malloc_func, SDL_calloc_func* calloc_func, SDL_realloc_func* realloc_func, SDL_free_func* free_func}],
			[q{int}, q{SDL_SetMemoryFunctions}, q{SDL_malloc_func malloc_func, SDL_calloc_func calloc_func, SDL_realloc_func realloc_func, SDL_free_func free_func}],
			[q{int}, q{SDL_GetNumAllocations}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.sdl2240){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GetOriginalMemoryFunctions}, q{SDL_malloc_func* malloc_func, SDL_calloc_func* calloc_func, SDL_realloc_func* realloc_func, SDL_free_func* free_func}],
		]);
	}
	return ret;
}()));
