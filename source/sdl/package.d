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
	sdl.assert_,
	sdl.atomic,
	sdl.audio,
	sdl.bits,
	sdl.blendmode,
	sdl.camera,
	sdl.clipboard,
	sdl.cpuinfo,
	sdl.dialogue,
	sdl.endian,
	sdl.error,
	sdl.events,
	sdl.filesystem,
	sdl.gamepad,
	sdl.gpu,
	sdl.gesture,
	sdl.guid,
	sdl.haptic,
	sdl.hidapi,
	sdl.hints,
	sdl.init,
	sdl.iostream,
	sdl.joystick,
	sdl.keyboard,
	sdl.keycode,
	sdl.loadso,
	sdl.locale,
	sdl.log,
	sdl.messagebox,
	sdl.main,
	sdl.metal,
	sdl.misc,
	sdl.mouse,
	sdl.mutex,
	sdl.pen,
	sdl.pixels,
	sdl.platform,
	sdl.power,
	sdl.process,
	sdl.properties,
	sdl.rect,
	sdl.render,
	sdl.scancode,
	sdl.sensor,
	sdl.stdinc,
	sdl.storage,
	sdl.surface,
	sdl.system,
	sdl.thread,
	sdl.time,
	sdl.timer,
	sdl.touch,
	sdl.version_,
	sdl.video,
	sdl.vulkan;

//————— prefix-less camelCased inline/macro function aliases —————
//sdl.audio
alias defineAudioFormat = SDL_DEFINE_AUDIO_FORMAT;
//sdl.keycode
alias scancodeToKeyCode = SDL_SCANCODE_TO_KEYCODE;
alias scancodeToKeycode = SDL_SCANCODE_TO_KEYCODE;
//sdl.mouse
alias buttonMask = SDL_BUTTON_MASK;
//sdl.pixels

//sdl.stdinc
alias fourCC = SDL_FOURCC;
//sdl.surface
alias mustLock = SDL_MUSTLOCK;
//sdl.timer
alias secondsToNS = SDL_SECONDS_TO_NS;
alias nsToSeconds = SDL_NS_TO_SECONDS;
alias msToNS = SDL_MS_TO_NS;
alias nsToMS = SDL_NS_TO_MS;
alias usToNS = SDL_US_TO_NS;
alias nsToUS = SDL_NS_TO_US;

static if(dStyleEnums){
	//————— prefix-less camelCased macro aliases —————
	//sdl.pixels
	alias alphaOpaque = SDL_ALPHA_OPAQUE;
	alias alphaOpaqueFloat = SDL_ALPHA_OPAQUE_FLOAT;
	alias alphaTransparent = SDL_ALPHA_TRANSPARENT;
	alias alphaTransparentFloat = SDL_ALPHA_TRANSPARENT_FLOAT;
	//sdl.sensor
	alias standardGravity = SDL_STANDARD_GRAVITY;
	//sdl.timer
	alias msPerSecond = SDL_MS_PER_SECOND;
	alias usPerSecond = SDL_US_PER_SECOND;
	alias nsPerMS = SDL_NS_PER_MS;
	alias nsPerUS = SDL_NS_PER_US;
}

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDL", makeLibPaths(["SDL3"]), [
	"sdl.assert_",
	"sdl.atomic",
	"sdl.audio",
	"sdl.bits",
	"sdl.blendmode",
	"sdl.camera",
	"sdl.clipboard",
	"sdl.cpuinfo",
	"sdl.dialogue",
	"sdl.endian",
	"sdl.error",
	"sdl.events",
	"sdl.filesystem",
	"sdl.gamepad",
	"sdl.gpu",
	"sdl.guid",
	"sdl.haptic",
	"sdl.hidapi",
	"sdl.hints",
	"sdl.init",
	"sdl.iostream",
	"sdl.joystick",
	"sdl.keyboard",
	"sdl.keycode",
	"sdl.loadso",
	"sdl.locale",
	"sdl.log",
	"sdl.main",
	"sdl.messagebox",
	"sdl.metal",
	"sdl.misc",
	"sdl.mouse",
	"sdl.mutex",
	"sdl.pen",
	"sdl.pixels",
	"sdl.platform",
	"sdl.power",
	"sdl.process",
	"sdl.properties",
	"sdl.rect",
	"sdl.render",
	"sdl.scancode",
	"sdl.sensor",
	"sdl.stdinc",
	"sdl.storage",
	"sdl.surface",
	"sdl.system",
	"sdl.thread",
	"sdl.time",
	"sdl.timer",
	"sdl.touch",
	"sdl.version_",
	"sdl.video",
	"sdl.vulkan",
]));
