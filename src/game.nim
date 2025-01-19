
#
# This example code creates an SDL window and renderer, and then clears the
# window to a different color every frame, so you'll effectively get a window
# that's smoothly fading between colors.
#
# This code is public domain. Feel free to use it for any purpose!
#
# Write ya self a game in here!
#

import sdl3

var
  window: SDL_Window
  renderer: SDL_Renderer
  quit: bool

discard SDL_SetAppMetadata("Untitled", "1.0", "com.you.your-game")

if not SDL_Init(SDL_INIT_VIDEO):
  echo "Couldn't initialize SDL: ", SDL_GetError()
  quit(QuitFailure)

if not SDL_CreateWindowAndRenderer("examples/renderer/clear", 640, 480, 0, window, renderer):
  echo "Couldn't create window/renderer: ", SDL_GetError()
  quit(QuitFailure)

# Main loop.
proc mainloop*() {.cdecl.} =
  var event = SDL_Event()
  while SDL_PollEvent(event):
    if event.type == SDL_EVENT_QUIT:
      quit = true
    if event.type == SDL_EVENT_KEY_DOWN:
      if event.key.key == SDLK_SPACE:
        echo "stick a breakpoint here"


  let
    now = SDL_GetTicks().float / 1000
    red: float = 0.5 + 0.5*SDL_sin(now)
    green: float = 0.5 + 0.5*SDL_sin(now + SDL_PI_D * 2/3)
    blue: float = 0.5 + 0.5*SDL_sin(now + SDL_PI_D * 4/3)
  SDL_SetRenderDrawColorFloat(renderer, red, green, blue, 1)
  SDL_RenderClear(renderer)
  SDL_RenderPresent(renderer)

# Startup
when defined(emscripten):
  emscripten_set_main_loop(mainloop, 0, true)
else:
  while not quit:  mainloop()

# Shutdown
SDL_Quit()
