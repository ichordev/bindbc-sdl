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
//	sdl.atomic,
	sdl.audio,
	sdl.bits,
//	sdl.blendmode,
//	sdl.clipboard,
	sdl.cpuinfo,
//	sdl.endian,
//	sdl.error,
//	sdl.events,
//	sdl.filesystem,
//	sdl.gamecontroller,
//	sdl.gesture,
//	sdl.guid,
//	sdl.hidapi,
//	sdl.haptic,
//	sdl.hints,
	sdl.iostream,
//	sdl.joystick,
//	sdl.keyboard,
	sdl.keycode,
//	sdl.loadso,
//	sdl.locale,
//	sdl.log,
//	sdl.messagebox,
//	sdl.metal,
//	sdl.misc,
//	sdl.mouse,
//	sdl.mutex,
//	sdl.pixels,
//	sdl.platform,
//	sdl.power,
	sdl.properties,
//	sdl.rect,
//	sdl.render,
//	sdl.rwops,
	sdl.scancode,
//	sdl.sensor,
//	sdl.shape,
	sdl.stdinc,
//	sdl.surface,
//	sdl.system,
//	sdl.syswm,
//	sdl.thread,
//	sdl.timer,
//	sdl.touch,
	sdl.version_;
//	sdl.video,
//	sdl.vulkan;

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDL", makeLibPaths(["SDL3"]), [
	"sdl.assert_",         /*"sdl.atomic",*/   "sdl.audio",
	//"sdl.blendmode",
	//"sdl.clipboard",
	"sdl.cpuinfo",
	//"sdl.error",             "sdl.events",     "sdl.filesystem",
	//"sdl.gamecontroller",    "sdl.gesture",    "sdl.guid",
	//"sdl.haptic",            "sdl.hidapi",     "sdl.hints",
	"sdl.iostream",          //"sdl.joystick",   "sdl.keyboard",
	//"sdl.loadso",            "sdl.locale",     "sdl.log",
	//"sdl.messagebox", "sdl.metal", "sdl.misc",
	//"sdl.mouse", "sdl.mutex", "sdl.pixels",
	//"sdl.platform", "sdl.power", "sdl.properties",
	//"sdl.rect", "sdl.render", "sdl.rwops",
	/+"sdl.sensor", "sdl.shape",+/ "sdl.stdinc",
	//"sdl.surface",
	//"sdl.system",
	//"sdl.syswm",
	//"sdl.thread",
	//"sdl.timer",
	//"sdl.touch",
	"sdl.version_",
	//"sdl.video",
	//"sdl.vulkan",
]));
