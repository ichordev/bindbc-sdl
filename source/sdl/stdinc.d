/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.stdinc;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

uint SDL_FourCC(ubyte a, ubyte b, ubyte c, ubyte d) nothrow @nogc pure @safe{
	return
		(a <<  0) |
		(b <<  8) |
		(c << 16) |
		(d << 24);
}
alias SDL_FOURCC = SDL_FourCC;

alias SDL_Bool = int;
enum: SDL_Bool{
	SDL_FALSE = false,
	SDL_TRUE  = true,
}

alias SDL_Time = long;

enum SDL_FltEpsilon = 0x0.000002p0f;
alias SDL_FLT_EPSILON = SDL_FltEpsilon;

extern(C) nothrow{
	alias SDL_malloc_func = void* function(size_t size);
	alias SDL_calloc_func = void* function(size_t nMemb, size_t size);
	alias SDL_realloc_func = void* function(void* mem, size_t size);
	alias SDL_free_func = void function(void* mem);
	
	private alias CompareFn  = int function(const(void)*, const(void)*);
	private alias RCompareFn = int function(void*, const(void)*, const(void)*);
}

nothrow @nogc pure @safe{
	auto SDL_min(T)(T x, T y) => (x < y) ? x : y;
	auto SDL_max(T)(T x, T y) => (x > y) ? x : y;
	auto SDL_clamp(T)(T x, T a, T b) => (x < a) ? a : ((x > b) ? b : x);
}

enum SDL_PI_D = 3.141592653589793238462643383279502884;
enum SDL_PI_F = 3.141592653589793238462643383279502884f;

mixin(makeEnumBind("SDL_IConv", q{size_t}, members: (){
	EnumMember[] ret = [
		{{q{error},     q{SDL_ICONV_ERROR}},     q{cast(size_t)-1}},
		{{q{e2Big},     q{SDL_ICONV_E2BIG}},     q{cast(size_t)-2}},
		{{q{eIlSeq},    q{SDL_ICONV_EILSEQ}},    q{cast(size_t)-3}},
		{{q{eInval},    q{SDL_ICONV_EINVAL}},    q{cast(size_t)-4}},
	];
	return ret;
}()));

struct SDL_iconv_data_t;
alias SDL_iconv_t = SDL_iconv_data_t*;

nothrow @nogc{
	auto SDL_iconv_utf8_locale(const(char)* s) =>
		SDL_iconv_string("", "UTF-8", s, SDL_strlen(s)+1);
	
	auto SDL_iconv_utf8_ucs2(const(char)* s) =>
		cast(wchar*)SDL_iconv_string("UCS-2", "UTF-8", s, SDL_strlen(s)+1);
	
	auto SDL_iconv_utf8_ucs4(const(char)* s) =>
		cast(dchar*)SDL_iconv_string("UCS-4", "UTF-8", s, SDL_strlen(s)+1);
	
	auto SDL_iconv_wchar_utf8(const(wchar_t)* s) =>
		SDL_iconv_string("UTF-8", "WCHAR_T", cast(char*)s, (SDL_wcslen(s)+1) * wchar_t.sizeof);
	
	int SDL_size_mul_overflow(size_t a, size_t b, size_t* ret) pure @safe{
		if(a != 0 && b > size_t.max / a){
			return -1;
		}
		*ret = a * b;
		return 0;
	}
	int SDL_size_add_overflow(size_t a, size_t b, size_t* ret) pure @safe{
		if (b > size_t.max - a) {
			return -1;
		}
		*ret = a + b;
		return 0;
	}
}

