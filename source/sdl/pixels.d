/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.pixels;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc;
import sdl.endian;

enum ubyte SDL_AlphaOpaque = 255;
alias SDL_ALPHA_OPAQUE = SDL_AlphaOpaque;
enum ubyte SDL_AlphaTransparent = 0;
alias SDL_ALPHA_TRANSPARENT = SDL_AlphaTransparent;

mixin(makeEnumBind(q{SDL_PixelType}, members: (){
	EnumMember[] ret = [
		{{q{unknown},     q{SDL_PIXELTYPE_UNKNOWN}}},
		{{q{index1},      q{SDL_PIXELTYPE_INDEX1}}},
		{{q{index4},      q{SDL_PIXELTYPE_INDEX4}}},
		{{q{index8},      q{SDL_PIXELTYPE_INDEX8}}},
		{{q{packed8},     q{SDL_PIXELTYPE_PACKED8}}},
		{{q{packed16},    q{SDL_PIXELTYPE_PACKED16}}},
		{{q{packed32},    q{SDL_PIXELTYPE_PACKED32}}},
		{{q{arrayU8},     q{SDL_PIXELTYPE_ARRAYU8}}},
		{{q{arrayU16},    q{SDL_PIXELTYPE_ARRAYU16}}},
		{{q{arrayU32},    q{SDL_PIXELTYPE_ARRAYU32}}},
		{{q{arrayF16},    q{SDL_PIXELTYPE_ARRAYF16}}},
		{{q{arrayF32},    q{SDL_PIXELTYPE_ARRAYF32}}},
		
		{{q{index2},      q{SDL_PIXELTYPE_INDEX2}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_BitmapOrder}, members: (){
	EnumMember[] ret = [
			{{q{none},     q{SDL_BITMAPORDER_NONE}}},
			{{q{_4321},    q{SDL_BITMAPORDER_4321}}},
			{{q{_1234},    q{SDL_BITMAPORDER_1234}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_PackedOrder}, members: (){
	EnumMember[] ret = [
		{{q{none},    q{SDL_PACKEDORDER_NONE}}},
		{{q{xrgb},    q{SDL_PACKEDORDER_XRGB}}},
		{{q{rgbx},    q{SDL_PACKEDORDER_RGBX}}},
		{{q{argb},    q{SDL_PACKEDORDER_ARGB}}},
		{{q{rgba},    q{SDL_PACKEDORDER_RGBA}}},
		{{q{xbgr},    q{SDL_PACKEDORDER_XBGR}}},
		{{q{bgrx},    q{SDL_PACKEDORDER_BGRX}}},
		{{q{abgr},    q{SDL_PACKEDORDER_ABGR}}},
		{{q{bgra},    q{SDL_PACKEDORDER_BGRA}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ArrayOrder}, members: (){
	EnumMember[] ret = [
		{{q{none},    q{SDL_ARRAYORDER_NONE}}},
		{{q{rgb},     q{SDL_ARRAYORDER_RGB}}},
		{{q{rgba},    q{SDL_ARRAYORDER_RGBA}}},
		{{q{argb},    q{SDL_ARRAYORDER_ARGB}}},
		{{q{bgr},     q{SDL_ARRAYORDER_BGR}}},
		{{q{bgra},    q{SDL_ARRAYORDER_BGRA}}},
		{{q{abgr},    q{SDL_ARRAYORDER_ABGR}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_PackedLayout}, members: (){
	EnumMember[] ret = [
		{{q{none},        q{SDL_PACKEDLAYOUT_NONE}}},
		{{q{_332},        q{SDL_PACKEDLAYOUT_332}}},
		{{q{_4444},       q{SDL_PACKEDLAYOUT_4444}}},
		{{q{_1555},       q{SDL_PACKEDLAYOUT_1555}}},
		{{q{_5551},       q{SDL_PACKEDLAYOUT_5551}}},
		{{q{_565},        q{SDL_PACKEDLAYOUT_565}}},
		{{q{_8888},       q{SDL_PACKEDLAYOUT_8888}}},
		{{q{_2101010},    q{SDL_PACKEDLAYOUT_2101010}}},
		{{q{_1010102},    q{SDL_PACKEDLAYOUT_1010102}}},
	];
	return ret;
}()));

uint SDL_DefinePixelFourCC(ubyte a, ubyte b, ubyte c, ubyte d) nothrow @nogc pure @safe =>
	SDL_FourCC(a, b, c, d);
alias SDL_DEFINE_PIXELFOURCC = SDL_DefinePixelFourCC;

pragma(inline,true) nothrow @nogc pure @safe{
	SDL_PixelFormatEnum SDL_DefinePixelFormat(int type, int order, int layout, uint bits, uint bytes) =>
		cast(SDL_PixelFormatEnum)(
			(1      << 28) | (type << 24) | (order << 20) |
			(layout << 16) | (bits << 8)  | (bytes << 0)
		);
	alias SDL_DEFINE_PIXELFORMAT = SDL_DefinePixelFormat;
	
	ubyte SDL_PixelFlag(SDL_PixelFormatEnum x)     => cast(ubyte)((x >> 28) & 0x0F);
	ubyte SDL_PixelType(SDL_PixelFormatEnum x)     => cast(ubyte)((x >> 24) & 0x0F);
	ubyte SDL_PixelOrder(SDL_PixelFormatEnum x)    => cast(ubyte)((x >> 20) & 0x0F);
	ubyte SDL_PixelLayout(SDL_PixelFormatEnum x)   => cast(ubyte)((x >> 16) & 0x0F);
	ubyte SDL_BitsPerPixel(SDL_PixelFormatEnum x)  => cast(ubyte)((x >>  8) & 0xFF);
	ubyte SDL_BytesPerPixel(SDL_PixelFormatEnum x) => cast(ubyte)(
		SDL_IsPixelFormatFourCC(x) ? ((
				(x == SDL_PixelFormat.yuy2) ||
				(x == SDL_PixelFormat.uyvy) ||
				(x == SDL_PixelFormat.yvyu) ||
				(x == SDL_PixelFormat.p010)
		) ? 2 : 1) : (
			(x >> 0) & 0xFF
		)
	);
	alias SDL_PIXELFLAG = SDL_PixelFlag;
	alias SDL_PIXELTYPE = SDL_PixelType;
	alias SDL_PIXELORDER = SDL_PixelOrder;
	alias SDL_PIXELLAYOUT = SDL_PixelLayout;
	alias SDL_BITSPERPIXEL = SDL_BitsPerPixel;
	alias SDL_BYTESPERPIXEL = SDL_BytesPerPixel;
	
	bool SDL_IsPixelFormatIndexed(SDL_PixelFormatEnum format) =>
		!SDL_IsPixelFormatFourCC(format) && (
			(SDL_PixelType(format) == SDL_PixelType.index1) ||
			(SDL_PixelType(format) == SDL_PixelType.index2) ||
			(SDL_PixelType(format) == SDL_PixelType.index4) ||
			(SDL_PixelType(format) == SDL_PixelType.index8)
		);
	bool SDL_IsPixelFormatPacked(SDL_PixelFormatEnum format) =>
		!SDL_IsPixelFormatFourCC(format) && (
			(SDL_PixelType(format) == SDL_PixelType.packed8)  ||
			(SDL_PixelType(format) == SDL_PixelType.packed16) ||
			(SDL_PixelType(format) == SDL_PixelType.packed32)
		);
	bool SDL_IsPixelFormatArray(SDL_PixelFormatEnum format) =>
		!SDL_IsPixelFormatFourCC(format) && (
			(SDL_PixelType(format) == SDL_PixelType.arrayU8)  ||
			(SDL_PixelType(format) == SDL_PixelType.arrayU16) ||
			(SDL_PixelType(format) == SDL_PixelType.arrayU32) ||
			(SDL_PixelType(format) == SDL_PixelType.arrayF16) ||
			(SDL_PixelType(format) == SDL_PixelType.arrayF32)
		);
	bool SDL_IsPixelFormatAlpha(SDL_PixelFormatEnum format) =>
		SDL_IsPixelFormatFourCC(format) && (
			(SDL_PixelOrder(format) == SDL_PackedOrder.argb) ||
			(SDL_PixelOrder(format) == SDL_PackedOrder.rgba) ||
			(SDL_PixelOrder(format) == SDL_PackedOrder.abgr) ||
			(SDL_PixelOrder(format) == SDL_PackedOrder.bgra)
		);
	bool SDL_IsPixelFormat10Bit(SDL_PixelFormatEnum format) =>
		!SDL_IsPixelFormatFourCC(format) && (
			(SDL_PixelType(format) == SDL_PixelType.packed32) &&
			(SDL_PixelLayout(format) == SDL_PackedLayout._2101010)
		);
	bool SDL_IsPixelFormatFloat(SDL_PixelFormatEnum format) =>
		!SDL_IsPixelFormatFourCC(format) && (
			(SDL_PixelType(format) == SDL_PixelType.arrayF16) ||
			(SDL_PixelType(format) == SDL_PixelType.arrayF32)
		);
	bool SDL_IsPixelFormatFourCC(SDL_PixelFormatEnum format) =>
		format && (SDL_PixelFlag(format) != 1);
	alias SDL_ISPIXELFORMAT_INDEXED = SDL_IsPixelFormatIndexed;
	alias SDL_ISPIXELFORMAT_PACKED = SDL_IsPixelFormatPacked;
	alias SDL_ISPIXELFORMAT_ARRAY = SDL_IsPixelFormatArray;
	alias SDL_ISPIXELFORMAT_ALPHA = SDL_IsPixelFormatAlpha;
	alias SDL_ISPIXELFORMAT_10BIT = SDL_IsPixelFormat10Bit;
	alias SDL_ISPIXELFORMAT_FLOAT = SDL_IsPixelFormatFloat;
	alias SDL_ISPIXELFORMAT_FOURCC = SDL_IsPixelFormatFourCC;
}

mixin(makeEnumBind(q{SDL_PixelFormatEnum}, members: (){
	EnumMember[] ret = [
		{{q{unknown},         q{SDL_PIXELFORMAT_UNKNOWN}}},
		{{q{index1LSB},       q{SDL_PIXELFORMAT_INDEX1LSB}},        q{SDL_DefinePixelFormat(SDL_PixelType.index1,    SDL_BitmapOrder._4321,  0,                           1,    0)}},
		{{q{index1MSB},       q{SDL_PIXELFORMAT_INDEX1MSB}},        q{SDL_DefinePixelFormat(SDL_PixelType.index1,    SDL_BitmapOrder._1234,  0,                           1,    0)}},
		{{q{index2LSB},       q{SDL_PIXELFORMAT_INDEX2LSB}},        q{SDL_DefinePixelFormat(SDL_PixelType.index2,    SDL_BitmapOrder._4321,  0,                           2,    0)}},
		{{q{index2MSB},       q{SDL_PIXELFORMAT_INDEX2MSB}},        q{SDL_DefinePixelFormat(SDL_PixelType.index2,    SDL_BitmapOrder._1234,  0,                           2,    0)}},
		{{q{index4LSB},       q{SDL_PIXELFORMAT_INDEX4LSB}},        q{SDL_DefinePixelFormat(SDL_PixelType.index4,    SDL_BitmapOrder._4321,  0,                           4,    0)}},
		{{q{index4MSB},       q{SDL_PIXELFORMAT_INDEX4MSB}},        q{SDL_DefinePixelFormat(SDL_PixelType.index4,    SDL_BitmapOrder._1234,  0,                           4,    0)}},
		{{q{index8},          q{SDL_PIXELFORMAT_INDEX8}},           q{SDL_DefinePixelFormat(SDL_PixelType.index8,    0,                      0,                           8,    1)}},
		{{q{rgb332},          q{SDL_PIXELFORMAT_RGB332}},           q{SDL_DefinePixelFormat(SDL_PixelType.packed8,   SDL_PackedOrder.xrgb,   SDL_PackedLayout._332,       8,    1)}},
		{{q{xrgb4444},        q{SDL_PIXELFORMAT_XRGB4444}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.xrgb,   SDL_PackedLayout._4444,     12,    2)}},
		{{q{rgb444},          q{SDL_PIXELFORMAT_RGB444}},           q{SDL_PixelFormatEnum.xrgb4444}},
		{{q{xbgr4444},        q{SDL_PIXELFORMAT_XBGR4444}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.xbgr,   SDL_PackedLayout._4444,     12,    2)}},
		{{q{bgr444},          q{SDL_PIXELFORMAT_BGR444}},           q{SDL_PixelFormatEnum.xbgr4444}},
		{{q{xrgb1555},        q{SDL_PIXELFORMAT_XRGB1555}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.xrgb,   SDL_PackedLayout._1555,     15,    2)}},
		{{q{rgb555},          q{SDL_PIXELFORMAT_RGB555}},           q{SDL_PixelFormatEnum.xrgb1555}},
		{{q{xbgr1555},        q{SDL_PIXELFORMAT_XBGR1555}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.xbgr,   SDL_PackedLayout._1555,     15,    2)}},
		{{q{bgr555},          q{SDL_PIXELFORMAT_BGR555}},           q{SDL_PixelFormatEnum.xbgr1555}},
		{{q{argb4444},        q{SDL_PIXELFORMAT_ARGB4444}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.argb,   SDL_PackedLayout._4444,     16,    2)}},
		{{q{rgba4444},        q{SDL_PIXELFORMAT_RGBA4444}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.rgba,   SDL_PackedLayout._4444,     16,    2)}},
		{{q{abgr4444},        q{SDL_PIXELFORMAT_ABGR4444}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.abgr,   SDL_PackedLayout._4444,     16,    2)}},
		{{q{bgra4444},        q{SDL_PIXELFORMAT_BGRA4444}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.bgra,   SDL_PackedLayout._4444,     16,    2)}},
		{{q{argb1555},        q{SDL_PIXELFORMAT_ARGB1555}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.argb,   SDL_PackedLayout._1555,     16,    2)}},
		{{q{rgba5551},        q{SDL_PIXELFORMAT_RGBA5551}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.rgba,   SDL_PackedLayout._5551,     16,    2)}},
		{{q{abgr1555},        q{SDL_PIXELFORMAT_ABGR1555}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.abgr,   SDL_PackedLayout._1555,     16,    2)}},
		{{q{bgra5551},        q{SDL_PIXELFORMAT_BGRA5551}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.bgra,   SDL_PackedLayout._5551,     16,    2)}},
		{{q{rgb565},          q{SDL_PIXELFORMAT_RGB565}},           q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.xrgb,   SDL_PackedLayout._565,      16,    2)}},
		{{q{bgr565},          q{SDL_PIXELFORMAT_BGR565}},           q{SDL_DefinePixelFormat(SDL_PixelType.packed16,  SDL_PackedOrder.xbgr,   SDL_PackedLayout._565,      16,    2)}},
		{{q{rgb24},           q{SDL_PIXELFORMAT_RGB24}},            q{SDL_DefinePixelFormat(SDL_PixelType.arrayU8,   SDL_ArrayOrder.rgb,     0,                          24,    3)}},
		{{q{bgr24},           q{SDL_PIXELFORMAT_BGR24}},            q{SDL_DefinePixelFormat(SDL_PixelType.arrayU8,   SDL_ArrayOrder.bgr,     0,                          24,    3)}},
		{{q{xrgb8888},        q{SDL_PIXELFORMAT_XRGB8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.xrgb,   SDL_PackedLayout._8888,     24,    4)}},
		{{q{rgbx8888},        q{SDL_PIXELFORMAT_RGBX8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.rgbx,   SDL_PackedLayout._8888,     24,    4)}},
		{{q{xbgr8888},        q{SDL_PIXELFORMAT_XBGR8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.xbgr,   SDL_PackedLayout._8888,     24,    4)}},
		{{q{bgrx8888},        q{SDL_PIXELFORMAT_BGRX8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.bgrx,   SDL_PackedLayout._8888,     24,    4)}},
		{{q{argb8888},        q{SDL_PIXELFORMAT_ARGB8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.argb,   SDL_PackedLayout._8888,     32,    4)}},
		{{q{rgba8888},        q{SDL_PIXELFORMAT_RGBA8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.rgba,   SDL_PackedLayout._8888,     32,    4)}},
		{{q{abgr8888},        q{SDL_PIXELFORMAT_ABGR8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.abgr,   SDL_PackedLayout._8888,     32,    4)}},
		{{q{bgra8888},        q{SDL_PIXELFORMAT_BGRA8888}},         q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.bgra,   SDL_PackedLayout._8888,     32,    4)}},
		{{q{xrgb2101010},     q{SDL_PIXELFORMAT_XRGB2101010}},      q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.xrgb,   SDL_PackedLayout._2101010,  32,    4)}},
		{{q{xbgr2101010},     q{SDL_PIXELFORMAT_XBGR2101010}},      q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.xbgr,   SDL_PackedLayout._2101010,  32,    4)}},
		{{q{argb2101010},     q{SDL_PIXELFORMAT_ARGB2101010}},      q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.argb,   SDL_PackedLayout._2101010,  32,    4)}},
		{{q{abgr2101010},     q{SDL_PIXELFORMAT_ABGR2101010}},      q{SDL_DefinePixelFormat(SDL_PixelType.packed32,  SDL_PackedOrder.abgr,   SDL_PackedLayout._2101010,  32,    4)}},
		{{q{rgb48},           q{SDL_PIXELFORMAT_RGB48}},            q{SDL_DefinePixelFormat(SDL_PixelType.arrayU16,  SDL_ArrayOrder.rgb,     0,                          48,    6)}},
		{{q{bgr48},           q{SDL_PIXELFORMAT_BGR48}},            q{SDL_DefinePixelFormat(SDL_PixelType.arrayU16,  SDL_ArrayOrder.bgr,     0,                          48,    6)}},
		{{q{rgba64},          q{SDL_PIXELFORMAT_RGBA64}},           q{SDL_DefinePixelFormat(SDL_PixelType.arrayU16,  SDL_ArrayOrder.rgba,    0,                          64,    8)}},
		{{q{argb64},          q{SDL_PIXELFORMAT_ARGB64}},           q{SDL_DefinePixelFormat(SDL_PixelType.arrayU16,  SDL_ArrayOrder.argb,    0,                          64,    8)}},
		{{q{bgra64},          q{SDL_PIXELFORMAT_BGRA64}},           q{SDL_DefinePixelFormat(SDL_PixelType.arrayU16,  SDL_ArrayOrder.bgra,    0,                          64,    8)}},
		{{q{abgr64},          q{SDL_PIXELFORMAT_ABGR64}},           q{SDL_DefinePixelFormat(SDL_PixelType.arrayU16,  SDL_ArrayOrder.abgr,    0,                          64,    8)}},
		{{q{rgb48Float},      q{SDL_PIXELFORMAT_RGB48_FLOAT}},      q{SDL_DefinePixelFormat(SDL_PixelType.arrayF16,  SDL_ArrayOrder.rgb,     0,                          48,    6)}},
		{{q{bgr48Float},      q{SDL_PIXELFORMAT_BGR48_FLOAT}},      q{SDL_DefinePixelFormat(SDL_PixelType.arrayF16,  SDL_ArrayOrder.bgr,     0,                          48,    6)}},
		{{q{rgba64Float},     q{SDL_PIXELFORMAT_RGBA64_FLOAT}},     q{SDL_DefinePixelFormat(SDL_PixelType.arrayF16,  SDL_ArrayOrder.rgba,    0,                          64,    8)}},
		{{q{argb64Float},     q{SDL_PIXELFORMAT_ARGB64_FLOAT}},     q{SDL_DefinePixelFormat(SDL_PixelType.arrayF16,  SDL_ArrayOrder.argb,    0,                          64,    8)}},
		{{q{bgra64Float},     q{SDL_PIXELFORMAT_BGRA64_FLOAT}},     q{SDL_DefinePixelFormat(SDL_PixelType.arrayF16,  SDL_ArrayOrder.bgra,    0,                          64,    8)}},
		{{q{abgr64Float},     q{SDL_PIXELFORMAT_ABGR64_FLOAT}},     q{SDL_DefinePixelFormat(SDL_PixelType.arrayF16,  SDL_ArrayOrder.abgr,    0,                          64,    8)}},
		{{q{rgb96Float},      q{SDL_PIXELFORMAT_RGB96_FLOAT}},      q{SDL_DefinePixelFormat(SDL_PixelType.arrayF32,  SDL_ArrayOrder.rgb,     0,                          96,   12)}},
		{{q{bgr96Float},      q{SDL_PIXELFORMAT_BGR96_FLOAT}},      q{SDL_DefinePixelFormat(SDL_PixelType.arrayF32,  SDL_ArrayOrder.bgr,     0,                          96,   12)}},
		{{q{rgba128Float},    q{SDL_PIXELFORMAT_RGBA128_FLOAT}},    q{SDL_DefinePixelFormat(SDL_PixelType.arrayF32,  SDL_ArrayOrder.rgba,    0,                          128,  16)}},
		{{q{argb128Float},    q{SDL_PIXELFORMAT_ARGB128_FLOAT}},    q{SDL_DefinePixelFormat(SDL_PixelType.arrayF32,  SDL_ArrayOrder.argb,    0,                          128,  16)}},
		{{q{bgra128Float},    q{SDL_PIXELFORMAT_BGRA128_FLOAT}},    q{SDL_DefinePixelFormat(SDL_PixelType.arrayF32,  SDL_ArrayOrder.bgra,    0,                          128,  16)}},
		{{q{abgr128Float},    q{SDL_PIXELFORMAT_ABGR128_FLOAT}},    q{SDL_DefinePixelFormat(SDL_PixelType.arrayF32,  SDL_ArrayOrder.abgr,    0,                          128,  16)}},
		
		{{q{yv12},            q{SDL_PIXELFORMAT_YV12}},             q{SDL_DefinePixelFourCC('Y', 'V', '1', '2')}},
		{{q{iyuv},            q{SDL_PIXELFORMAT_IYUV}},             q{SDL_DefinePixelFourCC('I', 'Y', 'U', 'V')}},
		{{q{yuy2},            q{SDL_PIXELFORMAT_YUY2}},             q{SDL_DefinePixelFourCC('Y', 'U', 'Y', '2')}},
		{{q{uyvy},            q{SDL_PIXELFORMAT_UYVY}},             q{SDL_DefinePixelFourCC('U', 'Y', 'V', 'Y')}},
		{{q{yvyu},            q{SDL_PIXELFORMAT_YVYU}},             q{SDL_DefinePixelFourCC('Y', 'V', 'Y', 'U')}},
		{{q{nv12},            q{SDL_PIXELFORMAT_NV12}},             q{SDL_DefinePixelFourCC('N', 'V', '1', '2')}},
		{{q{nv21},            q{SDL_PIXELFORMAT_NV21}},             q{SDL_DefinePixelFourCC('N', 'V', '2', '1')}},
		{{q{p010},            q{SDL_PIXELFORMAT_P010}},             q{SDL_DefinePixelFourCC('P', '0', '1', '0')}},
		{{q{externalOES},     q{SDL_PIXELFORMAT_EXTERNAL_OES}},     q{SDL_DefinePixelFourCC('O', 'E', 'S', ' ')}},
	];
	
	version(BigEndian){{
		EnumMember[] add = [
			{{q{rgba32},      q{SDL_PIXELFORMAT_RGBA32}},           q{rgba8888}},
			{{q{argb32},      q{SDL_PIXELFORMAT_ARGB32}},           q{argb8888}},
			{{q{bgra32},      q{SDL_PIXELFORMAT_BGRA32}},           q{bgra8888}},
			{{q{abgr32},      q{SDL_PIXELFORMAT_ABGR32}},           q{abgr8888}},
			{{q{rgbx32},      q{SDL_PIXELFORMAT_RGBX32}},           q{rgbx8888}},
			{{q{xrgb32},      q{SDL_PIXELFORMAT_XRGB32}},           q{xrgb8888}},
			{{q{bgrx32},      q{SDL_PIXELFORMAT_BGRX32}},           q{bgrx8888}},
			{{q{xbgr32},      q{SDL_PIXELFORMAT_XBGR32}},           q{xbgr8888}},
		];
		ret ~= add;
	}}else{{
		EnumMember[] add = [
			{{q{rgba32},      q{SDL_PIXELFORMAT_RGBA32}},           q{abgr8888}},
			{{q{argb32},      q{SDL_PIXELFORMAT_ARGB32}},           q{bgra8888}},
			{{q{bgra32},      q{SDL_PIXELFORMAT_BGRA32}},           q{argb8888}},
			{{q{abgr32},      q{SDL_PIXELFORMAT_ABGR32}},           q{rgba8888}},
			{{q{rgbx32},      q{SDL_PIXELFORMAT_RGBX32}},           q{xbgr8888}},
			{{q{xrgb32},      q{SDL_PIXELFORMAT_XRGB32}},           q{bgrx8888}},
			{{q{bgrx32},      q{SDL_PIXELFORMAT_BGRX32}},           q{xrgb8888}},
			{{q{xbgr32},      q{SDL_PIXELFORMAT_XBGR32}},           q{rgbx8888}},
		];
		ret ~= add;
	}}
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ColourType}, aliases: [q{SDL_ColorType}], members: (){
	EnumMember[] ret = [
		{{q{unknown},    q{SDL_COLOUR_TYPE_UNKNOWN}},    q{0},    aliases: {c: q{SDL_COLOR_TYPE_UNKNOWN}}},
		{{q{rgb},        q{SDL_COLOUR_TYPE_RGB}},        q{1},    aliases: {c: q{SDL_COLOR_TYPE_RGB}}},
		{{q{ycbcr},      q{SDL_COLOUR_TYPE_YCBCR}},      q{2},    aliases: {c: q{SDL_COLOR_TYPE_YCBCR}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ColourRange}, aliases: [q{SDL_ColorRange}], members: (){
	EnumMember[] ret = [
		{{q{unknown},    q{SDL_COLOUR_RANGE_UNKNOWN}},    q{0},    aliases: {c: q{SDL_COLOR_RANGE_UNKNOWN}}},
		{{q{limited},    q{SDL_COLOUR_RANGE_LIMITED}},    q{1},    aliases: {c: q{SDL_COLOR_RANGE_LIMITED}}},
		{{q{full},       q{SDL_COLOUR_RANGE_FULL}},       q{2},    aliases: {c: q{SDL_COLOR_RANGE_FULL}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ColourPrimaries}, aliases: [q{SDL_ColorPrimaries}], members: (){
	EnumMember[] ret = [
		{{q{unknown},        q{SDL_COLOUR_PRIMARIES_UNKNOWN}},         q{0},   aliases: {c: q{SDL_COLOR_PRIMARIES_UNKNOWN}}},
		{{q{bt709},          q{SDL_COLOUR_PRIMARIES_BT709}},           q{1},   aliases: {c: q{SDL_COLOR_PRIMARIES_BT709}}},
		{{q{unspecified},    q{SDL_COLOUR_PRIMARIES_UNSPECIFIED}},     q{2},   aliases: {c: q{SDL_COLOR_PRIMARIES_UNSPECIFIED}}},
		{{q{bt470M},         q{SDL_COLOUR_PRIMARIES_BT470M}},          q{4},   aliases: {c: q{SDL_COLOR_PRIMARIES_BT470M}}},
		{{q{bt470BG},        q{SDL_COLOUR_PRIMARIES_BT470BG}},         q{5},   aliases: {c: q{SDL_COLOR_PRIMARIES_BT470BG}}},
		{{q{bt601},          q{SDL_COLOUR_PRIMARIES_BT601}},           q{6},   aliases: {c: q{SDL_COLOR_PRIMARIES_BT601}}},
		{{q{smpte240},       q{SDL_COLOUR_PRIMARIES_SMPTE240}},        q{7},   aliases: {c: q{SDL_COLOR_PRIMARIES_SMPTE240}}},
		{{q{genericFilm},    q{SDL_COLOUR_PRIMARIES_GENERIC_FILM}},    q{8},   aliases: {c: q{SDL_COLOR_PRIMARIES_GENERIC_FILM}}},
		{{q{bt2020},         q{SDL_COLOUR_PRIMARIES_BT2020}},          q{9},   aliases: {c: q{SDL_COLOR_PRIMARIES_BT2020}}},
		{{q{xyz},            q{SDL_COLOUR_PRIMARIES_XYZ}},             q{10},  aliases: {c: q{SDL_COLOR_PRIMARIES_XYZ}}},
		{{q{smpte431},       q{SDL_COLOUR_PRIMARIES_SMPTE431}},        q{11},  aliases: {c: q{SDL_COLOR_PRIMARIES_SMPTE431}}},
		{{q{smpte432},       q{SDL_COLOUR_PRIMARIES_SMPTE432}},        q{12},  aliases: {c: q{SDL_COLOR_PRIMARIES_SMPTE432}}},
		{{q{ebu3213},        q{SDL_COLOUR_PRIMARIES_EBU3213}},         q{22},  aliases: {c: q{SDL_COLOR_PRIMARIES_EBU3213}}},
		{{q{custom},         q{SDL_COLOUR_PRIMARIES_CUSTOM}},          q{31},  aliases: {c: q{SDL_COLOR_PRIMARIES_CUSTOM}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_TransferCharacteristics}, members: (){
	EnumMember[] ret = [
		{{q{unknown},         q{SDL_TRANSFER_CHARACTERISTICS_UNKNOWN}},          q{0}},
		{{q{bt709},           q{SDL_TRANSFER_CHARACTERISTICS_BT709}},            q{1}},
		{{q{unspecified},     q{SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED}},      q{2}},
		{{q{gamma22},         q{SDL_TRANSFER_CHARACTERISTICS_GAMMA22}},          q{4}},
		{{q{gamma28},         q{SDL_TRANSFER_CHARACTERISTICS_GAMMA28}},          q{5}},
		{{q{bt601},           q{SDL_TRANSFER_CHARACTERISTICS_BT601}},            q{6}},
		{{q{smpte240},        q{SDL_TRANSFER_CHARACTERISTICS_SMPTE240}},         q{7}},
		{{q{linear},          q{SDL_TRANSFER_CHARACTERISTICS_LINEAR}},           q{8}},
		{{q{log100},          q{SDL_TRANSFER_CHARACTERISTICS_LOG100}},           q{9}},
		{{q{log100Sqrt10},    q{SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10}},    q{10}},
		{{q{iec61966},        q{SDL_TRANSFER_CHARACTERISTICS_IEC61966}},         q{11}},
		{{q{bt1361},          q{SDL_TRANSFER_CHARACTERISTICS_BT1361}},           q{12}},
		{{q{srgb},            q{SDL_TRANSFER_CHARACTERISTICS_SRGB}},             q{13}},
		{{q{bt202010Bit},     q{SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT}},     q{14}},
		{{q{bt202012Bit},     q{SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT}},     q{15}},
		{{q{pq},              q{SDL_TRANSFER_CHARACTERISTICS_PQ}},               q{16}},
		{{q{smpte428},        q{SDL_TRANSFER_CHARACTERISTICS_SMPTE428}},         q{17}},
		{{q{hlg},             q{SDL_TRANSFER_CHARACTERISTICS_HLG}},              q{18}},
		{{q{custom},          q{SDL_TRANSFER_CHARACTERISTICS_CUSTOM}},           q{31}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_MatrixCoefficients}, members: (){
	EnumMember[] ret = [
		{{q{identity},            q{SDL_MATRIX_COEFFICIENTS_IDENTITY}},              q{0}},
		{{q{bt709},               q{SDL_MATRIX_COEFFICIENTS_BT709}},                 q{1}},
		{{q{unspecified},         q{SDL_MATRIX_COEFFICIENTS_UNSPECIFIED}},           q{2}},
		{{q{fcc},                 q{SDL_MATRIX_COEFFICIENTS_FCC}},                   q{4}},
		{{q{bt470BG},             q{SDL_MATRIX_COEFFICIENTS_BT470BG}},               q{5}},
		{{q{bt601},               q{SDL_MATRIX_COEFFICIENTS_BT601}},                 q{6}},
		{{q{smpte240},            q{SDL_MATRIX_COEFFICIENTS_SMPTE240}},              q{7}},
		{{q{ycgco},               q{SDL_MATRIX_COEFFICIENTS_YCGCO}},                 q{8}},
		{{q{bt2020NCL},           q{SDL_MATRIX_COEFFICIENTS_BT2020_NCL}},            q{9}},
		{{q{bt2020CL},            q{SDL_MATRIX_COEFFICIENTS_BT2020_CL}},             q{10}},
		{{q{smpte2085},           q{SDL_MATRIX_COEFFICIENTS_SMPTE2085}},             q{11}},
		{{q{chromaDerivedNCL},    q{SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL}},    q{12}},
		{{q{chromaDerivedCL},     q{SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL}},     q{13}},
		{{q{ictcp},               q{SDL_MATRIX_COEFFICIENTS_ICTCP}},                 q{14}},
		{{q{custom},              q{SDL_MATRIX_COEFFICIENTS_CUSTOM}},                q{31}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ChromaLocation}, members: (){
	EnumMember[] ret = [
		{{q{none},       q{SDL_CHROMA_LOCATION_NONE}},       q{0}},
		{{q{left},       q{SDL_CHROMA_LOCATION_LEFT}},       q{1}},
		{{q{centre},     q{SDL_CHROMA_LOCATION_CENTRE}},     q{2}, aliases: [{q{center}, q{SDL_CHROMA_LOCATION_CENTER}}]},
		{{q{topleft},    q{SDL_CHROMA_LOCATION_TOPLEFT}},    q{3}},
	];
	return ret;
}()));

pragma(inline,true) nothrow @nogc pure @safe{
	SDL_ColourSpace SDL_DefineColourSpace(
		SDL_ColourType type, SDL_ColourRange range,
		SDL_ColourPrimaries primaries, SDL_TransferCharacteristics transfer,
		SDL_MatrixCoefficients matrix, SDL_ChromaLocation chroma,
	) => cast(SDL_ColourSpace)(
		(cast(uint)type      << 28) | (cast(uint)range    << 24) | (cast(uint)chroma << 20) |
		(cast(uint)primaries << 10) | (cast(uint)transfer <<  5) | (cast(uint)matrix <<  0)
	);
	alias SDL_DEFINE_COLORSPACE  = SDL_DefineColourSpace;
	
	SDL_ColourType SDL_ColourSpaceType(SDL_ColourSpace x) =>
		cast(SDL_ColourType)((x >> 28) & 0x0F);
	SDL_ColourRange SDL_ColourSpaceRange(SDL_ColourSpace x) =>
		cast(SDL_ColourRange)((x >> 24) & 0x0F);
	SDL_ChromaLocation SDL_ColourSpaceChroma(SDL_ColourSpace x) =>
		cast(SDL_ChromaLocation)((x >> 20) & 0x0F);
	SDL_ColourPrimaries SDL_ColourSpacePrimaries(SDL_ColourSpace x) =>
		cast(SDL_ColourPrimaries)((x >> 10) & 0x1F);
	SDL_TransferCharacteristics SDL_ColourSpaceTransfer(SDL_ColourSpace x) =>
		cast(SDL_TransferCharacteristics)((x >> 5) & 0x1F);
	SDL_MatrixCoefficients SDL_ColourSpaceMatrix(SDL_ColourSpace x) =>
		cast(SDL_MatrixCoefficients)(x & 0x1F);
	alias SDL_COLORSPACETYPE = SDL_ColourSpaceType;
	alias SDL_COLORSPACERANGE = SDL_ColourSpaceRange;
	alias SDL_COLORSPACECHROMA = SDL_ColourSpaceChroma;
	alias SDL_COLORSPACEPRIMARIES = SDL_ColourSpacePrimaries;
	alias SDL_COLORSPACETRANSFER = SDL_ColourSpaceTransfer;
	alias SDL_COLORSPACEMATRIX = SDL_ColourSpaceMatrix;
	
	bool SDL_IsColourSpaceMatrixBT601(SDL_ColourSpace x) =>
		SDL_ColourSpaceMatrix(x) == SDL_MatrixCoefficients.bt601 || SDL_ColourSpaceMatrix(X) == SDL_MatrixCoefficients.bt470BG;
	bool SDL_IsColourSpaceMatrixBT709(SDL_ColourSpace x) =>
		SDL_ColourSpaceMatrix(x) == SDL_MatrixCoefficients.bt709;
	bool SDL_IsColourSpaceMatrixBT2020NCL(SDL_ColourSpace x) =>
		SDL_ColourSpaceMatrix(x) == SDL_MatrixCoefficients.bt2020NCL;
	bool SDL_IsColourSpaceLimitedRange(SDL_ColourSpace x) =>
		SDL_ColourSpaceRange(x) != SDL_ColourRange.full;
	bool SDL_IsColourSpaceFullRange(SDL_ColourSpace x) =>
		SDL_ColourSpaceRange(x) == SDL_ColourRange.full;
	alias SDL_ISCOLORSPACE_MATRIX_BT601 = SDL_IsColourSpaceMatrixBT601;
	alias SDL_ISCOLORSPACE_MATRIX_BT709 = SDL_IsColourSpaceMatrixBT709;
	alias SDL_ISCOLORSPACE_MATRIX_BT2020_NCL = SDL_IsColourSpaceMatrixBT2020NCL;
	alias SDL_ISCOLORSPACE_LIMITED_RANGE = SDL_IsColourSpaceLimitedRange;
	alias SDL_ISCOLORSPACE_FULL_RANGE = SDL_IsColourSpaceFullRange;
}

mixin(makeEnumBind(q{SDL_ColourSpace}, aliases: [q{SDL_Colorspace}], members: (){
	EnumMember[] ret = [
		{{q{unknown},          q{SDL_COLOURSPACE_UNKNOWN}},          aliases: [{c: q{SDL_COLORSPACE_UNKNOWN}}]},
		{{q{srgb},             q{SDL_COLOURSPACE_SRGB}},             q{SDL_DefineColourSpace(SDL_ColourType.rgb,    SDL_ColourRange.full,     SDL_ColourPrimaries.bt709,   SDL_TransferCharacteristics.srgb,    SDL_MatrixCoefficients.identity,   SDL_ChromaLocation.none)}, aliases: [{c: q{SDL_COLORSPACE_SRGB}}]},
		
		{{q{srgbLinear},       q{SDL_COLOURSPACE_SRGB_LINEAR}},      q{SDL_DefineColourSpace(SDL_ColourType.rgb,    SDL_ColourRange.full,     SDL_ColourPrimaries.bt709,   SDL_TransferCharacteristics.linear,  SDL_MatrixCoefficients.identity,   SDL_ChromaLocation.none)}, aliases: [{c: q{SDL_COLORSPACE_SRGB_LINEAR}}]},
		
		{{q{hdr10},            q{SDL_COLOURSPACE_HDR10}},            q{SDL_DefineColourSpace(SDL_ColourType.rgb,    SDL_ColourRange.full,     SDL_ColourPrimaries.bt2020,  SDL_TransferCharacteristics.pq,      SDL_MatrixCoefficients.identity,   SDL_ChromaLocation.none)}, aliases: [{c: q{SDL_COLORSPACE_HDR10}}]},
		{{q{jpeg},             q{SDL_COLOURSPACE_JPEG}},             q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.full,     SDL_ColourPrimaries.bt709,   SDL_TransferCharacteristics.bt601,   SDL_MatrixCoefficients.bt601,      SDL_ChromaLocation.none)}, aliases: [{c: q{SDL_COLORSPACE_JPEG}}]},
		{{q{bt601Limited},     q{SDL_COLOURSPACE_BT601_LIMITED}},    q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.limited,  SDL_ColourPrimaries.bt601,   SDL_TransferCharacteristics.bt601,   SDL_MatrixCoefficients.bt601,      SDL_ChromaLocation.left)}, aliases: [{c: q{SDL_COLORSPACE_BT601_LIMITED}}]},
		{{q{bt601Full},        q{SDL_COLOURSPACE_BT601_FULL}},       q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.full,     SDL_ColourPrimaries.bt601,   SDL_TransferCharacteristics.bt601,   SDL_MatrixCoefficients.bt601,      SDL_ChromaLocation.left)}, aliases: [{c: q{SDL_COLORSPACE_BT601_FULL}}]},
		{{q{bt709Limited},     q{SDL_COLOURSPACE_BT709_LIMITED}},    q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.limited,  SDL_ColourPrimaries.bt709,   SDL_TransferCharacteristics.bt709,   SDL_MatrixCoefficients.bt709,      SDL_ChromaLocation.left)}, aliases: [{c: q{SDL_COLORSPACE_BT709_LIMITED}}]},
		{{q{bt709Full},        q{SDL_COLOURSPACE_BT709_FULL}},       q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.full,     SDL_ColourPrimaries.bt709,   SDL_TransferCharacteristics.bt709,   SDL_MatrixCoefficients.bt709,      SDL_ChromaLocation.left)}, aliases: [{c: q{SDL_COLORSPACE_BT709_FULL}}]},
		{{q{bt2020Limited},    q{SDL_COLOURSPACE_BT2020_LIMITED}},   q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.limited,  SDL_ColourPrimaries.bt2020,  SDL_TransferCharacteristics.pq,      SDL_MatrixCoefficients.bt2020NCL,  SDL_ChromaLocation.left)}, aliases: [{c: q{SDL_COLORSPACE_BT2020_LIMITED}}]},
		{{q{bt2020Full},       q{SDL_COLOURSPACE_BT2020_FULL}},      q{SDL_DefineColourSpace(SDL_ColourType.ycbcr,  SDL_ColourRange.full,     SDL_ColourPrimaries.bt2020,  SDL_TransferCharacteristics.pq,      SDL_MatrixCoefficients.bt2020NCL,  SDL_ChromaLocation.left)}, aliases: [{c: q{SDL_COLORSPACE_BT2020_FULL}}]},
		
		{{q{rgbDefault},       q{SDL_COLOURSPACE_RGB_DEFAULT}},      q{srgb}, aliases: [{c: q{SDL_COLORSPACE_RGB_DEFAULT}}]},
		
		{{q{yuvDefault},       q{SDL_COLOURSPACE_YUV_DEFAULT}},      q{jpeg}, aliases: [{c: q{SDL_COLORSPACE_YUV_DEFAULT}}]},
	];
	return ret;
}()));

