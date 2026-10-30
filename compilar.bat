@echo off
setlocal
rem ===== Compilador de Sonic 2 para navegador =====
rem Asume que Emscripten esta en C:\Users\shit3\emsdk
call C:\Users\shit3\emsdk\emsdk_env.bat
cd /d "%~dp0"

if not exist Data.rsdk (
  echo.
  echo ERROR: no encuentro Data.rsdk en esta carpeta: %~dp0
  echo Copialo aca y volve a ejecutar este archivo.
  pause
  exit /b 1
)

if not exist wasm mkdir wasm

echo.
echo Compilando... la primera vez tarda unos minutos.
echo.

call em++ -std=c++17 -O2 -ftrivial-auto-var-init=zero -fno-strict-aliasing -fwrapv RSDKv4/Animation.cpp RSDKv4/Audio.cpp RSDKv4/Collision.cpp RSDKv4/Debug.cpp RSDKv4/Drawing.cpp RSDKv4/Ini.cpp RSDKv4/Input.cpp RSDKv4/main.cpp RSDKv4/Math.cpp RSDKv4/Object.cpp RSDKv4/Palette.cpp RSDKv4/PauseMenu.cpp RSDKv4/Reader.cpp RSDKv4/RetroEngine.cpp RSDKv4/RetroGameLoop.cpp RSDKv4/Scene.cpp RSDKv4/Scene3D.cpp RSDKv4/Script.cpp RSDKv4/Sprite.cpp RSDKv4/String.cpp RSDKv4/Text.cpp RSDKv4/Userdata.cpp -o wasm/index.js -lm --bind -s USE_SDL=2 -s USE_SDL_IMAGE=2 -s SDL2_IMAGE_FORMATS=["png"] -s USE_OGG=1 -s USE_VORBIS=1 -s TOTAL_MEMORY=60MB -s ALLOW_MEMORY_GROWTH=1 -s FORCE_FILESYSTEM=1 -s EXPORTED_RUNTIME_METHODS=FS --preload-file Data.rsdk

if errorlevel 1 (
  echo.
  echo === HUBO UN ERROR DE COMPILACION. Copia las ultimas lineas rojas y mandalas. ===
  pause
  exit /b 1
)

copy /Y "web\index.html" "wasm\index.html" >nul

echo.
echo === LISTO ===
echo Para probar: abri una ventana de cmd, escribi:
echo    cd /d "%~dp0wasm"
echo    python -m http.server 8000
echo y entra a http://localhost:8000 (con Ctrl+F5)
echo.
pause
