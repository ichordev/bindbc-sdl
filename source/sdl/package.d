/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

public import
	sdl.assert_,     sdl.atomic,      sdl.audio,
	sdl.bits,        sdl.blendmode,   sdl.camera,
	sdl.clipboard,   sdl.cpuinfo,     sdl.dialogue,
	sdl.endian,      sdl.error,       sdl.events,
	sdl.filesystem,  sdl.gamepad,     sdl.gpu,
	sdl.gesture,     sdl.guid,        sdl.haptic,
	sdl.hidapi,      sdl.hints,       sdl.init,
	sdl.iostream,    sdl.joystick,    sdl.keyboard,
	sdl.keycode,     sdl.loadso,      sdl.locale,
	sdl.log,         sdl.messagebox,  sdl.main,
	sdl.metal,       sdl.misc,        sdl.mouse,
	sdl.mutex,       sdl.pen,         sdl.pixels,
	sdl.platform,    sdl.power,       sdl.process,
	sdl.properties,  sdl.rect,        sdl.render,
	sdl.scancode,    sdl.sensor,      sdl.stdinc,
	sdl.storage,     sdl.surface,     sdl.system,
	sdl.thread,      sdl.time,        sdl.timer,
	sdl.touch,       sdl.version_,    sdl.video,
	sdl.vulkan;

//————— prefix-less camelCased inline/macro function aliases —————
//sdl.audio
alias defineAudioFormat = SDL_DEFINE_AUDIO_FORMAT;
alias audioBitSize = SDL_AUDIO_BITSIZE;
alias audioByteSize = SDL_AUDIO_BYTESIZE;
alias audioIsFloat = SDL_AUDIO_ISFLOAT;
alias audioIsBigEndian = SDL_AUDIO_ISBIGENDIAN;
alias audioIsSigned = SDL_AUDIO_ISSIGNED;
alias audioIsInt = SDL_AUDIO_ISINT;
alias audioIsLittleEndian = SDL_AUDIO_ISLITTLEENDIAN;
alias audioIsUnsigned = SDL_AUDIO_ISUNSIGNED;
alias audioFrameSize = SDL_AUDIO_FRAMESIZE;
//sdl.keycode
alias scancodeToKeyCode = SDL_SCANCODE_TO_KEYCODE;
alias scancodeToKeycode = SDL_SCANCODE_TO_KEYCODE;
//sdl.mouse
alias buttonMask = SDL_BUTTON_MASK;
//sdl.pixels
alias definePixelFourCC = SDL_DEFINE_PIXELFOURCC;
alias definePixelFormat = SDL_DEFINE_PIXELFORMAT;
alias pixelFlag = SDL_PIXELFLAG;
alias pixelType = SDL_PIXELTYPE;
alias pixelOrder = SDL_PIXELORDER;
alias pixelLayout = SDL_PIXELLAYOUT;
alias bitsPerPixel = SDL_BITSPERPIXEL;
alias bytesPerPixel = SDL_BYTESPERPIXEL;
alias isPixelFormatIndexed = SDL_ISPIXELFORMAT_INDEXED;
alias isPixelFormatPacked = SDL_ISPIXELFORMAT_PACKED;
alias isPixelFormatArray = SDL_ISPIXELFORMAT_ARRAY;
alias isPixelFormatAlpha = SDL_ISPIXELFORMAT_ALPHA;
alias isPixelFormat10Bit = SDL_ISPIXELFORMAT_10BIT;
alias isPixelFormatFloat = SDL_ISPIXELFORMAT_FLOAT;
alias isPixelFormatFourCC = SDL_ISPIXELFORMAT_FOURCC;
alias defineColourspace = SDL_DEFINE_COLOURSPACE;
alias defineColorspace  = SDL_DEFINE_COLOURSPACE;
alias colourspaceType = SDL_COLOURSPACETYPE;
alias colorspaceType  = SDL_COLOURSPACETYPE;
alias colourspaceRange = SDL_COLOURSPACERANGE;
alias colorspaceRange  = SDL_COLOURSPACERANGE;
alias colourspaceChroma = SDL_COLOURSPACECHROMA;
alias colorspaceChroma  = SDL_COLOURSPACECHROMA;
alias colourspacePrimaries = SDL_COLOURSPACEPRIMARIES;
alias colorspacePrimaries  = SDL_COLOURSPACEPRIMARIES;
alias colourspaceTransfer = SDL_COLOURSPACETRANSFER;
alias colorspaceTransfer  = SDL_COLOURSPACETRANSFER;
alias colourspaceMatrix = SDL_COLOURSPACEMATRIX;
alias colorspaceMatrix  = SDL_COLOURSPACEMATRIX;
alias isColourspaceMatrixBT601 = SDL_ISCOLOURSPACE_MATRIX_BT601;
alias isColorspaceMatrixBT601  = SDL_ISCOLOURSPACE_MATRIX_BT601;
alias isColourspaceMatrixBT709 = SDL_ISCOLOURSPACE_MATRIX_BT709;
alias isColorspaceMatrixBT709  = SDL_ISCOLOURSPACE_MATRIX_BT709;
alias isColourspaceMatrixBT2020NCL = SDL_ISCOLOURSPACE_MATRIX_BT2020_NCL;
alias isColorspaceMatrixBT2020NCL  = SDL_ISCOLOURSPACE_MATRIX_BT2020_NCL;
alias isColourspaceLimitedRange = SDL_ISCOLOURSPACE_LIMITED_RANGE;
alias isColorspaceLimitedRange  = SDL_ISCOLOURSPACE_LIMITED_RANGE;
alias isColourspaceFullRange = SDL_ISCOLOURSPACE_FULL_RANGE;
alias isColorspaceFullRange  = SDL_ISCOLOURSPACE_FULL_RANGE;
//sdl.stdinc
alias fourCC = SDL_FOURCC;
alias initInterface = SDL_INIT_INTERFACE;
//sdl.surface
alias mustLock = SDL_MUSTLOCK;
//sdl.timer
alias secondsToNS = SDL_SECONDS_TO_NS;
alias nsToSeconds = SDL_NS_TO_SECONDS;
alias msToNS = SDL_MS_TO_NS;
alias nsToMS = SDL_NS_TO_MS;
alias usToNS = SDL_US_TO_NS;
alias nsToUS = SDL_NS_TO_US;
//sdl.version_
alias versionNum = SDL_VERSIONNUM;
alias versionNumMajor = SDL_VERSIONNUM_MAJOR;
alias versionNumMinor = SDL_VERSIONNUM_MINOR;
alias versionNumMicro = SDL_VERSIONNUM_MICRO;
alias versionAtleast = SDL_VERSION_ATLEAST;
//sdl.video
alias windowPosUndefinedDisplay = SDL_WINDOWPOS_UNDEFINED_DISPLAY;
alias windowPosIsUndefined = SDL_WINDOWPOS_ISUNDEFINED;
alias windowPosCentredDisplay  = SDL_WINDOWPOS_CENTRED_DISPLAY;
alias windowPosCenteredDisplay = SDL_WINDOWPOS_CENTRED_DISPLAY;
alias windowPosIsCentred  = SDL_WINDOWPOS_ISCENTRED;
alias windowPosIsCentered = SDL_WINDOWPOS_ISCENTRED;

