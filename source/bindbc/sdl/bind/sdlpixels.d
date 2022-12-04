/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlpixels;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc: SDL_FOURCC, SDL_bool;

enum SDL_ALPHA_OPAQUE = 255;
enum SDL_ALPHA_TRANSPARENT = 0;

enum SDL_PixelType{
	SDL_PIXELTYPE_UNKNOWN,
	SDL_PIXELTYPE_INDEX1,
	SDL_PIXELTYPE_INDEX4,
	SDL_PIXELTYPE_INDEX8,
	SDL_PIXELTYPE_PACKED8,
	SDL_PIXELTYPE_PACKED16,
	SDL_PIXELTYPE_PACKED32,
	SDL_PIXELTYPE_ARRAYU8,
	SDL_PIXELTYPE_ARRAYU16,
	SDL_PIXELTYPE_ARRAYU32,
	SDL_PIXELTYPE_ARRAYF16,
	SDL_PIXELTYPE_ARRAYF32,
}
mixin(expandEnum!SDL_PixelType);

enum SDL_BitmapOrder{
	SDL_BITMAPORDER_NONE,
	SDL_BITMAPORDER_4321,
	SDL_BITMAPORDER_1234,
}
mixin(expandEnum!SDL_BitmapOrder);

enum SDL_PackedOrder{
	SDL_PACKEDORDER_NONE,
	SDL_PACKEDORDER_XRGB,
	SDL_PACKEDORDER_RGBX,
	SDL_PACKEDORDER_ARGB,
	SDL_PACKEDORDER_RGBA,
	SDL_PACKEDORDER_XBGR,
	SDL_PACKEDORDER_BGRX,
	SDL_PACKEDORDER_ABGR,
	SDL_PACKEDORDER_BGRA,
}
mixin(expandEnum!SDL_PackedOrder);

enum SDL_ArrayOrder{
	SDL_ARRAYORDER_NONE,
	SDL_ARRAYORDER_RGB,
	SDL_ARRAYORDER_RGBA,
	SDL_ARRAYORDER_ARGB,
	SDL_ARRAYORDER_BGR,
	SDL_ARRAYORDER_BGRA,
	SDL_ARRAYORDER_ABGR,
}
mixin(expandEnum!SDL_ArrayOrder);

enum SDL_PackedLayout{
	SDL_PACKEDLAYOUT_NONE,
	SDL_PACKEDLAYOUT_332,
	SDL_PACKEDLAYOUT_4444,
	SDL_PACKEDLAYOUT_1555,
	SDL_PACKEDLAYOUT_5551,
	SDL_PACKEDLAYOUT_565,
	SDL_PACKEDLAYOUT_8888,
	SDL_PACKEDLAYOUT_2101010,
	SDL_PACKEDLAYOUT_1010102,
}
mixin(expandEnum!SDL_PackedLayout);

alias SDL_DEFINE_PIXELFOURCC = SDL_FOURCC;

enum uint SDL_DEFINE_PIXELFORMAT(int type, int order, int layout, int bits, int bytes) =
	(1 << 28) | (type << 24) | (order << 20) | (layout << 16) | (bits << 8) | (bytes << 0);

enum uint SDL_PIXELFLAG(uint x) = (x >> 28) & 0x0F;
enum uint SDL_PIXELTYPE(uint x) = (x >> 24) & 0x0F;
enum uint SDL_PIXELORDER(uint x) = (x >> 20) & 0x0F;
enum uint SDL_PIXELLAYOUT(uint x) = (x >> 16) & 0x0F;
enum uint SDL_BITSPERPIXEL(uint x) = (x >> 8) & 0xFF;

template SDL_BYTESPERPIXEL(uint x){
	static if(SDL_ISPIXELFORMAT_FOURCC!x){
		static if(x == SDL_PIXELFORMAT_YUY2 || x == SDL_PIXELFORMAT_UYVY || x == SDL_PIXELFORMAT_YVYU){
			enum SDL_BYTESPERPIXEL = 2;
		}else{
			enum SDL_BYTESPERPIXEL = 1;
		}
	}else enum SDL_BYTESPERPIXEL = (x >> 0) & 0xFF;
}

