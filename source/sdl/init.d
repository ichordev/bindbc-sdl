/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.init;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.events;

alias SDL_InitFlags_ = uint;
mixin(makeEnumBind(q{SDL_InitFlags}, q{SDL_InitFlags_}, aliases: [q{SDL_InitFlag}], members: (){
	EnumMember[] ret = [
		{{q{audio},     q{SDL_INIT_AUDIO}},     q{0x0000_0010U}},
		{{q{video},     q{SDL_INIT_VIDEO}},     q{0x0000_0020U}},
		{{q{joystick},  q{SDL_INIT_JOYSTICK}},  q{0x0000_0200U}},
		{{q{haptic},    q{SDL_INIT_HAPTIC}},    q{0x0000_1000U}},
		{{q{gamepad},   q{SDL_INIT_GAMEPAD}},   q{0x0000_2000U}},
		{{q{events},    q{SDL_INIT_EVENTS}},    q{0x0000_4000U}},
		{{q{sensor},    q{SDL_INIT_SENSOR}},    q{0x0000_8000U}},
		{{q{camera},    q{SDL_INIT_CAMERA}},    q{0x0001_0000U}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_AppResult}, aliases: [q{SDL_App}], members: (){
	EnumMember[] ret = [
		{{q{continue_},  q{SDL_APP_CONTINUE}}},
		{{q{success},    q{SDL_APP_SUCCESS}}},
		{{q{failure},    q{SDL_APP_FAILURE}}},
	];
	return ret;
}()));

extern(C) nothrow{
	alias SDL_AppInit_func = SDL_AppResult function(void** appState, int argC, char** argV);
	alias SDL_AppIterate_func = SDL_AppResult function(void* appState);
	alias SDL_AppEvent_func = SDL_AppResult function(void* appState, SDL_Event* event);
	alias SDL_AppQuit_func = void function(void* appState, SDL_AppResult result);
}

enum{
	SDL_PROP_APP_METADATA_NAME_STRING        = "SDL.app.metadata.name",
	SDL_PROP_APP_METADATA_VERSION_STRING     = "SDL.app.metadata.version",
	SDL_PROP_APP_METADATA_IDENTIFIER_STRING  = "SDL.app.metadata.identifier",
	SDL_PROP_APP_METADATA_CREATOR_STRING     = "SDL.app.metadata.creator",
	SDL_PROP_APP_METADATA_COPYRIGHT_STRING   = "SDL.app.metadata.copyright",
	SDL_PROP_APP_METADATA_URL_STRING         = "SDL.app.metadata.url",
	SDL_PROP_APP_METADATA_TYPE_STRING        = "SDL.app.metadata.type",
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_Init}, q{SDL_InitFlags_ flags}},
		{q{bool}, q{SDL_InitSubSystem}, q{SDL_InitFlags_ flags}},
		{q{void}, q{SDL_QuitSubSystem}, q{SDL_InitFlags_ flags}},
		{q{SDL_InitFlags}, q{SDL_WasInit}, q{SDL_InitFlags_ flags}},
		{q{void}, q{SDL_Quit}, q{}},
		{q{bool}, q{SDL_SetAppMetadata}, q{const(char)* appName, const(char)* appVersion, const(char)* appIdentifier}},
		{q{bool}, q{SDL_SetAppMetadataProperty}, q{const(char)* name, const(char)* value}},
		{q{const(char)*}, q{SDL_GetAppMetadataProperty}, q{const(char)* name}},
	];
	return ret;
}()));
