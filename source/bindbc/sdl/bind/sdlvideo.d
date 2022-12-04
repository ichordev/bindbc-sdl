/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlvideo;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlrect: SDL_Rect;
import bindbc.sdl.bind.sdlstdinc: SDL_bool;
import bindbc.sdl.bind.sdlsurface: SDL_Surface;

struct SDL_DisplayMode{
	uint format;
	int w;
	int h;
	int refresh_rate;
	void* driverdata;
}

struct SDL_Window;

//SDL_WindowFlags
enum uint SDL_WINDOW_FULLSCREEN              = 0x00000001;
enum uint SDL_WINDOW_OPENGL                  = 0x00000002;
enum uint SDL_WINDOW_SHOWN                   = 0x00000004;
enum uint SDL_WINDOW_HIDDEN                  = 0x00000008;
enum uint SDL_WINDOW_BORDERLESS              = 0x00000010;
enum uint SDL_WINDOW_RESIZABLE               = 0x00000020;
enum uint SDL_WINDOW_MINIMIZED               = 0x00000040;
enum uint SDL_WINDOW_MAXIMIZED               = 0x00000080;
enum uint SDL_WINDOW_INPUT_GRABBED           = 0x00000100;
enum uint SDL_WINDOW_INPUT_FOCUS             = 0x00000200;
enum uint SDL_WINDOW_MOUSE_FOCUS             = 0x00000400;
enum uint SDL_WINDOW_FULLSCREEN_DESKTOP      = SDL_WINDOW_FULLSCREEN | 0x00001000;
enum uint SDL_WINDOW_FOREIGN                 = 0x00000800;
static if(sdlSupport >= SDLSupport.sdl201){
	enum uint SDL_WINDOW_ALLOW_HIGHDPI       = 0x00002000;
}
static if(sdlSupport >= SDLSupport.sdl204){
	enum uint SDL_WINDOW_MOUSE_CAPTURE       = 0x00004000;
}
static if(sdlSupport >= SDLSupport.sdl205){
	enum uint SDL_WINDOW_ALWAYS_ON_TOP       = 0x00008000;
	enum uint SDL_WINDOW_SKIP_TASKBAR        = 0x00010000;
	enum uint SDL_WINDOW_UTILITY             = 0x00020000;
	enum uint SDL_WINDOW_TOOLTIP             = 0x00040000;
	enum uint SDL_WINDOW_POPUP_MENU          = 0x00080000;
}
static if(sdlSupport >= SDLSupport.sdl206){
	enum uint SDL_WINDOW_VULKAN              = 0x10000000;
}
static if(sdlSupport >= SDLSupport.sdl206){
	enum uint SDL_WINDOW_METAL               = 0x20000000;
}
static if(sdlSupport >= SDLSupport.sdl2016){
	enum uint SDL_WINDOW_MOUSE_GRABBED       = SDL_WINDOW_INPUT_GRABBED;
	enum uint SDL_WINDOW_KEYBOARD_GRABBED    = 0x00100000;
}
alias SDL_WindowFlags = uint;

enum uint SDL_WINDOWPOS_UNDEFINED_MASK = 0x1FFF0000;
enum uint SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_DISPLAY(0);

enum uint SDL_WINDOWPOS_CENTERED_MASK = 0x2FFF0000;
enum uint SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED_DISPLAY(0);

