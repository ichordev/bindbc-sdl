
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlmutex;

import bindbc.sdl.config;

enum SDL_MUTEX_TIMEOUT = 1;
enum SDL_MUTEX_MAXWAIT = uint.max;

struct SDL_mutex;
struct SDL_sem;
struct SDL_cond;


mixin(makeFnBinds!(
    [q{SDL_mutex*}, q{SDL_CreateMutex}, q{}],
    [q{int}, q{SDL_LockMutex}, q{SDL_mutex* mutex}],
    [q{int}, q{SDL_TryLockMutex}, q{SDL_mutex* mutex}],
    [q{int}, q{SDL_UnlockMutex}, q{SDL_mutex* mutex}],
    [q{void}, q{SDL_DestroyMutex}, q{SDL_mutex* mutex}],

    [q{SDL_sem*}, q{SDL_CreateSemaphore}, q{uint initial_value}],
    [q{void}, q{SDL_DestroySemaphore}, q{SDL_sem* sem}],
    [q{int}, q{SDL_SemWait}, q{SDL_sem* sem}],
    [q{int}, q{SDL_SemTryWait}, q{SDL_sem* sem}],
    [q{int}, q{SDL_SemWaitTimeout}, q{SDL_sem* sem, uint ms}],
    [q{int}, q{SDL_SemPost}, q{SDL_sem* sem}],
    [q{uint}, q{SDL_SemValue}, q{SDL_sem* sem}],

    [q{SDL_cond*}, q{SDL_CreateCond}, q{}],
    [q{void}, q{SDL_DestroyCond}, q{SDL_cond* cond}],
    [q{int}, q{SDL_CondSignal}, q{SDL_cond* cond}],
    [q{int}, q{SDL_CondBroadcast}, q{SDL_cond* cond}],
    [q{int}, q{SDL_CondWait}, q{SDL_cond* cond,SDL_mutex*}],
    [q{int}, q{SDL_CondWaitTimeout}, q{SDL_cond* cond, SDL_mutex* mutex, uint ms}],
));