alias SDL_FunctionPointer = void*;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void*}, q{SDL_malloc}, q{size_t size}},
		{q{void*}, q{SDL_calloc}, q{size_t nMemb, size_t size}},
		{q{void*}, q{SDL_realloc}, q{void* mem, size_t size}},
		{q{void}, q{SDL_free}, q{void* mem}},
		
		{q{void}, q{SDL_GetOriginalMemoryFunctions}, q{SDL_malloc_func* mAllocFunc, SDL_calloc_func* cAllocFunc, SDL_realloc_func* reallocFunc, SDL_free_func* freeFunc}},
		{q{void}, q{SDL_GetMemoryFunctions}, q{SDL_malloc_func* mAllocFunc, SDL_calloc_func* cAllocFunc, SDL_realloc_func* reallocFunc, SDL_free_func* freeFunc}},
		{q{int}, q{SDL_SetMemoryFunctions}, q{SDL_malloc_func mAllocFunc, SDL_calloc_func cAllocFunc, SDL_realloc_func reallocFunc, SDL_free_func freeFunc}},
		
		{q{void*}, q{SDL_aligned_alloc}, q{size_t alignment, size_t size}},
		{q{void}, q{SDL_aligned_free}, q{void* mem}},
		
		{q{int}, q{SDL_GetNumAllocations}, q{}},
		
		{q{char*}, q{SDL_getenv}, q{const(char)* name}},
		{q{int}, q{SDL_setenv}, q{const(char)* name, const(char)* value, int overwrite}},
		
		{q{void}, q{SDL_qsort}, q{void* base, size_t nMemb, size_t size, CompareFn compare}},
		{q{void*}, q{SDL_bsearch}, q{const(void)* key, const(void)* base, size_t nMemb, size_t size, CompareFn compare}},
		
		{q{void}, q{SDL_qsort_r}, q{void* base, size_t nMemb, size_t size, RCompareFn compare, void* userData}},
		{q{void*}, q{SDL_bsearch_r}, q{const(void)* key, const(void)* base, size_t nMemb, size_t size, RCompareFn compare, void* userData}},
		{q{int}, q{SDL_abs}, q{int x}},
		
		{q{int}, q{SDL_isalpha}, q{int x}},
		{q{int}, q{SDL_isalnum}, q{int x}},
		{q{int}, q{SDL_isblank}, q{int x}},
		{q{int}, q{SDL_iscntrl}, q{int x}},
		{q{int}, q{SDL_isdigit}, q{int x}},
		{q{int}, q{SDL_isxdigit}, q{int x}},
		{q{int}, q{SDL_ispunct}, q{int x}},
		{q{int}, q{SDL_isspace}, q{int x}},
		{q{int}, q{SDL_isupper}, q{int x}},
		{q{int}, q{SDL_islower}, q{int x}},
		{q{int}, q{SDL_isprint}, q{int x}},
		{q{int}, q{SDL_isgraph}, q{int x}},
		{q{int}, q{SDL_toupper}, q{int x}},
		{q{int}, q{SDL_tolower}, q{int x}},
		
		{q{ushort}, q{SDL_crc16}, q{ushort crc, const(void)* data, size_t len}},
		{q{uint}, q{SDL_crc32}, q{uint crc, const(void)* data, size_t len}},
		
		{q{void*}, q{SDL_memcpy}, q{void* dst, const(void)* src, size_t len}},
		
		{q{void*}, q{SDL_memmove}, q{void* dst, const(void)* src, size_t len}},
		
		{q{void*}, q{SDL_memset}, q{void* dst, int c, size_t len}},
		{q{void*}, q{SDL_memset4}, q{void* dst, uint val, size_t dWords}},
		
		{q{int}, q{SDL_memcmp}, q{const(void)* s1, const(void)* s2, size_t len}},
		
		{q{size_t}, q{SDL_wcslen}, q{const(wchar_t)* wStr}},
		{q{size_t}, q{SDL_wcsnlen}, q{const(wchar_t)* wStr, size_t maxLen}},
		{q{size_t}, q{SDL_wcslcpy}, q{wchar_t* dst, const(wchar_t)* src, size_t maxLen}},
		{q{size_t}, q{SDL_wcslcat}, q{wchar_t* dst, const(wchar_t)* src, size_t maxLen}},
		{q{wchar_t*}, q{SDL_wcsdup}, q{const(wchar_t)* wStr}},
		{q{wchar_t*}, q{SDL_wcsstr}, q{const(wchar_t)* haystack, const(wchar_t)* needle}},
		{q{wchar_t*}, q{SDL_wcsnstr}, q{const(wchar_t)* haystack, const(wchar_t)* needle, size_t maxlen}},
		
		{q{int}, q{SDL_wcscmp}, q{const(wchar_t)* str1, const(wchar_t)* str2}},
		{q{int}, q{SDL_wcsncmp}, q{const(wchar_t)* str1, const(wchar_t)* str2, size_t maxLen}},
		{q{int}, q{SDL_wcscasecmp}, q{const(wchar_t)* str1, const(wchar_t)* str2}},
		{q{int}, q{SDL_wcsncasecmp}, q{const(wchar_t)* str1, const(wchar_t)* str2, size_t len}},
		{q{long}, q{SDL_wcstol}, q{const(wchar_t)* str, wchar_t** endP, int base}},
		
		{q{size_t}, q{SDL_strlen}, q{const(char)* str}},
		{q{size_t}, q{SDL_strnlen}, q{const(char)* str, size_t maxLen}},
		{q{size_t}, q{SDL_strlcpy}, q{char* dst, const(char)* src, size_t maxLen}},
		{q{size_t}, q{SDL_utf8strlcpy}, q{char* dst, const(char)* src, size_t dstBytes}},
		{q{size_t}, q{SDL_strlcat}, q{char* dst, const(char)* src, size_t maxLen}},
		{q{char*}, q{SDL_strdup}, q{const(char)* str}},
		{q{char*}, q{SDL_strndup}, q{const(char)* str, size_t maxLen}},
		{q{char*}, q{SDL_strrev}, q{char* str}},
		{q{char*}, q{SDL_strupr}, q{char* str}},
		{q{char*}, q{SDL_strlwr}, q{char* str}},
		{q{char*}, q{SDL_strchr}, q{const(char)* str, int c}},
		{q{char*}, q{SDL_strrchr}, q{const(char)* str, int c}},
		{q{char*}, q{SDL_strstr}, q{const(char)* haystack, const(char)* needle}},
		{q{char*}, q{SDL_strnstr}, q{const(char)* haystack, const(char)* needle, size_t maxLen}},
		{q{char*}, q{SDL_strcasestr}, q{const(char)* haystack, const(char)* needle}},
		{q{char*}, q{SDL_strtok_r}, q{char* s1, const(char)* s2, char** saveptr}},
		{q{size_t}, q{SDL_utf8strlen}, q{const(char)* str}},
		{q{size_t}, q{SDL_utf8strnlen}, q{const(char)* str, size_t bytes}},
		
		{q{char*}, q{SDL_itoa}, q{int value, char* str, int radix}},
		{q{char*}, q{SDL_uitoa}, q{uint value, char* str, int radix}},
		{q{char*}, q{SDL_ltoa}, q{c_long value, char* str, int radix}},
		{q{char*}, q{SDL_ultoa}, q{c_ulong value, char* str, int radix}},
		{q{char*}, q{SDL_lltoa}, q{long value, char* str, int radix}},
		{q{char*}, q{SDL_ulltoa}, q{ulong value, char* str, int radix}},
		
		{q{int}, q{SDL_atoi}, q{const(char)* str}},
		{q{double}, q{SDL_atof}, q{const(char)* str}},
		{q{c_long}, q{SDL_strtol}, q{const(char)* str, char** endP, int base}},
		{q{c_ulong}, q{SDL_strtoul}, q{const(char)* str, char** endP, int base}},
		{q{long}, q{SDL_strtoll}, q{const(char)* str, char** endP, int base}},
		{q{ulong}, q{SDL_strtoull}, q{const(char)* str, char** endP, int base}},
		{q{double}, q{SDL_strtod}, q{const(char)* str, char** endP}},
		
		{q{int}, q{SDL_strcmp}, q{const(char)* str1, const(char)* str2}},
		{q{int}, q{SDL_strncmp}, q{const(char)* str1, const(char)* str2, size_t maxLen}},
		{q{int}, q{SDL_strcasecmp}, q{const(char)* str1, const(char)* str2}},
		{q{int}, q{SDL_strncasecmp}, q{const(char)* str1, const(char)* str2, size_t len}},
		
		{q{int}, q{SDL_sscanf}, q{const(char)* text, const(char)* fmt, ...}},
		{q{int}, q{SDL_vsscanf}, q{const(char)* text, const(char)* fmt, va_list ap}},
		{q{int}, q{SDL_snprintf}, q{char* text, size_t maxLen, const(char)* fmt, ...}},
		{q{int}, q{SDL_swprintf}, q{wchar_t* text, size_t maxLen, const(wchar_t)* fmt, ...}},
		{q{int}, q{SDL_vsnprintf}, q{char* text, size_t maxLen, const(char)* fmt, va_list ap}},
		{q{int}, q{SDL_vswprintf}, q{wchar_t* text, size_t maxLen, const(wchar_t)* fmt, va_list ap}},
		{q{int}, q{SDL_asprintf}, q{char** strP, const(char)* fmt, ...}},
		{q{int}, q{SDL_vasprintf}, q{char** strP, const(char)* fmt, va_list ap}},
		
		{q{double}, q{SDL_acos}, q{double x}},
		{q{float}, q{SDL_acosf}, q{float x}},
		{q{double}, q{SDL_asin}, q{double x}},
		{q{float}, q{SDL_asinf}, q{float x}},
		{q{double}, q{SDL_atan}, q{double x}},
		{q{float}, q{SDL_atanf}, q{float x}},
		{q{double}, q{SDL_atan2}, q{double y, double x}},
		{q{float}, q{SDL_atan2f}, q{float y, float x}},
		{q{double}, q{SDL_ceil}, q{double x}},
		{q{float}, q{SDL_ceilf}, q{float x}},
		{q{double}, q{SDL_copysign}, q{double x, double y}},
		{q{float}, q{SDL_copysignf}, q{float x, float y}},
		{q{double}, q{SDL_cos}, q{double x}},
		{q{float}, q{SDL_cosf}, q{float x}},
		{q{double}, q{SDL_exp}, q{double x}},
		{q{float}, q{SDL_expf}, q{float x}},
		{q{double}, q{SDL_fabs}, q{double x}},
		{q{float}, q{SDL_fabsf}, q{float x}},
		{q{double}, q{SDL_floor}, q{double x}},
		{q{float}, q{SDL_floorf}, q{float x}},
		{q{double}, q{SDL_trunc}, q{double x}},
		{q{float}, q{SDL_truncf}, q{float x}},
		{q{double}, q{SDL_fmod}, q{double x, double y}},
		{q{float}, q{SDL_fmodf}, q{float x, float y}},
		{q{double}, q{SDL_log}, q{double x}},
		{q{float}, q{SDL_logf}, q{float x}},
		{q{double}, q{SDL_log10}, q{double x}},
		{q{float}, q{SDL_log10f}, q{float x}},
		{q{double}, q{SDL_modf}, q{double x, double* y}},
		{q{float}, q{SDL_modff}, q{float x, float* y}},
		{q{double}, q{SDL_pow}, q{double x, double y}},
		{q{float}, q{SDL_powf}, q{float x, float y}},
		{q{double}, q{SDL_round}, q{double x}},
		{q{float}, q{SDL_roundf}, q{float x}},
		{q{long}, q{SDL_lround}, q{double x}},
		{q{long}, q{SDL_lroundf}, q{float x}},
		{q{double}, q{SDL_scalbn}, q{double x, int n}},
		{q{float}, q{SDL_scalbnf}, q{float x, int n}},
		{q{double}, q{SDL_sin}, q{double x}},
		{q{float}, q{SDL_sinf}, q{float x}},
		{q{double}, q{SDL_sqrt}, q{double x}},
		{q{float}, q{SDL_sqrtf}, q{float x}},
		{q{double}, q{SDL_tan}, q{double x}},
		{q{float}, q{SDL_tanf}, q{float x}},
		
		{q{SDL_iconv_t}, q{SDL_iconv_open}, q{const(char)* toCode, const(char)* fromCode}},
		{q{int}, q{SDL_iconv_close}, q{SDL_iconv_t cd}},
		{q{size_t}, q{SDL_iconv}, q{SDL_iconv_t cd, const(char)** inBuf, size_t* inBytesLeft, char** outBuf, size_t* outBytesLeft}},
		{q{char*}, q{SDL_iconv_string}, q{const(char)* toCode, const(char)* fromCode, const(char)* inBuf, size_t inBytesLeft}},
	];
	return ret;
}()));