template SDL_ISPIXELFORMAT_INDEXED(uint format){
	static if(SDL_ISPIXELFORMAT_FOURCC!format){
		enum SDL_ISPIXELFORMAT_INDEXED =
			SDL_PIXELTYPE!format == SDL_PIXELTYPE_INDEX1 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_INDEX4 ||
			SDL_PIXELTYPE!format == SDL_PIXELTYPE_INDEX8;
	}else enum SDL_ISPIXELFORMAT_INDEXED = false;
}

template SDL_ISPIXELFORMAT_PACKED(uint format){
	static if(SDL_ISPIXELFORMAT_FOURCC!format){
		enum SDL_ISPIXELFORMAT_PACKED =
			SDL_PIXELTYPE!format == SDL_PIXELTYPE_PACKED8 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_PACKED16 ||
			SDL_PIXELTYPE!format == SDL_PIXELTYPE_PACKED32;
	}else enum SDL_ISPIXELFORMAT_PACKED = false;
}

static if(sdlSupport >= SDLSupport.sdl204){
	template SDL_ISPIXELFORMAT_ARRAY(uint format){
		static if(SDL_ISPIXELFORMAT_FOURCC!format){
			enum SDL_ISPIXELFORMAT_ARRAY =
				SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYU8  || SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYU16 ||
				SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYU32 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYF16 ||
				SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYF32;
		}else enum SDL_ISPIXELFORMAT_ARRAY = false;
	}
}

template SDL_ISPIXELFORMAT_ALPHA(uint format){
	static if(SDL_ISPIXELFORMAT_PACKED!format){
		enum SDL_ISPIXELFORMAT_ALPHA =
				(SDL_PIXELORDER!format == SDL_PACKEDORDER_ARGB || SDL_PIXELORDER!format == SDL_PACKEDORDER_RGBA ||
				 SDL_PIXELORDER!format == SDL_PACKEDORDER_ABGR || SDL_PIXELORDER!format == SDL_PACKEDORDER_BGRA);
	}else static if(sdlSupport >= SDLSupport.sdl204 && SDL_ISPIXELFORMAT_ARRAY!format){
		enum SDL_ISPIXELFORMAT_ALPHA =
				(SDL_PIXELORDER!format == SDL_ARRAYORDER_ARGB || SDL_PIXELORDER!format == SDL_ARRAYORDER_RGBA ||
				 SDL_PIXELORDER!format == SDL_ARRAYORDER_ABGR || SDL_PIXELORDER!format == SDL_ARRAYORDER_BGRA);
	}else enum SDL_ISPIXELFORMAT_ALPHA = false;
}

enum SDL_ISPIXELFORMAT_FOURCC(uint format) = format && !(format & 0x80000000);

