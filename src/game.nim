
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
  texture: SDL_Texture
  quit: bool

discard SDL_SetAppMetadata("Untitled", "1.0", "com.you.your-game")

if not SDL_Init(SDL_INIT_VIDEO):
  echo "Couldn't initialize SDL: ", SDL_GetError()
  quit(QuitFailure)

if not SDL_CreateWindowAndRenderer("urgamehere", 640, 480, 0, window, renderer):
  echo "Couldn't create window/renderer: ", SDL_GetError()
  quit(QuitFailure)

block:
  var surface = SDL_LoadBMP("assets/sample.bmp")
  if surface == nil:
    echo "Couldn't load bmp: ", SDL_GetError()
    quit(QuitFailure)
  texture = SDL_CreateTextureFromSurface(renderer, surface)
  if texture == nil:
    echo "Couldn't create texture: ", SDL_GetError()
    quit(QuitFailure)
  SDL_DestroySurface(surface)


# Main loop.
proc mainloop*() {.cdecl.} =
  var event = SDL_Event()
  while SDL_PollEvent(event):
    if event.type == SDL_EVENT_QUIT:
      quit = true

  let
    now = SDL_GetTicks().float / 1000
    red: float = 0.5 + 0.5*SDL_sin(now)
    green: float = 0.5 + 0.5*SDL_sin(now + SDL_PI_D * 2/3)
    blue: float = 0.5 + 0.5*SDL_sin(now + SDL_PI_D * 4/3)
  SDL_SetRenderDrawColorFloat(renderer, red, green, blue, 1)
  SDL_RenderClear(renderer)

  var w,h: cfloat
  discard SDL_GetTextureSize(texture, w, h)
  let
    rw = 440.0
    rh = 440*(h/w)
    r = SDL_FRect(x: (640-rw)/2, y: (480-rh)/2, w: rw, h: rh)
  SDL_RenderTexture(renderer, texture, nil, r.addr )

  SDL_RenderPresent(renderer)

# Startup
when defined(emscripten):
  emscripten_set_main_loop(mainloop, 0, true)
else:
  while not quit:  mainloop()

# Shutdown
SDL_Quit()