@safe @nogc nothrow pure{
	uint SDL_WINDOWPOS_UNDEFINED_DISPLAY(uint x){ return SDL_WINDOWPOS_UNDEFINED_MASK | x; }
	uint SDL_WINDOWPOS_ISUNDEFINED(uint x){ return (x & 0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK; }
	uint SDL_WINDOWPOS_CENTERED_DISPLAY(uint x){ return SDL_WINDOWPOS_CENTERED_MASK | x; }
	uint SDL_WINDOWPOS_ISCENTERED(uint x){ return (x & 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK; }
}

static if(sdlSupport >= SDLSupport.sdl2018){
	enum SDL_WindowEventID: ubyte{
		SDL_WINDOWEVENT_NONE,
		SDL_WINDOWEVENT_SHOWN,
		SDL_WINDOWEVENT_HIDDEN,
		SDL_WINDOWEVENT_EXPOSED,
		SDL_WINDOWEVENT_MOVED,
		SDL_WINDOWEVENT_RESIZED,
		SDL_WINDOWEVENT_SIZE_CHANGED,
		SDL_WINDOWEVENT_MINIMIZED,
		SDL_WINDOWEVENT_MAXIMIZED,
		SDL_WINDOWEVENT_RESTORED,
		SDL_WINDOWEVENT_ENTER,
		SDL_WINDOWEVENT_LEAVE,
		SDL_WINDOWEVENT_FOCUS_GAINED,
		SDL_WINDOWEVENT_FOCUS_LOST,
		SDL_WINDOWEVENT_CLOSE,
		SDL_WINDOWEVENT_TAKE_FOCUS,
		SDL_WINDOWEVENT_HIT_TEST,
		SDL_WINDOWEVENT_ICCPROF_CHANGED,
		SDL_WINDOWEVENT_DISPLAY_CHANGED,
	}
}else static if(sdlSupport >= SDLSupport.sdl205){
	enum SDL_WindowEventID: ubyte{
		SDL_WINDOWEVENT_NONE,
		SDL_WINDOWEVENT_SHOWN,
		SDL_WINDOWEVENT_HIDDEN,
		SDL_WINDOWEVENT_EXPOSED,
		SDL_WINDOWEVENT_MOVED,
		SDL_WINDOWEVENT_RESIZED,
		SDL_WINDOWEVENT_SIZE_CHANGED,
		SDL_WINDOWEVENT_MINIMIZED,
		SDL_WINDOWEVENT_MAXIMIZED,
		SDL_WINDOWEVENT_RESTORED,
		SDL_WINDOWEVENT_ENTER,
		SDL_WINDOWEVENT_LEAVE,
		SDL_WINDOWEVENT_FOCUS_GAINED,
		SDL_WINDOWEVENT_FOCUS_LOST,
		SDL_WINDOWEVENT_CLOSE,
		SDL_WINDOWEVENT_TAKE_FOCUS,
		SDL_WINDOWEVENT_HIT_TEST,
	}
}else{
	enum SDL_WindowEventID: ubyte{
		SDL_WINDOWEVENT_NONE,
		SDL_WINDOWEVENT_SHOWN,
		SDL_WINDOWEVENT_HIDDEN,
		SDL_WINDOWEVENT_EXPOSED,
		SDL_WINDOWEVENT_MOVED,
		SDL_WINDOWEVENT_RESIZED,
		SDL_WINDOWEVENT_SIZE_CHANGED,
		SDL_WINDOWEVENT_MINIMIZED,
		SDL_WINDOWEVENT_MAXIMIZED,
		SDL_WINDOWEVENT_RESTORED,
		SDL_WINDOWEVENT_ENTER,
		SDL_WINDOWEVENT_LEAVE,
		SDL_WINDOWEVENT_FOCUS_GAINED,
		SDL_WINDOWEVENT_FOCUS_LOST,
		SDL_WINDOWEVENT_CLOSE,
	}
}
mixin(expandEnum!SDL_WindowEventID);

static if(sdlSupport >= SDLSupport.sdl2014){
	enum SDL_DisplayEventID{
		SDL_DISPLAYEVENT_NONE,
		SDL_DISPLAYEVENT_ORIENTATION,
		SDL_DISPLAYEVENT_CONNECTED,
		SDL_DISPLAYEVENT_DISCONNECTED,
	}
	mixin(expandEnum!SDL_DisplayEventID);
}else static if(sdlSupport >= SDLSupport.sdl209){
	enum SDL_DisplayEventID{
		SDL_DISPLAYEVENT_NONE,
		SDL_DISPLAYEVENT_ORIENTATION,
	}
	mixin(expandEnum!SDL_DisplayEventID);
}

static if(sdlSupport >= SDLSupport.sdl209){
	enum SDL_DisplayOrientation{
		SDL_ORIENTATION_UNKNOWN,
		SDL_ORIENTATION_LANDSCAPE,
		SDL_ORIENTATION_LANDSCAPE_FLIPPED,
		SDL_ORIENTATION_PORTRAIT,
		SDL_ORIENTATION_PORTRAIT_FLIPPED,
	}
	mixin(expandEnum!SDL_DisplayOrientation);
}

static if(sdlSupport >= SDLSupport.sdl2016){
	enum SDL_FlashOperation{
		SDL_FLASH_CANCEL,
		SDL_FLASH_BRIEFLY,
		SDL_FLASH_UNTIL_FOCUSED,
	}
	mixin(expandEnum!SDL_FlashOperation);
}

alias SDL_GLContext = void*;

static if(sdlSupport >= SDLSupport.sdl206){
	enum SDL_GLattr{
		SDL_GL_RED_SIZE,
		SDL_GL_GREEN_SIZE,
		SDL_GL_BLUE_SIZE,
		SDL_GL_ALPHA_SIZE,
		SDL_GL_BUFFER_SIZE,
		SDL_GL_DOUBLEBUFFER,
		SDL_GL_DEPTH_SIZE,
		SDL_GL_STENCIL_SIZE,
		SDL_GL_ACCUM_RED_SIZE,
		SDL_GL_ACCUM_GREEN_SIZE,
		SDL_GL_ACCUM_BLUE_SIZE,
		SDL_GL_ACCUM_ALPHA_SIZE,
		SDL_GL_STEREO,
		SDL_GL_MULTISAMPLEBUFFERS,
		SDL_GL_MULTISAMPLESAMPLES,
		SDL_GL_ACCELERATED_VISUAL,
		SDL_GL_RETAINED_BACKING,
		SDL_GL_CONTEXT_MAJOR_VERSION,
		SDL_GL_CONTEXT_MINOR_VERSION,
		SDL_GL_CONTEXT_EGL,
		SDL_GL_CONTEXT_FLAGS,
		SDL_GL_CONTEXT_PROFILE_MASK,
		SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
		SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
		SDL_GL_RELEASE_BEHAVIOR,
		SDL_GL_CONTEXT_RESET_NOTIFICATION,
		SDL_GL_CONTEXT_NO_ERROR,
	}
}
else static if(sdlSupport >= SDLSupport.sdl204){
	enum SDL_GLattr{
		SDL_GL_RED_SIZE,
		SDL_GL_GREEN_SIZE,
		SDL_GL_BLUE_SIZE,
		SDL_GL_ALPHA_SIZE,
		SDL_GL_BUFFER_SIZE,
		SDL_GL_DOUBLEBUFFER,
		SDL_GL_DEPTH_SIZE,
		SDL_GL_STENCIL_SIZE,
		SDL_GL_ACCUM_RED_SIZE,
		SDL_GL_ACCUM_GREEN_SIZE,
		SDL_GL_ACCUM_BLUE_SIZE,
		SDL_GL_ACCUM_ALPHA_SIZE,
		SDL_GL_STEREO,
		SDL_GL_MULTISAMPLEBUFFERS,
		SDL_GL_MULTISAMPLESAMPLES,
		SDL_GL_ACCELERATED_VISUAL,
		SDL_GL_RETAINED_BACKING,
		SDL_GL_CONTEXT_MAJOR_VERSION,
		SDL_GL_CONTEXT_MINOR_VERSION,
		SDL_GL_CONTEXT_EGL,
		SDL_GL_CONTEXT_FLAGS,
		SDL_GL_CONTEXT_PROFILE_MASK,
		SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
		SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
		SDL_GL_RELEASE_BEHAVIOR,
	}
}
else static if(sdlSupport >= SDLSupport.sdl201){
	enum SDL_GLattr{
		SDL_GL_RED_SIZE,
		SDL_GL_GREEN_SIZE,
		SDL_GL_BLUE_SIZE,
		SDL_GL_ALPHA_SIZE,
		SDL_GL_BUFFER_SIZE,
		SDL_GL_DOUBLEBUFFER,
		SDL_GL_DEPTH_SIZE,
		SDL_GL_STENCIL_SIZE,
		SDL_GL_ACCUM_RED_SIZE,
		SDL_GL_ACCUM_GREEN_SIZE,
		SDL_GL_ACCUM_BLUE_SIZE,
		SDL_GL_ACCUM_ALPHA_SIZE,
		SDL_GL_STEREO,
		SDL_GL_MULTISAMPLEBUFFERS,
		SDL_GL_MULTISAMPLESAMPLES,
		SDL_GL_ACCELERATED_VISUAL,
		SDL_GL_RETAINED_BACKING,
		SDL_GL_CONTEXT_MAJOR_VERSION,
		SDL_GL_CONTEXT_MINOR_VERSION,
		SDL_GL_CONTEXT_EGL,
		SDL_GL_CONTEXT_FLAGS,
		SDL_GL_CONTEXT_PROFILE_MASK,
		SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
		SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
	}
}
else{
	enum SDL_GLattr{
		SDL_GL_RED_SIZE,
		SDL_GL_GREEN_SIZE,
		SDL_GL_BLUE_SIZE,
		SDL_GL_ALPHA_SIZE,
		SDL_GL_BUFFER_SIZE,
		SDL_GL_DOUBLEBUFFER,
		SDL_GL_DEPTH_SIZE,
		SDL_GL_STENCIL_SIZE,
		SDL_GL_ACCUM_RED_SIZE,
		SDL_GL_ACCUM_GREEN_SIZE,
		SDL_GL_ACCUM_BLUE_SIZE,
		SDL_GL_ACCUM_ALPHA_SIZE,
		SDL_GL_STEREO,
		SDL_GL_MULTISAMPLEBUFFERS,
		SDL_GL_MULTISAMPLESAMPLES,
		SDL_GL_ACCELERATED_VISUAL,
		SDL_GL_RETAINED_BACKING,
		SDL_GL_CONTEXT_MAJOR_VERSION,
		SDL_GL_CONTEXT_MINOR_VERSION,
		SDL_GL_CONTEXT_EGL,
		SDL_GL_CONTEXT_FLAGS,
		SDL_GL_CONTEXT_PROFILE_MASK,
		SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
	}
}
mixin(expandEnum!SDL_GLattr);

enum SDL_GLprofile {
	SDL_GL_CONTEXT_PROFILE_CORE             = 0x0001,
	SDL_GL_CONTEXT_PROFILE_COMPATIBILITY    = 0x0002,
	SDL_GL_CONTEXT_PROFILE_ES               = 0x0004,
}
mixin(expandEnum!SDL_GLprofile);

enum{
	SDL_GL_CONTEXT_DEBUG_FLAG                 = 0x0001,
	SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG    = 0x0002,
	SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG         = 0x0004,
	SDL_GL_CONTEXT_RESET_ISOLATION_FLAG       = 0x0008,
}
alias SDL_GLcontextFlag = int;

static if(sdlSupport >= SDLSupport.sdl204){
	enum SDL_GLcontextReleaseFlag{
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE     = 0x0000,
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH    = 0x0001,
	}
	mixin(expandEnum!SDL_GLcontextReleaseFlag);

	enum SDL_HitTestResult{
		SDL_HITTEST_NORMAL,
		SDL_HITTEST_DRAGGABLE,
		SDL_HITTEST_RESIZE_TOPLEFT,
		SDL_HITTEST_RESIZE_TOP,
		SDL_HITTEST_RESIZE_TOPRIGHT,
		SDL_HITTEST_RESIZE_RIGHT,
		SDL_HITTEST_RESIZE_BOTTOMRIGHT,
		SDL_HITTEST_RESIZE_BOTTOM,
		SDL_HITTEST_RESIZE_BOTTOMLEFT,
		SDL_HITTEST_RESIZE_LEFT,
	}
	mixin(expandEnum!SDL_HitTestResult);

	import bindbc.sdl.bind.sdlrect: SDL_Point;
	extern(C) nothrow alias SDL_HitTest = SDL_HitTestResult function(SDL_Window*,const(SDL_Point)*,void*);
}

static if(sdlSupport >= SDLSupport.sdl206){
	enum SDL_GLContextResetNotification{
		SDL_GL_CONTEXT_RESET_NO_NOTIFICATION    = 0x0000,
		SDL_GL_CONTEXT_RESET_LOSE_CONTEXT       = 0x0001,
	}
	mixin(expandEnum!SDL_GLContextResetNotification);
}

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{int}, q{SDL_GetNumVideoDrivers}, q{}],
		[q{const(char)*}, q{SDL_GetVideoDriver}, q{int index}],
		[q{int}, q{SDL_VideoInit}, q{const(char)* driver_name}],
		[q{void}, q{SDL_VideoQuit}, q{}],
		[q{const(char)*}, q{SDL_GetCurrentVideoDriver}, q{}],
		[q{int}, q{SDL_GetNumVideoDisplays}, q{}],
		[q{const(char)*}, q{SDL_GetDisplayName}, q{int displayIndex}],
		[q{int}, q{SDL_GetDisplayBounds}, q{int displayIndex, SDL_Rect* rect}],
		[q{int}, q{SDL_GetNumDisplayModes}, q{int displayIndex}],
		[q{int}, q{SDL_GetDisplayMode}, q{int displayIndex, int modeIndex, SDL_DisplayMode* mode}],
		[q{int}, q{SDL_GetDesktopDisplayMode}, q{int displayIndex, SDL_DisplayMode* mode}],
		[q{int}, q{SDL_GetCurrentDisplayMode}, q{int displayIndex, SDL_DisplayMode* mode}],
		[q{SDL_DisplayMode*}, q{SDL_GetClosestDisplayMode}, q{int displayIndex, const(SDL_DisplayMode)* mode, SDL_DisplayMode* closest}],
		[q{int}, q{SDL_GetWindowDisplayIndex}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowDisplayMode}, q{SDL_Window* window, const(SDL_DisplayMode)* mode}],
		[q{int}, q{SDL_GetWindowDisplayMode}, q{SDL_Window* window, SDL_DisplayMode* mode}],
		[q{uint}, q{SDL_GetWindowPixelFormat}, q{SDL_Window* window}],
		[q{SDL_Window*}, q{SDL_CreateWindow}, q{const(char)* title, int x, int y, int w, int h, SDL_WindowFlags flags}],
		[q{SDL_Window*}, q{SDL_CreateWindowFrom}, q{const(void)* data}],
		[q{uint}, q{SDL_GetWindowID}, q{SDL_Window* window}],
		[q{SDL_Window*}, q{SDL_GetWindowFromID}, q{uint id}],
		[q{SDL_WindowFlags}, q{SDL_GetWindowFlags}, q{SDL_Window* window}],
		[q{void}, q{SDL_SetWindowTitle}, q{SDL_Window* window, const(char)* title}],
		[q{const(char)*}, q{SDL_GetWindowTitle}, q{SDL_Window* window}],
		[q{void}, q{SDL_SetWindowIcon}, q{SDL_Window* window, SDL_Surface* icon}],
		[q{void*}, q{SDL_SetWindowData}, q{SDL_Window* window, const(char)* name, void* userdata}],
		[q{void*}, q{SDL_GetWindowData}, q{SDL_Window* window, const(char)* name}],
		[q{void}, q{SDL_SetWindowPosition}, q{SDL_Window* window, int x, int y}],
		[q{void}, q{SDL_GetWindowPosition}, q{SDL_Window* window, int* x, int* y}],
		[q{void}, q{SDL_SetWindowSize}, q{SDL_Window* window, int w, int h}],
		[q{void}, q{SDL_GetWindowSize}, q{SDL_Window* window, int* w, int* h}],
		[q{void}, q{SDL_SetWindowMinimumSize}, q{SDL_Window* window, int min_w, int min_h}],
		[q{void}, q{SDL_GetWindowMinimumSize}, q{SDL_Window* window, int* w, int* h}],
		[q{void}, q{SDL_SetWindowMaximumSize}, q{SDL_Window* window, int max_w, int max_h}],
		[q{void}, q{SDL_GetWindowMaximumSize}, q{SDL_Window* window, int* w, int* h}],
		[q{void}, q{SDL_SetWindowBordered}, q{SDL_Window* window, SDL_bool bordered}],
		[q{void}, q{SDL_ShowWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_HideWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_RaiseWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_MaximizeWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_MinimizeWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_RestoreWindow}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowFullscreen}, q{SDL_Window* window, SDL_WindowFlags flags}],
		[q{SDL_Surface*}, q{SDL_GetWindowSurface}, q{SDL_Window* window}],
		[q{int}, q{SDL_UpdateWindowSurface}, q{SDL_Window* window}],
		[q{int}, q{SDL_UpdateWindowSurfaceRects}, q{SDL_Window* window, SDL_Rect* rects, int numrects}],
		[q{void}, q{SDL_SetWindowGrab}, q{SDL_Window* window, SDL_bool grabbed}],
		[q{SDL_bool}, q{SDL_GetWindowGrab}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowBrightness}, q{SDL_Window* window, float brightness}],
		[q{float}, q{SDL_GetWindowBrightness}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowGammaRamp}, q{SDL_Window* window, const(ushort)* red, const(ushort)* green, const(ushort)* blue}],
		[q{int}, q{SDL_GetWindowGammaRamp}, q{SDL_Window* window, ushort* red, ushort* green, ushort* blue}],
		[q{void}, q{SDL_DestroyWindow}, q{SDL_Window* window}],
		[q{SDL_bool}, q{SDL_IsScreenSaverEnabled}, q{}],
		[q{void}, q{SDL_EnableScreenSaver}, q{}],
		[q{void}, q{SDL_DisableScreenSaver}, q{}],
		[q{int}, q{SDL_GL_LoadLibrary}, q{const(char)* path}],
		[q{void*}, q{SDL_GL_GetProcAddress}, q{const(char)* proc}],
		[q{void}, q{SDL_GL_UnloadLibrary}, q{}],
		[q{SDL_bool}, q{SDL_GL_ExtensionSupported}, q{const(char)* extension}],
		[q{int}, q{SDL_GL_SetAttribute}, q{SDL_GLattr attr, int value}],
		[q{int}, q{SDL_GL_GetAttribute}, q{SDL_GLattr attr, int* value}],
		[q{SDL_GLContext}, q{SDL_GL_CreateContext}, q{SDL_Window* window}],
		[q{int}, q{SDL_GL_MakeCurrent}, q{SDL_Window* window, SDL_GLContext context}],
		[q{SDL_Window*}, q{SDL_GL_GetCurrentWindow}, q{}],
		[q{SDL_GLContext}, q{SDL_GL_GetCurrentContext}, q{}],
		[q{int}, q{SDL_GL_SetSwapInterval}, q{int interval}],
		[q{int}, q{SDL_GL_GetSwapInterval}, q{}],
		[q{void}, q{SDL_GL_SwapWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_GL_DeleteContext}, q{SDL_GLContext context}],
	);
	static if(sdlSupport >= SDLSupport.sdl201){
		ret ~= makeFnBinds!(
			[q{void}, q{SDL_GL_GetDrawableSize}, q{SDL_Window* window, int* w, int* h}],
		);
	}
	static if(sdlSupport >= SDLSupport.sdl202){
		ret ~= makeFnBinds!(
			[q{void}, q{SDL_GL_ResetAttributes}, q{}],
		);
	}
	static if(sdlSupport >= SDLSupport.sdl204){
		ret ~= makeFnBinds!(
			[q{int}, q{SDL_GetDisplayDPI}, q{int displayIndex, float* ddpi, float* hdpi, float* vdpi}],
			[q{SDL_Window*}, q{SDL_GetGrabbedWindow}, q{}],
			[q{int}, q{SDL_SetWindowHitTest}, q{SDL_Window* window, SDL_HitTest callback, void* callback_data}],
		);
	}
	static if(sdlSupport >= SDLSupport.sdl205){
		ret ~= makeFnBinds!(
			[q{int}, q{SDL_GetDisplayUsableBounds}, q{int displayIndex, SDL_Rect* rect}],
			[q{int}, q{SDL_GetWindowBordersSize}, q{SDL_Window* window, int* top, int* left, int* bottom, int* right}],
			[q{int}, q{SDL_GetWindowOpacity}, q{SDL_Window* window, float* opacity}],
			[q{int}, q{SDL_SetWindowInputFocus}, q{SDL_Window* window}],
			[q{int}, q{SDL_SetWindowModalFor}, q{SDL_Window* modal_window, SDL_Window* parent_window}],
			[q{int}, q{SDL_SetWindowOpacity}, q{SDL_Window* window, float opacity}],
			[q{void}, q{SDL_SetWindowResizable}, q{SDL_Window* window, SDL_bool resizable}],
		);
	}
	static if(sdlSupport >= SDLSupport.sdl209){
		ret ~= makeFnBinds!(
			[q{SDL_DisplayOrientation}, q{SDL_GetDisplayOrientation}, q{int displayIndex}],
		);
	}
	static if(sdlSupport >= SDLSupport.sdl2016){
		ret ~= makeFnBinds!(
			[q{int}, q{SDL_FlashWindow}, q{SDL_Window* window, SDL_FlashOperation operation}],
			[q{void}, q{SDL_SetWindowAlwaysOnTop}, q{SDL_Window* window, SDL_bool on_top}],
			[q{void}, q{SDL_SetWindowKeyboardGrab}, q{SDL_Window* window, SDL_bool grabbed}],
			[q{SDL_bool}, q{SDL_GetWindowKeyboardGrab}, q{SDL_Window * window}],
			[q{void}, q{SDL_SetWindowMouseGrab}, q{SDL_Window* window, SDL_bool grabbed}],
			[q{SDL_bool}, q{SDL_GetWindowMouseGrab}, q{SDL_Window* window}],
		);
	}
	static if(sdlSupport >= SDLSupport.sdl2018){
		ret ~= makeFnBinds!(
			[q{void*}, q{SDL_GetWindowICCProfile}, q{SDL_Window* window, size_t* size}],
			[q{int}, q{SDL_SetWindowMouseRect}, q{SDL_Window* window, const(SDL_Rect)* rect}],
			[q{const(SDL_Rect)*}, q{SDL_GetWindowMouseRect}, q{SDL_Window* window}],
		);
	}
	return ret;
}()));
