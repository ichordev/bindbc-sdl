/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.minimal;

import bindbc.sdl.config;

version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_DISABLED;

version = SDL_HAPTIC_DISABLED;

static if(sdlSupport >= SDLSupport.v2_0_18){
	version = SDL_HIDAPI_DISABLED;
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_SENSOR_DISABLED;
}

version = SDL_LOADSO_DISABLED;

version = SDL_THREADS_DISABLED;

version = SDL_TIMERS_DISABLED;

version = SDL_VIDEO_DRIVER_DUMMY;

static if(sdlSupport >= SDLSupport.v2_0_1){
	version = SDL_FILESYSTEM_DUMMY;
}
