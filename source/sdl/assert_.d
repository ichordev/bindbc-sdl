/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.assert_;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

mixin(makeEnumBind(q{SDL_AssertState}, aliases: [q{SDL_Assertion}], members: (){
	EnumMember[] ret = [
		{{q{retry},           q{SDL_ASSERTION_RETRY}}},
		{{q{break_},          q{SDL_ASSERTION_BREAK}}},
		{{q{abort},           q{SDL_ASSERTION_ABORT}}},
		{{q{ignore},          q{SDL_ASSERTION_IGNORE}}},
		{{q{alwaysIgnore},    q{SDL_ASSERTION_ALWAYS_IGNORE}}},
	];
	return ret;
}()));

struct SDL_AssertData{
	int alwaysIgnore;
	alias always_ignore = alwaysIgnore;
	uint triggerCount;
	alias trigger_count = triggerCount;
	const(char)* condition;
	const(char)* filename;
	int lineNum;
	alias linenum = lineNum;
	const(char)* function_;
	const(SDL_AssertData)* next;
}

alias SDL_AssertionHandler = extern(C) SDL_AssertState function(const(SDL_AssertData)* data, void* userData) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_AssertState}, q{SDL_ReportAssertion}, q{SDL_AssertData* data, const(char)* func, const(char)* file, int line}},
		{q{void}, q{SDL_SetAssertionHandler}, q{SDL_AssertionHandler handler, void* userData}},
		{q{SDL_AssertionHandler}, q{SDL_GetDefaultAssertionHandler}, q{}},
		{q{SDL_AssertionHandler}, q{SDL_GetAssertionHandler}, q{void** pUserData}},
		{q{const(SDL_AssertData)*}, q{SDL_GetAssertionReport}, q{}},
		{q{void}, q{SDL_ResetAssertionReport}, q{}},
	];
	return ret;
}()));