enum SDL_PIXELFORMAT_UNKNOWN        = 0;
enum SDL_PIXELFORMAT_INDEX1LSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX1,    SDL_BITMAPORDER_4321,  0,                         1,   0);
enum SDL_PIXELFORMAT_INDEX1MSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX1,    SDL_BITMAPORDER_1234,  0,                         1,   0);
enum SDL_PIXELFORMAT_INDEX4LSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX4,    SDL_BITMAPORDER_4321,  0,                         4,   0);
enum SDL_PIXELFORMAT_INDEX4MSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX4,    SDL_BITMAPORDER_1234,  0,                         4,   0);
enum SDL_PIXELFORMAT_INDEX8         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX8,    0,                     0,                         8,   1);
enum SDL_PIXELFORMAT_RGB332         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED8,   SDL_PACKEDORDER_XRGB,  SDL_PACKEDLAYOUT_332,      8,   1);
enum SDL_PIXELFORMAT_XRGB444        = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_XRGB,  SDL_PACKEDLAYOUT_4444,     12,  2);
enum SDL_PIXELFORMAT_RGB444         = SDL_PIXELFORMAT_XRGB444;
enum SDL_PIXELFORMAT_XBGR444        = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_XBGR,  SDL_PACKEDLAYOUT_4444,     12,  2);
enum SDL_PIXELFORMAT_BGR444         = SDL_PIXELFORMAT_XBGR444;
enum SDL_PIXELFORMAT_XRGB1555       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_XRGB,  SDL_PACKEDLAYOUT_1555,     15,  2);
enum SDL_PIXELFORMAT_RGB555         = SDL_PIXELFORMAT_XRGB1555;
enum SDL_PIXELFORMAT_XBGR1555       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_XBGR,  SDL_PACKEDLAYOUT_1555,     15,  2);
enum SDL_PIXELFORMAT_BGR555         = SDL_PIXELFORMAT_XBGR1555;
enum SDL_PIXELFORMAT_ARGB4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_ARGB,  SDL_PACKEDLAYOUT_4444,     16,  2);
enum SDL_PIXELFORMAT_RGBA4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_RGBA,  SDL_PACKEDLAYOUT_4444,     16,  2);
enum SDL_PIXELFORMAT_ABGR4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_ABGR,  SDL_PACKEDLAYOUT_4444,     16,  2);
enum SDL_PIXELFORMAT_BGRA4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_BGRA,  SDL_PACKEDLAYOUT_4444,     16,  2);
enum SDL_PIXELFORMAT_ARGB1555       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_ARGB,  SDL_PACKEDLAYOUT_1555,     16,  2);
enum SDL_PIXELFORMAT_RGBA5551       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_RGBA,  SDL_PACKEDLAYOUT_5551,     16,  2);
enum SDL_PIXELFORMAT_ABGR1555       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_ABGR,  SDL_PACKEDLAYOUT_1555,     16,  2);
enum SDL_PIXELFORMAT_BGRA5551       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_BGRA,  SDL_PACKEDLAYOUT_5551,     16,  2);
enum SDL_PIXELFORMAT_RGB565         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_XRGB,  SDL_PACKEDLAYOUT_565,      16,  2);
enum SDL_PIXELFORMAT_BGR565         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16,  SDL_PACKEDORDER_XBGR,  SDL_PACKEDLAYOUT_565,      16,  2);
enum SDL_PIXELFORMAT_RGB24          = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_ARRAYU8,   SDL_ARRAYORDER_RGB,    0,                         24,  3);
enum SDL_PIXELFORMAT_BGR24          = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_ARRAYU8,   SDL_ARRAYORDER_BGR,    0,                         24,  3);
enum SDL_PIXELFORMAT_XRGB888        = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_XRGB,  SDL_PACKEDLAYOUT_8888,     24,  4);
enum SDL_PIXELFORMAT_RGB888         = SDL_PIXELFORMAT_XRGB888;
enum SDL_PIXELFORMAT_RGBX8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_RGBX,  SDL_PACKEDLAYOUT_8888,     24,  4);
enum SDL_PIXELFORMAT_XBGR888        = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_XBGR,  SDL_PACKEDLAYOUT_8888,     24,  4);
enum SDL_PIXELFORMAT_BGR888         = SDL_PIXELFORMAT_XBGR888;
enum SDL_PIXELFORMAT_BGRX8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_BGRX,  SDL_PACKEDLAYOUT_8888,     24,  4);
enum SDL_PIXELFORMAT_ARGB8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_ARGB,  SDL_PACKEDLAYOUT_8888,     32,  4);
enum SDL_PIXELFORMAT_RGBA8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_RGBA,  SDL_PACKEDLAYOUT_8888,     32,  4);
enum SDL_PIXELFORMAT_ABGR8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_ABGR,  SDL_PACKEDLAYOUT_8888,     32,  4);
enum SDL_PIXELFORMAT_BGRA8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_BGRA,  SDL_PACKEDLAYOUT_8888,     32,  4);
enum SDL_PIXELFORMAT_ARGB2101010    = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32,  SDL_PACKEDORDER_ARGB,  SDL_PACKEDLAYOUT_2101010,  32,  4);

