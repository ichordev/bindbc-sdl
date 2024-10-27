/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.dialogue;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.video: SDL_Window;

struct SDL_DialogueFileFilter{
	const(char)* name;
	const(char)* pattern;
}
alias SDL_DialogFileFilter = SDL_DialogueFileFilter;

alias SDL_DialogueFileCallback = extern(C) void function(void* userData, const(char*)* fileList, int filter) nothrow;
alias SDL_DialogFileCallback = SDL_DialogueFileCallback;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_ShowOpenFileDialog}, q{SDL_DialogueFileCallback callback, void* userData, SDL_Window* window, const(SDL_DialogueFileFilter)* filters, int nFilters, const(char)* defaultLocation, bool allowMany}, aliases: [q{SDL_ShowOpenFileDialogue}]},
		{q{void}, q{SDL_ShowSaveFileDialog}, q{SDL_DialogueFileCallback callback, void* userData, SDL_Window* window, const(SDL_DialogueFileFilter)* filters, int nFilters, const(char)* defaultLocation}, aliases: [q{SDL_ShowSaveFileDialogue}]},
		{q{void}, q{SDL_ShowOpenFolderDialog}, q{SDL_DialogueFileCallback callback, void* userData, SDL_Window* window, const(char)* defaultLocation, bool allowMany}, aliases: [q{SDL_ShowOpenFolderDialogue}]},
	];
	return ret;
}()));
