/+
+               Copyright 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.video;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.pixels;
import sdl.properties;
import sdl.rect: SDL_Rect, SDL_Point;
import sdl.stdinc: SDL_FunctionPointer;
import sdl.surface: SDL_Surface;

alias SDL_DisplayID = uint;

alias SDL_WindowID = uint;

enum SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER = "SDL.video.wayland.wl_display";

mixin(makeEnumBind(q{SDL_SystemTheme}, members: (){
	EnumMember[] ret = [
		{{q{unknown},  q{SDL_SYSTEM_THEME_UNKNOWN}}},
		{{q{light},    q{SDL_SYSTEM_THEME_LIGHT}}},
		{{q{dark},     q{SDL_SYSTEM_THEME_DARK}}},
	];
	return ret;
}()));

struct SDL_DisplayModeData;

struct SDL_DisplayMode{
	SDL_DisplayID displayID;
	SDL_PixelFormat format;
	int w, h;
	float pixelDensity;
	float refreshRate;
	int refreshRateNumerator;
	int refreshRateDenominator;
	
	SDL_DisplayModeData* internal;
	
	alias pixel_density = pixelDensity;
	alias refresh_rate = refreshRate;
	alias refresh_rate_numerator = refreshRateNumerator;
	alias refresh_rate_denominator = refreshRateDenominator;
}

mixin(makeEnumBind(q{SDL_DisplayOrientation}, aliases: [q{SDL_Orientation}], members: (){
	EnumMember[] ret = [
		{{q{unknown},           q{SDL_ORIENTATION_UNKNOWN}}},
		{{q{landscape},         q{SDL_ORIENTATION_LANDSCAPE}}},
		{{q{landscapeFlipped},  q{SDL_ORIENTATION_LANDSCAPE_FLIPPED}}},
		{{q{portrait},          q{SDL_ORIENTATION_PORTRAIT}}},
		{{q{portraitFlipped},   q{SDL_ORIENTATION_PORTRAIT_FLIPPED}}},
	];
	return ret;
}()));

struct SDL_Window;

alias SDL_WindowFlags_ = c_uint64;
mixin(makeEnumBind(q{SDL_WindowFlags}, q{SDL_WindowFlags_}, members: (){
	EnumMember[] ret = [
		{{q{fullscreen},           q{SDL_WINDOW_FULLSCREEN}},             q{0x0000_0000_0000_0001UL}},
		{{q{openGL},               q{SDL_WINDOW_OPENGL}},                 q{0x0000_0000_0000_0002UL}},
		{{q{occluded},             q{SDL_WINDOW_OCCLUDED}},               q{0x0000_0000_0000_0004UL}},
		{{q{hidden},               q{SDL_WINDOW_HIDDEN}},                 q{0x0000_0000_0000_0008UL}},
		{{q{borderless},           q{SDL_WINDOW_BORDERLESS}},             q{0x0000_0000_0000_0010UL}},
		{{q{resizable},            q{SDL_WINDOW_RESIZABLE}},              q{0x0000_0000_0000_0020UL}},
		{{q{minimized},            q{SDL_WINDOW_MINIMIZED}},              q{0x0000_0000_0000_0040UL}},
		{{q{maximized},            q{SDL_WINDOW_MAXIMIZED}},              q{0x0000_0000_0000_0080UL}},
		{{q{mouseGrabbed},         q{SDL_WINDOW_MOUSE_GRABBED}},          q{0x0000_0000_0000_0100UL}},
		{{q{inputFocus},           q{SDL_WINDOW_INPUT_FOCUS}},            q{0x0000_0000_0000_0200UL}},
		{{q{mouseFocus},           q{SDL_WINDOW_MOUSE_FOCUS}},            q{0x0000_0000_0000_0400UL}},
		{{q{external},             q{SDL_WINDOW_EXTERNAL}},               q{0x0000_0000_0000_0800UL}},
		{{q{modal},                q{SDL_WINDOW_MODAL}},                  q{0x0000_0000_0000_1000UL}},
		{{q{highPixelDensity},     q{SDL_WINDOW_HIGH_PIXEL_DENSITY}},     q{0x0000_0000_0000_2000UL}},
		{{q{mouseCapture},         q{SDL_WINDOW_MOUSE_CAPTURE}},          q{0x0000_0000_0000_4000UL}},
		{{q{mouseRelativeMode},    q{SDL_WINDOW_MOUSE_RELATIVE_MODE}},    q{0x0000_0000_0000_8000UL}},
		{{q{alwaysOnTop},          q{SDL_WINDOW_ALWAYS_ON_TOP}},          q{0x0000_0000_0001_0000UL}},
		{{q{utility},              q{SDL_WINDOW_UTILITY}},                q{0x0000_0000_0002_0000UL}},
		{{q{tooltip},              q{SDL_WINDOW_TOOLTIP}},                q{0x0000_0000_0004_0000UL}},
		{{q{popupMenu},            q{SDL_WINDOW_POPUP_MENU}},             q{0x0000_0000_0008_0000UL}},
		{{q{keyboardGrabbed},      q{SDL_WINDOW_KEYBOARD_GRABBED}},       q{0x0000_0000_0010_0000UL}},
		{{q{vulkan},               q{SDL_WINDOW_VULKAN}},                 q{0x0000_0000_1000_0000UL}},
		{{q{metal},                q{SDL_WINDOW_METAL}},                  q{0x0000_0000_2000_0000UL}},
		{{q{transparent},          q{SDL_WINDOW_TRANSPARENT}},            q{0x0000_0000_4000_0000UL}},
		{{q{notFocusable},         q{SDL_WINDOW_NOT_FOCUSABLE}},          q{0x0000_0000_8000_0000UL}},
	];
	return ret;
}()));