enum SDL_PIXELFORMAT_YV12           = SDL_DEFINE_PIXELFOURCC!('Y', 'V', '1', '2');
enum SDL_PIXELFORMAT_IYUV           = SDL_DEFINE_PIXELFOURCC!('I', 'Y', 'U', 'V');
enum SDL_PIXELFORMAT_YUY2           = SDL_DEFINE_PIXELFOURCC!('Y', 'U', 'Y', '2');
enum SDL_PIXELFORMAT_UYVY           = SDL_DEFINE_PIXELFOURCC!('U', 'Y', 'V', 'Y');
enum SDL_PIXELFORMAT_YVYU           = SDL_DEFINE_PIXELFOURCC!('Y', 'V', 'Y', 'U');

static if(sdlSupport >= SDLSupport.sdl204){
	enum SDL_PIXELFORMAT_NV12       = SDL_DEFINE_PIXELFOURCC!('N', 'V', '1', '2');
	enum SDL_PIXELFORMAT_NV21       = SDL_DEFINE_PIXELFOURCC!('N', 'V', '2', '1');
}

static if(sdlSupport >= SDLSupport.sdl208){
	enum SDL_PIXELFORMAT_EXTERNAL_OES   = SDL_DEFINE_PIXELFOURCC!('O', 'E', 'S', ' ');
}

static assert(SDL_PIXELFORMAT_BGRX8888 == 0x16661804);

// Added in SDL 2.0.5, but doesn't hurt to make available for every version.
version(BigEndian){
	alias SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888;
	alias SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888;
	alias SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888;
	alias SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888;
}
else{
	alias SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888;
	alias SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888;
	alias SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888;
	alias SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888;
}

struct SDL_Color{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a;
}
alias SDL_Colour = SDL_Color;

struct SDL_Palette{
	int ncolors;
	SDL_Color* colors;
	uint version_; //NOTE: the original is named `version`
	int refcount;
}

struct SDL_PixelFormat{
	uint format;
	SDL_Palette *palette;
	ubyte BitsPerPixel;
	ubyte BytesPerPixel;
	ubyte[2] padding;
	uint Rmask;
	uint Gmask;
	uint Bmask;
	uint Amask;
	ubyte Rloss;
	ubyte Gloss;
	ubyte Bloss;
	ubyte Aloss;
	ubyte Rshift;
	ubyte Gshift;
	ubyte Bshift;
	ubyte Ashift;
	int refcount;
	SDL_PixelFormat* next;
}

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{const(char)*}, q{SDL_GetPixelFormatName}, q{uint format}],
		[q{SDL_bool}, q{SDL_PixelFormatEnumToMasks}, q{uint format, int* bpp, uint* Rmask, uint* Gmask, uint* Bmask, uint* Amask}],
		[q{uint}, q{SDL_MasksToPixelFormatEnum}, q{int bpp, uint Rmask, uint Gmask, uint Bmask, uint Amask}],
		[q{SDL_PixelFormat*}, q{SDL_AllocFormat}, q{uint pixel_format}],
		[q{void}, q{SDL_FreeFormat}, q{SDL_PixelFormat* format}],
		[q{SDL_Palette*}, q{SDL_AllocPalette}, q{int ncolors}],
		[q{int}, q{SDL_SetPixelFormatPalette}, q{SDL_PixelFormat* format,SDL_Palette* palette}],
		[q{int}, q{SDL_SetPaletteColors}, q{SDL_Palette* palette, const(SDL_Color)* colors, int firstcolor, int ncolors}],
		[q{void}, q{SDL_FreePalette}, q{SDL_Palette* palette}],
		[q{uint}, q{SDL_MapRGB}, q{const(SDL_PixelFormat)* format, ubyte r, ubyte g, ubyte b}],
		[q{uint}, q{SDL_MapRGBA}, q{const(SDL_PixelFormat)* format, ubyte r, ubyte g, ubyte b, ubyte a}],
		[q{void}, q{SDL_GetRGB}, q{uint pixel, const(SDL_PixelFormat)* format, ubyte* r, ubyte* g, ubyte* b}],
		[q{void}, q{SDL_GetRGBA}, q{uint pixel, const(SDL_PixelFormat)* format, ubyte* r, ubyte* g, ubyte* b, ubyte* a}],
		[q{void}, q{SDL_CalculateGammaRamp}, q{float gamma, ushort* ramp}],
	);
	return ret;
}()));
