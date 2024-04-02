/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.config;

public import bindbc.common.types: c_long, c_ulong, va_list, wchar_t;
public import bindbc.common.versions: Version;

enum staticBinding = (){
	version(BindBC_Static)       return true;
	else version(BindSDL_Static) return true;
	else return false;
}();

enum cStyleEnums = (){
	version(SDL_D_Enums_Only)  return false;
	else return true;
}();

enum dStyleEnums = (){
	version(SDL_All_Enums)     return true;
	version(SDL_D_Enums_Only)  return true;
	else return false;
}();

enum sdlVersion = (){
	/+version(SDL_3_2)  return Version(3,2,0);
	else+/              return Version(3,0,0);
}();

enum sdlImageVersion = (){
	version(SDL_Image_3_0)  return Version(3,0,0);
	else                    return Version.none;
}();

enum sdlMixerVersion = (){
	version(SDL_Mixer_3_0)  return Version(3,0,0);
	else                    return Version.none;
}();

enum sdlNetVersion = (){
	version(SDL_Net_3_0)  return Version(3,0,0);
	else                  return Version.none;
}();

enum sdlTTFVersion = (){
	version(SDL_TTF_3_0)  return Version(3,0,0);
	else                  return Version.none;
}();