enum SDL_WINDOWPOS_UNDEFINED_MASK = 0x1FFF_0000U;
enum SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_DISPLAY(0);
pragma(inline,true) extern(C) nothrow @nogc pure @safe{
	int SDL_WINDOWPOS_UNDEFINED_DISPLAY(int x) => SDL_WINDOWPOS_UNDEFINED_MASK | x;
	bool SDL_WINDOWPOS_ISUNDEFINED(int x) => (x & 0xFFFF_0000) == SDL_WINDOWPOS_UNDEFINED_MASK;
}

enum SDL_WINDOWPOS_CENTRED_MASK = 0x2FFF_0000U;
enum SDL_WINDOWPOS_CENTRED = SDL_WINDOWPOS_CENTERED_DISPLAY(0);
pragma(inline,true) extern(C) nothrow @nogc pure @safe{
	int SDL_WINDOWPOS_CENTRED_DISPLAY(int x) => SDL_WINDOWPOS_CENTERED_MASK | x;
	bool SDL_WINDOWPOS_ISCENTRED(int x) => (x & 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK;
}
alias SDL_WINDOWPOS_CENTERED_MASK = SDL_WINDOWPOS_CENTRED_MASK;
alias SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTRED;
alias SDL_WINDOWPOS_CENTERED_DISPLAY = SDL_WINDOWPOS_CENTRED_DISPLAY;
alias SDL_WINDOWPOS_ISCENTERED = SDL_WINDOWPOS_ISCENTRED;

mixin(makeEnumBind(q{SDL_FlashOperation}, aliases: [q{SDL_Flash}], members: (){
	EnumMember[] ret = [
		{{q{cancel},          q{SDL_FLASH_CANCEL}}},
		{{q{briefly},         q{SDL_FLASH_BRIEFLY}}},
		{{q{untilFocused},    q{SDL_FLASH_UNTIL_FOCUSED}}},
	];
	return ret;
}()));

struct SDL_GLContextState;
alias SDL_GLContext = SDL_GLContextState*;

alias SDL_EGLDisplay = void*;
alias SDL_EGLConfig = void*;
alias SDL_EGLSurface = void*;
alias SDL_EGLAttrib = ptrdiff_t;
alias SDL_EGLint = int;

extern(C) nothrow{
	alias SDL_EGLAttribArrayCallback = SDL_EGLAttrib function(void* userData);
	alias SDL_EGLIntArrayCallback = SDL_EGLint function(void* userData, SDL_EGLDisplay display, SDL_EGLConfig config);
}

mixin(makeEnumBind(q{SDL_GLAttr}, aliases: [q{SDL_GL}, q{SDL_GLattr}], members: (){
	EnumMember[] ret = [
		{{q{redSize},                     q{SDL_GL_RED_SIZE}}},
		{{q{greenSize},                   q{SDL_GL_GREEN_SIZE}}},
		{{q{blueSize},                    q{SDL_GL_BLUE_SIZE}}},
		{{q{alphaSize},                   q{SDL_GL_ALPHA_SIZE}}},
		{{q{bufferSize},                  q{SDL_GL_BUFFER_SIZE}}},
		{{q{doubleBuffer},                q{SDL_GL_DOUBLEBUFFER}}},
		{{q{depthSize},                   q{SDL_GL_DEPTH_SIZE}}},
		{{q{stencilSize},                 q{SDL_GL_STENCIL_SIZE}}},
		{{q{accumRedSize},                q{SDL_GL_ACCUM_RED_SIZE}}},
		{{q{accumGreenSize},              q{SDL_GL_ACCUM_GREEN_SIZE}}},
		{{q{accumBlueSize},               q{SDL_GL_ACCUM_BLUE_SIZE}}},
		{{q{accumAlphaSize},              q{SDL_GL_ACCUM_ALPHA_SIZE}}},
		{{q{stereo},                      q{SDL_GL_STEREO}}},
		{{q{multiSampleBuffers},          q{SDL_GL_MULTISAMPLEBUFFERS}}},
		{{q{multiSampleSamples},          q{SDL_GL_MULTISAMPLESAMPLES}}},
		{{q{acceleratedVisual},           q{SDL_GL_ACCELERATED_VISUAL}}},
		{{q{retainedBacking},             q{SDL_GL_RETAINED_BACKING}}},
		{{q{contextMajorVersion},         q{SDL_GL_CONTEXT_MAJOR_VERSION}}},
		{{q{contextMinorVersion},         q{SDL_GL_CONTEXT_MINOR_VERSION}}},
		{{q{contextFlags},                q{SDL_GL_CONTEXT_FLAGS}}},
		{{q{contextProfileMask},          q{SDL_GL_CONTEXT_PROFILE_MASK}}},
		{{q{shareWithCurrentContext},     q{SDL_GL_SHARE_WITH_CURRENT_CONTEXT}}},
		{{q{framebufferSRGBCapable},      q{SDL_GL_FRAMEBUFFER_SRGB_CAPABLE}}},
		{{q{contextReleaseBehaviour},     q{SDL_GL_CONTEXT_RELEASE_BEHAVIOUR}}, aliases: [{q{contextReleaseBehavior}, q{SDL_GL_CONTEXT_RELEASE_BEHAVIOR}}]},
		{{q{contextResetNotification},    q{SDL_GL_CONTEXT_RESET_NOTIFICATION}}},
		{{q{contextNoError},              q{SDL_GL_CONTEXT_NO_ERROR}}},
		{{q{floatBuffers},                q{SDL_GL_FLOATBUFFERS}}},
		{{q{eglPlatform},                 q{SDL_GL_EGL_PLATFORM}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GLProfile}, aliases: [q{SDL_GLContextProfile}, q{SDL_GLprofile}], members: (){
	EnumMember[] ret = [
		{{q{core},             q{SDL_GL_CONTEXT_PROFILE_CORE}},             q{0x0001}},
		{{q{compatibility},    q{SDL_GL_CONTEXT_PROFILE_COMPATIBILITY}},    q{0x0002}},
		{{q{es},               q{SDL_GL_CONTEXT_PROFILE_ES}},               q{0x0004}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GLContextFlag}, aliases: [q{SDL_GLcontextFlag}], members: (){
	EnumMember[] ret = [
		{{q{debugFlag},                q{SDL_GL_CONTEXT_DEBUG_FLAG}},                 q{0x0001}},
		{{q{forwardCompatibleFlag},    q{SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG}},    q{0x0002}},
		{{q{robustAccessFlag},         q{SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG}},         q{0x0004}},
		{{q{resetIsolationFlag},       q{SDL_GL_CONTEXT_RESET_ISOLATION_FLAG}},       q{0x0008}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GLContextReleaseFlag}, aliases: [q{SDL_GLContextReleaseBehaviour}, q{SDL_GLContextReleaseBehavior}, q{SDL_GLcontextReleaseFlag}], members: (){
	EnumMember[] ret = [
		{{q{none},     q{SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE}},     q{0x0000}},
		{{q{flush},    q{SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH}},    q{0x0001}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GLContextResetNotification}, aliases: [q{SDL_GLContextReset}], members: (){
	EnumMember[] ret = [
		{{q{noNotification},    q{SDL_GL_CONTEXT_RESET_NO_NOTIFICATION}},    q{0x0000}},
		{{q{loseContext},       q{SDL_GL_CONTEXT_RESET_LOSE_CONTEXT}},       q{0x0001}},
	];
	return ret;
}()));

enum{
	SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN              = "SDL.display.HDR_enabled",
	SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER  = "SDL.display.KMSDRM.panel_orientation",
}

enum{
	SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN                = "SDL.window.create.always_on_top",
	SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN                   = "SDL.window.create.borderless",
	SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN                    = "SDL.window.create.focusable",
	SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN    = "SDL.window.create.external_graphics_context",
	SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER                         = "SDL.window.create.flags",
	SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN                   = "SDL.window.create.fullscreen",
	SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER                        = "SDL.window.create.height",
	SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN                       = "SDL.window.create.hidden",
	SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN           = "SDL.window.create.high_pixel_density",
	SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN                    = "SDL.window.create.maximized",
	SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN                         = "SDL.window.create.menu",
	SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN                        = "SDL.window.create.metal",
	SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN                    = "SDL.window.create.minimized",
	SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN                        = "SDL.window.create.modal",
	SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN                = "SDL.window.create.mouse_grabbed",
	SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN                       = "SDL.window.create.opengl",
	SDL_PROP_WINDOW_CREATE_PARENT_POINTER                       = "SDL.window.create.parent",
	SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN                    = "SDL.window.create.resizable",
	SDL_PROP_WINDOW_CREATE_TITLE_STRING                         = "SDL.window.create.title",
	SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN                  = "SDL.window.create.transparent",
	SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN                      = "SDL.window.create.tooltip",
	SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN                      = "SDL.window.create.utility",
	SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN                       = "SDL.window.create.vulkan",
	SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER                         = "SDL.window.create.width",
	SDL_PROP_WINDOW_CREATE_X_NUMBER                             = "SDL.window.create.x",
	SDL_PROP_WINDOW_CREATE_Y_NUMBER                             = "SDL.window.create.y",
	SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER                 = "SDL.window.create.cocoa.window",
	SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER                   = "SDL.window.create.cocoa.view",
	SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN  = "SDL.window.create.wayland.surface_role_custom",
	SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN    = "SDL.window.create.wayland.create_egl_window",
	SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER           = "SDL.window.create.wayland.wl_surface",
	SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER                   = "SDL.window.create.win32.hwnd",
	SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER      = "SDL.window.create.win32.pixel_format_hwnd",
	SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER                    = "SDL.window.create.x11.window",
}

enum{
	SDL_PROP_WINDOW_SHAPE_POINTER                              = "SDL.window.shape",
	SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN                        = "SDL.window.HDR_enabled",
	SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT                      = "SDL.window.SDR_white_level",
	SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT                         = "SDL.window.HDR_headroom",
	SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER                     = "SDL.window.android.window",
	SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER                    = "SDL.window.android.surface",
	SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER                       = "SDL.window.uikit.window",
	SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER                = "SDL.window.uikit.metal_view_tag",
	SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER            = "SDL.window.uikit.opengl.framebuffer",
	SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER           = "SDL.window.uikit.opengl.renderbuffer",
	SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER    = "SDL.window.uikit.opengl.resolve_framebuffer",
	SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER                 = "SDL.window.kmsdrm.dev_index",
	SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER                       = "SDL.window.kmsdrm.drm_fd",
	SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER                  = "SDL.window.kmsdrm.gbm_dev",
	SDL_PROP_WINDOW_COCOA_WINDOW_POINTER                       = "SDL.window.cocoa.window",
	SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER                = "SDL.window.cocoa.metal_view_tag",
	SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER                    = "SDL.window.vivante.display",
	SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER                     = "SDL.window.vivante.window",
	SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER                    = "SDL.window.vivante.surface",
	SDL_PROP_WINDOW_WIN32_HWND_POINTER                         = "SDL.window.win32.hwnd",
	SDL_PROP_WINDOW_WIN32_HDC_POINTER                          = "SDL.window.win32.hdc",
	SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER                     = "SDL.window.win32.instance",
	SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER                    = "SDL.window.wayland.display",
	SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER                    = "SDL.window.wayland.surface",
	SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER                 = "SDL.window.wayland.egl_window",
	SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER                = "SDL.window.wayland.xdg_surface",
	SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER               = "SDL.window.wayland.xdg_toplevel",
	SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING  = "SDL.window.wayland.xdg_toplevel_export_handle",
	SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER                  = "SDL.window.wayland.xdg_popup",
	SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER             = "SDL.window.wayland.xdg_positioner",
	SDL_PROP_WINDOW_X11_DISPLAY_POINTER                        = "SDL.window.x11.display",
	SDL_PROP_WINDOW_X11_SCREEN_NUMBER                          = "SDL.window.x11.screen",
	SDL_PROP_WINDOW_X11_WINDOW_NUMBER                          = "SDL.window.x11.window",
}

enum{
	SDL_WINDOW_SURFACE_VSYNC_DISABLED = 0,
	SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE = -1,
}

mixin(makeEnumBind(q{SDL_HitTestResult}, members: (){
	EnumMember[] ret = [
		{{q{normal},             q{SDL_HITTEST_NORMAL}}},
		{{q{draggable},          q{SDL_HITTEST_DRAGGABLE}}},
		{{q{resizeTopLeft},      q{SDL_HITTEST_RESIZE_TOPLEFT}}},
		{{q{resizeTop},          q{SDL_HITTEST_RESIZE_TOP}}},
		{{q{resizeTopRight},     q{SDL_HITTEST_RESIZE_TOPRIGHT}}},
		{{q{resizeRight},        q{SDL_HITTEST_RESIZE_RIGHT}}},
		{{q{resizeBottomRight},  q{SDL_HITTEST_RESIZE_BOTTOMRIGHT}}},
		{{q{resizeBottom},       q{SDL_HITTEST_RESIZE_BOTTOM}}},
		{{q{resizeBottomLeft},   q{SDL_HITTEST_RESIZE_BOTTOMLEFT}}},
		{{q{resizeLeft},         q{SDL_HITTEST_RESIZE_LEFT}}},
	];
	return ret;
}()));

alias SDL_HitTest = extern(C) SDL_HitTestResult function(SDL_Window* win, const(SDL_Point)* area, void* data) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumVideoDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetVideoDriver}, q{int index}},
		{q{const(char)*}, q{SDL_GetCurrentVideoDriver}, q{}},
		{q{SDL_SystemTheme}, q{SDL_GetSystemTheme}, q{}},
		{q{SDL_DisplayID*}, q{SDL_GetDisplays}, q{int* count}},
		{q{SDL_DisplayID}, q{SDL_GetPrimaryDisplay}, q{}},
		{q{SDL_PropertiesID}, q{SDL_GetDisplayProperties}, q{SDL_DisplayID displayID}},
		{q{const(char)*}, q{SDL_GetDisplayName}, q{SDL_DisplayID displayID}},
		{q{bool}, q{SDL_GetDisplayBounds}, q{SDL_DisplayID displayID, SDL_Rect* rect}},
		{q{bool}, q{SDL_GetDisplayUsableBounds}, q{SDL_DisplayID displayID, SDL_Rect* rect}},
		{q{SDL_DisplayOrientation}, q{SDL_GetNaturalDisplayOrientation}, q{SDL_DisplayID displayID}},
		{q{SDL_DisplayOrientation}, q{SDL_GetCurrentDisplayOrientation}, q{SDL_DisplayID displayID}},
		{q{float}, q{SDL_GetDisplayContentScale}, q{SDL_DisplayID displayID}},
		{q{SDL_DisplayMode**}, q{SDL_GetFullscreenDisplayModes}, q{SDL_DisplayID displayID, int* count}},
		{q{bool}, q{SDL_GetClosestFullscreenDisplayMode}, q{SDL_DisplayID displayID, int w, int h, float refreshRate, bool includeHighDensityModes, SDL_DisplayMode* mode}},
		{q{const(SDL_DisplayMode)*}, q{SDL_GetDesktopDisplayMode}, q{SDL_DisplayID displayID}},
		{q{const(SDL_DisplayMode)*}, q{SDL_GetCurrentDisplayMode}, q{SDL_DisplayID displayID}},
		{q{SDL_DisplayID}, q{SDL_GetDisplayForPoint}, q{const(SDL_Point)* point}},
		{q{SDL_DisplayID}, q{SDL_GetDisplayForRect}, q{const(SDL_Rect)* rect}},
		{q{SDL_DisplayID}, q{SDL_GetDisplayForWindow}, q{SDL_Window* window}},
		{q{float}, q{SDL_GetWindowPixelDensity}, q{SDL_Window* window}},
		{q{float}, q{SDL_GetWindowDisplayScale}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowFullscreenMode}, q{SDL_Window* window, const(SDL_DisplayMode)* mode}},
		{q{const(SDL_DisplayMode)*}, q{SDL_GetWindowFullscreenMode}, q{SDL_Window* window}},
		{q{void*}, q{SDL_GetWindowICCProfile}, q{SDL_Window* window, size_t* size}},
		{q{SDL_PixelFormat}, q{SDL_GetWindowPixelFormat}, q{SDL_Window* window}},
		{q{SDL_Window**}, q{SDL_GetWindows}, q{int* count}},
		{q{SDL_Window*}, q{SDL_CreateWindow}, q{const(char)* title, int w, int h, SDL_WindowFlags_ flags}},
		{q{SDL_Window*}, q{SDL_CreatePopupWindow}, q{SDL_Window* parent, int offsetX, int offsetY, int w, int h, SDL_WindowFlags_ flags}},
		{q{SDL_Window*}, q{SDL_CreateWindowWithProperties}, q{SDL_PropertiesID props}},
		{q{SDL_WindowID}, q{SDL_GetWindowID}, q{SDL_Window* window}},
		{q{SDL_Window*}, q{SDL_GetWindowFromID}, q{SDL_WindowID id}},
		{q{SDL_Window*}, q{SDL_GetWindowParent}, q{SDL_Window* window}},
		{q{SDL_PropertiesID}, q{SDL_GetWindowProperties}, q{SDL_Window* window}},
		{q{SDL_WindowFlags}, q{SDL_GetWindowFlags}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowTitle}, q{SDL_Window* window, const(char)* title}},
		{q{const(char)*}, q{SDL_GetWindowTitle}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowIcon}, q{SDL_Window* window, SDL_Surface* icon}},
		{q{bool}, q{SDL_SetWindowPosition}, q{SDL_Window* window, int x, int y}},
		{q{bool}, q{SDL_GetWindowPosition}, q{SDL_Window* window, int* x, int* y}},
		{q{bool}, q{SDL_SetWindowSize}, q{SDL_Window* window, int w, int h}},
		{q{bool}, q{SDL_GetWindowSize}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_GetWindowSafeArea}, q{SDL_Window* window, SDL_Rect* rect}},
		{q{bool}, q{SDL_SetWindowAspectRatio}, q{SDL_Window* window, float minAspect, float maxAspect}},
		{q{bool}, q{SDL_GetWindowAspectRatio}, q{SDL_Window* window, float* minAspect, float* maxAspect}},
		{q{bool}, q{SDL_GetWindowBordersSize}, q{SDL_Window* window, int* top, int* left, int* bottom, int* right}},
		{q{bool}, q{SDL_GetWindowSizeInPixels}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_SetWindowMinimumSize}, q{SDL_Window* window, int minW, int minH}},
		{q{bool}, q{SDL_GetWindowMinimumSize}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_SetWindowMaximumSize}, q{SDL_Window* window, int maxW, int maxH}},
		{q{bool}, q{SDL_GetWindowMaximumSize}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_SetWindowBordered}, q{SDL_Window* window, bool bordered}},
		{q{bool}, q{SDL_SetWindowResizable}, q{SDL_Window* window, bool resizable}},
		{q{bool}, q{SDL_SetWindowAlwaysOnTop}, q{SDL_Window* window, bool onTop}},
		{q{bool}, q{SDL_ShowWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_HideWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_RaiseWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_MaximizeWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_MinimizeWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_RestoreWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowFullscreen}, q{SDL_Window* window, bool fullscreen}},
		{q{bool}, q{SDL_SyncWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_WindowHasSurface}, q{SDL_Window* window}},
		{q{SDL_Surface*}, q{SDL_GetWindowSurface}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowSurfaceVSync}, q{SDL_Window* window, int vsync}},
		{q{bool}, q{SDL_GetWindowSurfaceVSync}, q{SDL_Window* window, int* vsync}},
		{q{bool}, q{SDL_UpdateWindowSurface}, q{SDL_Window* window}},
		{q{bool}, q{SDL_UpdateWindowSurfaceRects}, q{SDL_Window* window, const(SDL_Rect)* rects, int numRects}},
		{q{bool}, q{SDL_DestroyWindowSurface}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowKeyboardGrab}, q{SDL_Window* window, bool grabbed}},
		{q{bool}, q{SDL_SetWindowMouseGrab}, q{SDL_Window* window, bool grabbed}},
		{q{bool}, q{SDL_GetWindowKeyboardGrab}, q{SDL_Window* window}},
		{q{bool}, q{SDL_GetWindowMouseGrab}, q{SDL_Window* window}},
		{q{SDL_Window*}, q{SDL_GetGrabbedWindow}, q{}},
		{q{bool}, q{SDL_SetWindowMouseRect}, q{SDL_Window* window, const(SDL_Rect)* rect}},
		{q{const(SDL_Rect)*}, q{SDL_GetWindowMouseRect}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowOpacity}, q{SDL_Window* window, float opacity}},
		{q{float}, q{SDL_GetWindowOpacity}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowParent}, q{SDL_Window* window, SDL_Window* parent}},
		{q{bool}, q{SDL_SetWindowModal}, q{SDL_Window* window, bool modal}},
		{q{bool}, q{SDL_SetWindowFocusable}, q{SDL_Window* window, bool focusable}},
		{q{bool}, q{SDL_ShowWindowSystemMenu}, q{SDL_Window* window, int x, int y}},
		{q{bool}, q{SDL_SetWindowHitTest}, q{SDL_Window* window, SDL_HitTest callback, void* callbackData}},
		{q{bool}, q{SDL_SetWindowShape}, q{SDL_Window* window, SDL_Surface* shape}},
		{q{bool}, q{SDL_FlashWindow}, q{SDL_Window* window, SDL_FlashOperation operation}},
		{q{void}, q{SDL_DestroyWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_ScreenSaverEnabled}, q{}},
		{q{bool}, q{SDL_EnableScreenSaver}, q{}},
		{q{bool}, q{SDL_DisableScreenSaver}, q{}},
		{q{bool}, q{SDL_GL_LoadLibrary}, q{const(char)* path}},
		{q{SDL_FunctionPointer}, q{SDL_GL_GetProcAddress}, q{const(char)* proc}},
		{q{SDL_FunctionPointer}, q{SDL_EGL_GetProcAddress}, q{const(char)* proc}},
		{q{void}, q{SDL_GL_UnloadLibrary}, q{}},
		{q{bool}, q{SDL_GL_ExtensionSupported}, q{const(char)* extension}},
		{q{void}, q{SDL_GL_ResetAttributes}, q{}},
		{q{bool}, q{SDL_GL_SetAttribute}, q{SDL_GLattr attr, int value}},
		{q{bool}, q{SDL_GL_GetAttribute}, q{SDL_GLattr attr, int* value}},
		{q{SDL_GLContext}, q{SDL_GL_CreateContext}, q{SDL_Window* window}},
		{q{bool}, q{SDL_GL_MakeCurrent}, q{SDL_Window* window, SDL_GLContext context}},
		{q{SDL_Window*}, q{SDL_GL_GetCurrentWindow}, q{}},
		{q{SDL_GLContext}, q{SDL_GL_GetCurrentContext}, q{}},
		{q{SDL_EGLDisplay}, q{SDL_EGL_GetCurrentDisplay}, q{}},
		{q{SDL_EGLConfig}, q{SDL_EGL_GetCurrentConfig}, q{}},
		{q{SDL_EGLSurface}, q{SDL_EGL_GetWindowSurface}, q{SDL_Window* window}},
		{q{void}, q{SDL_EGL_SetAttributeCallbacks}, q{SDL_EGLAttribArrayCallback platformAttribCallback, SDL_EGLIntArrayCallback surfaceAttribCallback, SDL_EGLIntArrayCallback contextAttribCallback, void* userData}},
		{q{bool}, q{SDL_GL_SetSwapInterval}, q{int interval}},
		{q{bool}, q{SDL_GL_GetSwapInterval}, q{int* interval}},
		{q{bool}, q{SDL_GL_SwapWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_GL_DestroyContext}, q{SDL_GLContext context}},
	];
	return ret;
}()));
