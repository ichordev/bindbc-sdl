
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl;

public import bindbc.sdl.config,
              bindbc.sdl.bind;

version(BindSDL_Static) {}
else public import bindbc.sdl.dynload;

static if(bindSDLImage) public import bindbc.sdl.image;
static if(bindSDLMixer) public import bindbc.sdl.mixer;
static if(bindSDLNet) public import bindbc.sdl.net;
static if(bindSDLTTF) public import bindbc.sdl.ttf;