struct SDL_Colour{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a;
}
alias SDL_Color = SDL_Colour;

struct SDL_FColour{
	float r;
	float g;
	float b;
	float a;
}
alias SDL_FColor = SDL_FColour;

struct SDL_Palette{
	int nColours;
	alias ncolors = nColours;
	SDL_Colour* colours;
	alias colors = colours;
	uint version_;
	int refCount;
	alias refcount = refCount;
}

struct SDL_PixelFormat{
	SDL_PixelFormatEnum format;
	SDL_Palette* palette;
	ubyte bitsPerPixel;
	alias bits_per_pixel = bitsPerPixel;
	ubyte bytesPerPixel;
	alias bytes_per_pixel = bytesPerPixel;
	ubyte[2] padding;
	uint rMask;
	uint gMask;
	uint bMask;
	uint aMask;
	alias Rmask = rMask;
	alias Gmask = gMask;
	alias Bmask = bMask;
	alias Amask = aMask;
	ubyte rLoss;
	ubyte gLoss;
	ubyte bLoss;
	ubyte aLoss;
	alias Rloss = rLoss;
	alias Gloss = gLoss;
	alias Bloss = bLoss;
	alias Aloss = aLoss;
	ubyte rShift;
	ubyte gShift;
	ubyte bShift;
	ubyte aShift;
	alias Rshift = rShift;
	alias Gshift = gShift;
	alias Bshift = bShift;
	alias Ashift = aShift;
	int refCount;
	alias refcount = refCount;
	SDL_PixelFormat* next;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{const(char)*}, q{SDL_GetPixelFormatName}, q{SDL_PixelFormatEnum format}},
		{q{SDL_Bool}, q{SDL_GetMasksForPixelFormatEnum}, q{SDL_PixelFormatEnum format, int* bpp, uint* rMask, uint* gMask, uint* bMask, uint* aMask}},
		{q{SDL_PixelFormatEnum}, q{SDL_GetPixelFormatEnumForMasks}, q{int bpp, uint rMask, uint gMask, uint bMask, uint aMask}},
		{q{SDL_PixelFormat*}, q{SDL_CreatePixelFormat}, q{SDL_PixelFormatEnum pixelFormat}},
		{q{void}, q{SDL_DestroyPixelFormat}, q{SDL_PixelFormat* format}},
		{q{SDL_Palette*}, q{SDL_CreatePalette}, q{int nColours}},
		{q{int}, q{SDL_SetPixelFormatPalette}, q{SDL_PixelFormat* format, SDL_Palette* palette}},
		{q{int}, q{SDL_SetPaletteColors}, q{SDL_Palette* palette, const(SDL_Colour)* colours, int firstColour, int nColours}},
		{q{void}, q{SDL_DestroyPalette}, q{SDL_Palette* palette}},
		{q{uint}, q{SDL_MapRGB}, q{const(SDL_PixelFormat)* format, ubyte r, ubyte g, ubyte b}},
		{q{uint}, q{SDL_MapRGBA}, q{const(SDL_PixelFormat)* format, ubyte r, ubyte g, ubyte b, ubyte a}},
		{q{void}, q{SDL_GetRGB}, q{Uint32 pixel, const(SDL_PixelFormat)* format, ubyte* r, ubyte* g, ubyte* b}},
		{q{void}, q{SDL_GetRGBA}, q{Uint32 pixel, const(SDL_PixelFormat)* format, ubyte* r, ubyte* g, ubyte* b, ubyte* a}},
	];
	return ret;
}()));
