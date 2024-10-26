/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.error;

import bindbc.sdl.config, bindbc.sdl.codegen;

pragma(inline,true) extern(C) nothrow @nogc{
	bool SDL_Unsupported() =>
		SDL_SetError("That operation is not supported");
	bool SDL_InvalidParamError(const(char)* param) =>
		SDL_SetError("Parameter '%s' is invalid", param);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_SetError}, q{const(char)* fmt, ...}},
		{q{bool}, q{SDL_OutOfMemory}, q{}},
		{q{const(char)*}, q{SDL_GetError}, q{}},
		{q{bool}, q{SDL_ClearError}, q{}},
	];
	return ret;
}()));
