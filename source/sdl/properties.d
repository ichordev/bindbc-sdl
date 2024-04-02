/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.properties;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc;

alias SDL_PropertiesID = uint;

mixin(makeEnumBind(q{SDL_PropertyType}, members: (){
	EnumMember[] ret = [
		{{q{invalid},    q{SDL_PROPERTY_TYPE_INVALID}}},
		{{q{pointer},    q{SDL_PROPERTY_TYPE_POINTER}}},
		{{q{string},     q{SDL_PROPERTY_TYPE_STRING}}},
		{{q{number},     q{SDL_PROPERTY_TYPE_NUMBER}}},
		{{q{float_},     q{SDL_PROPERTY_TYPE_FLOAT}}},
		{{q{boolean},    q{SDL_PROPERTY_TYPE_BOOLEAN}}},
	];
	return ret;
}()));

extern(C) nothrow{
	alias SDL_EnumeratePropertiesCallback = void function(void* userData, SDL_PropertiesID props, const(char)* name);
	
	private alias CleanupFn = void function(void* userData, void* value);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_PropertiesID}, q{SDL_GetGlobalProperties}, q{}},
		{q{SDL_PropertiesID}, q{SDL_CreateProperties}, q{}},
		{q{int}, q{SDL_CopyProperties}, q{SDL_PropertiesID src, SDL_PropertiesID dst}},
		{q{int}, q{SDL_LockProperties}, q{SDL_PropertiesID props}},
		{q{void}, q{SDL_UnlockProperties}, q{SDL_PropertiesID props}},
		{q{int}, q{SDL_SetPropertyWithCleanup}, q{SDL_PropertiesID props, const(char)* name, void* value, CleanupFn cleanup, void* userData}},
		{q{int}, q{SDL_SetProperty}, q{SDL_PropertiesID props, const(char)* name, void* value}},
		{q{int}, q{SDL_SetStringProperty}, q{SDL_PropertiesID props, const(char)* name, const(char)* value}},
		{q{int}, q{SDL_SetNumberProperty}, q{SDL_PropertiesID props, const(char)* name, long value}},
		{q{int}, q{SDL_SetFloatProperty}, q{SDL_PropertiesID props, const(char)* name, float value}},
		{q{int}, q{SDL_SetBooleanProperty}, q{SDL_PropertiesID props, const(char)* name, SDL_Bool value}},
		{q{SDL_Bool}, q{SDL_HasProperty}, q{SDL_PropertiesID props, const(char)* name}},
		{q{SDL_PropertyType}, q{SDL_GetPropertyType}, q{SDL_PropertiesID props, const(char)* name}},
		{q{void*}, q{SDL_GetProperty}, q{SDL_PropertiesID props, const(char)* name, void* defaultValue}},
		{q{const(char)*}, q{SDL_GetStringProperty}, q{SDL_PropertiesID props, const(char)* name, const(char)* defaultValue}},
		{q{long}, q{SDL_GetNumberProperty}, q{SDL_PropertiesID props, const(char)* name, long defaultValue}},
		{q{float}, q{SDL_GetFloatProperty}, q{SDL_PropertiesID props, const(char)* name, float defaultValue}},
		{q{SDL_Bool}, q{SDL_GetBooleanProperty}, q{SDL_PropertiesID props, const(char)* name, SDL_Bool defaultValue}},
		{q{int}, q{SDL_ClearProperty}, q{SDL_PropertiesID props, const(char)* name}},
		{q{int}, q{SDL_EnumerateProperties}, q{SDL_PropertiesID props, SDL_EnumeratePropertiesCallback callback, void* userData}},
		{q{void}, q{SDL_DestroyProperties}, q{SDL_PropertiesID props}},
	];
	return ret;
}()));
