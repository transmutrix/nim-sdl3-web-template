#[
  To run native:
    nim r src/game

  To build web:
    nim c -d:emscripten src/game

  To run web:
    emrun build/web/game.html
    emrun build/web/game.html --browser=chrome
    emrun build/web/game.html --no_browser
]#

# if not defined(emscripten):
#   mkdir "build/native"

if defined(emscripten):
  mkdir "build/web"

  # For debugging builds:
  # --nimcache:tmp # Store intermediate files close by in the ./tmp dir.
  # --listCmd # List what commands we are running so that we can debug them.

  --os:linux # Emscripten pretends to be linux.
  --cpu:wasm32 # Emscripten is 32bits.
  --cc:clang # Emscripten is very close to clang, so we'll replace it.

  when defined(windows):
    --clang.exe:emcc.bat  # Replace C
    --clang.linkerexe:emcc.bat # Replace C linker
    --clang.cpp.exe:emcc.bat # Replace C++
    --clang.cpp.linkerexe:emcc.bat # Replace C++ linker.
  else:
    --clang.exe:emcc  # Replace C
    --clang.linkerexe:emcc # Replace C linker
    --clang.cpp.exe:emcc # Replace C++
    --clang.cpp.linkerexe:emcc # Replace C++ linker.

  --threads:off # threads:on fails for SDL_atomic.
  # when compileOption("threads"):
  #   # We can have a pool size to populate and be available on page run
  #   # --passL:"-sPTHREAD_POOL_SIZE=2"
  #   discard

  --gc:arc # GC:arc is friendlier with crazy platforms.
  --exceptions:goto # Goto exceptions are friendlier with crazy platforms.
  --define:noSignalHandler # Unsupported.
  --forceBuild # Rebuild every file from scratch.
  --define:release # Do release optimizations on our code.

  switch("passL", "-o build/web/game.html")
  switch("passL", "--shell-file ./emcc/shell_minimal.html")
  switch("passL", "-s ALLOW_MEMORY_GROWTH=1 -s MAXIMUM_MEMORY=1gb")
  switch("passL", "-s WASM")
  switch("passL", "-L./emcc/ -lSDL3")