static if(dStyleEnums){
	//————— prefix-less camelCased macro aliases —————
	//sdl.audio
	alias audioMaskBitSize = SDL_AUDIO_MASK_BITSIZE;
	alias audioMaskFloat = SDL_AUDIO_MASK_FLOAT;
	alias audioMaskBigEndian = SDL_AUDIO_MASK_BIG_ENDIAN;
	alias audioMaskSigned = SDL_AUDIO_MASK_SIGNED;
	//sdl.cpuinfo
	alias cacheLineSize = SDL_CACHELINE_SIZE;
	//sdl.endian
	alias lilEndian = SDL_LIL_ENDIAN;
	alias bigEndian = SDL_BIG_ENDIAN;
	alias byteOrder = SDL_BYTEORDER;
	alias floatWordOrder = SDL_FLOATWORDORDER;
	//sdl.pixels
	alias alphaOpaque = SDL_ALPHA_OPAQUE;
	alias alphaOpaqueFloat = SDL_ALPHA_OPAQUE_FLOAT;
	alias alphaTransparent = SDL_ALPHA_TRANSPARENT;
	alias alphaTransparentFloat = SDL_ALPHA_TRANSPARENT_FLOAT;
	//sdl.render
	alias softwareRenderer = SDL_SOFTWARE_RENDERER;
	//sdl.sensor
	alias standardGravity = SDL_STANDARD_GRAVITY;
	//sdl.stdinc
	alias invalidUnicodeCodepoint = SDL_INVALID_UNICODE_CODEPOINT;
	alias piD = SDL_PI_D;
	alias piF = SDL_PI_F;
	//sdl.timer
	alias msPerSecond = SDL_MS_PER_SECOND;
	alias usPerSecond = SDL_US_PER_SECOND;
	alias nsPerSecond = SDL_NS_PER_SECOND;
	alias nsPerMS = SDL_NS_PER_MS;
	alias nsPerUS = SDL_NS_PER_US;
	//sdl.touch
	alias touchMouseID = SDL_TOUCH_MOUSEID;
	alias mouseTouchID = SDL_MOUSE_TOUCHID;
	//sdl.video
	alias windowPosUndefinedMask = SDL_WINDOWPOS_UNDEFINED_MASK;
	alias windowPosUndefined = SDL_WINDOWPOS_UNDEFINED;
	alias windowPosCentredMask  = SDL_WINDOWPOS_CENTRED_MASK;
	alias windowPosCenteredMask = SDL_WINDOWPOS_CENTRED_MASK;
	alias windowPosCentred  = SDL_WINDOWPOS_CENTRED;
	alias windowPosCentered = SDL_WINDOWPOS_CENTRED;
}

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDL", makeLibPaths(["SDL3"]), [
	"sdl.assert_",     "sdl.atomic",      "sdl.audio",
	"sdl.bits",        "sdl.blendmode",   "sdl.camera",
	"sdl.clipboard",   "sdl.cpuinfo",     "sdl.dialogue",
	"sdl.endian",      "sdl.error",       "sdl.events",
	"sdl.filesystem",  "sdl.gamepad",     "sdl.gpu",
	"sdl.guid",        "sdl.haptic",      "sdl.hidapi",
	"sdl.hints",       "sdl.init",        "sdl.iostream",
	"sdl.joystick",    "sdl.keyboard",    "sdl.keycode",
	"sdl.loadso",      "sdl.locale",      "sdl.log",
	"sdl.main",        "sdl.messagebox",  "sdl.metal",
	"sdl.misc",        "sdl.mouse",       "sdl.mutex",
	"sdl.pen",         "sdl.pixels",      "sdl.platform",
	"sdl.power",       "sdl.process",     "sdl.properties",
	"sdl.rect",        "sdl.render",      "sdl.scancode",
	"sdl.sensor",      "sdl.stdinc",      "sdl.storage",
	"sdl.surface",     "sdl.system",      "sdl.thread",
	"sdl.time",        "sdl.timer",       "sdl.touch",
	"sdl.version_",    "sdl.video",       "sdl.vulkan",
]));
