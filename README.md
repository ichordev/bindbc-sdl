# bindbc-sdl
This project provides both static and dynamic bindings to the [Simple Direct Media Library (SDL)](https://libsdl.org/) and its satellite libraries. They are compatible with `@nogc` and `nothrow` and can be compiled with BetterC compatibility. This package is intended as a replacement of [DerelictSDL2](https://github.com/DerelictOrg/DerelictSDL2), which is not compatible with `@nogc`,  `nothrow`, or BetterC.

## Usage
By default, `bindbc-sdl` is configured to compile as dynamic bindings that are not BetterC compatible. The dynamic bindings have no link-time dependency on the SDL libraries, so the SDL shared libraries must be manually loaded at runtime. When configured as static bindings, there is a link-time dependency on the SDL libraries -- either the static libraries or the appropriate files for linking with shared libraries on your system (see below).

When using DUB to manage your project, the static bindings can be enabled via a DUB `subConfiguration` statement in your project's package file. BetterC compatibility is also enabled via subconfigurations.

To use any of the supported SDL libraries, add `bindbc-sdl` as a dependency to your project's package config file and include the appropriate version for any of the satellite libraries you want to use. For example, the following is configured to use `SDL_image` and `SDL_ttf` in addition to the base SDL binding, as dynamic bindings that are not BetterC compatible:

__dub.json__
```
dependencies {
    "bindbc-sdl": "~>0.1.0",
}
"versions": [
    "BindSDL_Image",
    "BindSDL_TTF"
],
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
versions "BindSDL_Image" "BindSDL_TTF"
```

### The dynamic bindings
The dynamic bindings require no special configuration when using DUB to manage your project. There is no link-time dependency. At runtime, the SDL shared libraries are required to be on the shared library search path of the user's system. On Windows, this is typically handled by distributing the SDL DLLs with your program. On other systems, it usually means installing the SDL runtime libraries through a package manager.

To load the shared libraries, you need to call the appropriate load function.

```d
import bindbc.sdl;

/*
The satellite libraries are optional and are only included here for
demonstration. If they are not being used, they need be neither 
imported nor loaded.
*/
import bindbc.sdl.image;            // SDL_image binding
import bindbc.sdl.mixer;            // SDL_mixer binding
import bindbc.sdl.ttf;              // SDL_ttf binding

/*
This version attempts to load the SDL shared library using well-known variations
of the library name for the host system.
*/
if(!loadSDL()) {
    // handle error;
}
/*
This version attempts to load the SDL library using a user-supplied file name. 
Usually, the name and/or path used will be platform specific, as in this example
which attempts to load `SDL2.dll` from the `libs` subdirectory, relative
to the executable, only on Windows.
*/
// version(Windows) loadSDL("libs/SDL2.dll")

/*
The satellite library loaders also have the same two versions of the load functions,
named according to the library name. Only the parameterless versions are shown
here.
*/
if(!loadSDLImage())  { /* handle error */ }
if(!loadSDLMixer())  { /* handle error */ }
if(!loadSDLTTF())    { /* handle error */ }
```

Note that all of the `load*` functions will return `false` only if the shared library is not found. If any of the functions in the library fail to load, the `load*` functions **will still return true**. It's possible for the binding to be compiled for a higher version of a shared library than the version on the user's system, in which case it's still safe to use the library if none of the missing functions are called. 

To determine if any of the symbols failed to load, which usually indicates a version mismatch, use the error handling functions from the [`bindbc-loader`](https://github.com/BindBC/bindbc-loader) package.

## The static bindings
The static bindings have a link-time dependency on either the shared or static libraries for SDL and any satellite SDL libraries the program uses. On Windows, you can link with the static libraries or, to use the DLLs, the import libraries. On other systems, you can link with either the static libraries or directly with the shared libraries. 

This requires the SDL development packages be installed on your system at compile time. When linking with the static libraries, there is no runtime dependency on SDL. When linking with the shared libraries, the runtime dependency is the same as the dynamic bindings, the difference being that the shared libraries are no longer loaded manually -- loading is handled automatically by the system when the program is launched.

Enabling the static bindings can be done in two ways.

### Via the compiler's `-version` switch or DUB's `versions` directive
Pass the `BindSDL_Static` version to the compiler and link with the appropriate libraries. Note that `BindSDL_Static` will also enable the static binding for any satellite libraries used.

When using the compiler command line or a build system that doesn't support DUB, this is the only option. The `-version=BindSDL_Static` option should be passed to the compiler when building your program. All of the requried C libraries, as well as the `bindbc-sdl` and `bindbc-loader` static libraries, must also be passed to the compiler on the command line or via your build system's configuration. 

When using DUB, its `versions` directive is an option. For example, when using the static bindings for SDL and SDL_image:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"versions": ["BindSDL_Static", "BindSDL_Image"],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
versions "BindSDL_Static" "BindSDL_Image"
libs "SDL2" "SDL2_image"
```

### Via DUB subconfigurations
Instead of using DUB's `versions` directive, a `subConfiguration` can be used. Enable the `static` subconfiguration for the `bindbc-sdl` dependency:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"subConfigurations": {
    "bindbc-sdl": "static"
},
"versions": [
    "BindSDL_Image"
],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
subConfiguration "bindbc-sdl" "static"
versions "BindSDL_Image"
libs "SDL2" "SDL2_image"
```

This has the benefit that it completely excludes from the build any source modules related to the dynamic bindings, i.e. they will never be passed to the compiler.

## BetterC support

BetterC support is enabled via the `dynamicBC` and `staticBC` subconfigurations, for dynamic and static bindings respectively. To enable the static bindings with BetterC support:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"subConfigurations": {
    "bindbc-sdl": "staticBC"
},
"versions": [
    "BindSDL_Image"
],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
subConfiguration "bindbc-sdl" "staticBC"
versions "BindSDL_Image"
libs "SDL2" "SDL2_image"
```

When not using DUB to manage your project, first use DUB to compile the BindBC libraries with the `dynamicBC` or `staticBC` configuration, then pass `-betterC` to the compiler when building your project. 

## The minimum required SDL version
By default, each `bindbc-sdl` binding is configured to compile bindings for the lowest supported version of the C libraries. This ensures the widest level of compatibility at runtime. This behavior can be overridden via the `-version` compiler switch or the `versions` DUB directive. 

It is recommended that you always select the minimum version you require _and no higher_. In this example, the SDL dynamic binding is compiled to support SDL 2.0.2.

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"versions": ["SDL_202"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
versions "SDL_202"
```

When you call `loadSDL` with this example configuration, if SDL 2.0.2 or later is installed on the user's system, the library will load without error. If only SDL 2.0.1 or lower is installed, `loadSDL` will return `true`, but the error functions in `bindbc-loader` will indicate that some functions failed to load. This is why it is recommended to always specify the version you require if it is higher than the default. Then you can abort on error, e.g.:

```d
import loader = bindbc.loader;
import bindbc.sdl;
int main() {
    if(!loadSDL() || loader.errorCount > 0) {
        // Either the installed version of SDL is lower than
        // the program requires, or it's corrupt.
        return -1;
    }
}
```

Following are the supported versions of each SDL library and the corresponding version IDs to pass to the compiler.

| Library & Version  | Version ID       |
|--------------------|------------------|
|SDL 2.0.0           | Default          |
|SDL 2.0.1           | SDL_201          |
|SDL 2.0.2           | SDL_202          |
|SDL 2.0.3           | SDL_203          |
|SDL 2.0.4           | SDL_204          |
|SDL 2.0.5           | SDL_205          |
|SDL 2.0.6           | SDL_206          |
|SDL 2.0.7           | SDL_207          |
|SDL 2.0.8           | SDL_208          |
|--                  | --               |
|SDL_image 2.0.0     | Default          |
|SDL_image 2.0.1     | SDL_Image_201    |
|SDL_image 2.0.2     | SDL_Image_202    |
|--                  | --               |
|SDL_mixer 2.0.0     | Default          |
|SDL_mixer 2.0.1     | SDL_Mixer_201    |
|SDL_mixer 2.0.2     | SDL_Mixer_202    |
|--                  | --               |
|SDL_ttf 2.0.12      | Default          |
|SDL_ttf 2.0.13      | SDL_TTF_2013     |
|SDL_ttf 2.0.14      | SDL_TTF_2014     |


__Note__: SDL's [Filesystem](https://wiki.libsdl.org/CategoryFilesystem) API was added in SDL 2.0.1. However, there was a bug on Windows that prevented `SDL_GetPrefPath` from creating the path when it doesn't exist. When using this API on Windows, it's fine to compile with `SDL_201` -- just make sure to ship SDL 2.0.2 or later with your app on Windows and _verify_ that [the loaded SDL version](https://wiki.libsdl.org/CategoryVersion) is 2.0.2 or later via the `SDL_GetVersion` function. Alternatively, you can compile your app with version `SDL_202` on Windows and `SDL_201` on other platforms, thereby guaranteeing errors if the user does not have at least SDL 2.0.2 or higher on Windows.