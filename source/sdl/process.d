/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.process;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.iostream: SDL_IOStream;
import sdl.properties: SDL_PropertiesID;

struct SDL_Process;

mixin(makeEnumBind(q{SDL_ProcessIO}, aliases: [q{SDL_ProcessStdIO}], members: (){
	EnumMember[] ret = [
		{{q{inherited},    q{SDL_PROCESS_STDIO_INHERITED}}},
		{{q{null_},        q{SDL_PROCESS_STDIO_NULL}}},
		{{q{app},          q{SDL_PROCESS_STDIO_APP}}},
		{{q{redirect},     q{SDL_PROCESS_STDIO_REDIRECT}}},
	];
	return ret;
}()));

enum{
	SDL_PROP_PROCESS_CREATE_ARGS_POINTER                = "SDL.process.create.args",
	SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER         = "SDL.process.create.environment",
	SDL_PROP_PROCESS_CREATE_STDIN_NUMBER                = "SDL.process.create.stdin_option",
	SDL_PROP_PROCESS_CREATE_STDIN_POINTER               = "SDL.process.create.stdin_source",
	SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER               = "SDL.process.create.stdout_option",
	SDL_PROP_PROCESS_CREATE_STDOUT_POINTER              = "SDL.process.create.stdout_source",
	SDL_PROP_PROCESS_CREATE_STDERR_NUMBER               = "SDL.process.create.stderr_option",
	SDL_PROP_PROCESS_CREATE_STDERR_POINTER              = "SDL.process.create.stderr_source",
	SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN    = "SDL.process.create.stderr_to_stdout",
	SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN          = "SDL.process.create.background",
}

enum{
	SDL_PROP_PROCESS_PID_NUMBER          = "SDL.process.pid",
	SDL_PROP_PROCESS_STDIN_POINTER       = "SDL.process.stdin",
	SDL_PROP_PROCESS_STDOUT_POINTER      = "SDL.process.stdout",
	SDL_PROP_PROCESS_STDERR_POINTER      = "SDL.process.stderr",
	SDL_PROP_PROCESS_BACKGROUND_BOOLEAN  = "SDL.process.background",
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Process*}, q{SDL_CreateProcess}, q{const(char*)* args, bool pipeStdIO}},
		{q{SDL_Process*}, q{SDL_CreateProcessWithProperties}, q{SDL_PropertiesID props}},
		{q{SDL_PropertiesID}, q{SDL_GetProcessProperties}, q{SDL_Process* process}},
		{q{void*}, q{SDL_ReadProcess}, q{SDL_Process* process, size_t* dataSize, int* exitCode}},
		{q{SDL_IOStream*}, q{SDL_GetProcessInput}, q{SDL_Process* process}},
		{q{SDL_IOStream*}, q{SDL_GetProcessOutput}, q{SDL_Process* process}},
		{q{bool}, q{SDL_KillProcess}, q{SDL_Process* process, bool force}},
		{q{bool}, q{SDL_WaitProcess}, q{SDL_Process* process, bool block, int* exitCode}},
		{q{void}, q{SDL_DestroyProcess}, q{SDL_Process* process}},
	];
	return ret;
}()));
