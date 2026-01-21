@echo off
if not exist build\Debug mkdir build\Debug

g++ main.cpp -o build\app.exe -lfreeglut -lopengl32 -lglu32 -g

if %errorlevel% equ 0 (
    echo Build successful: build\app.exe
    copy build\app.exe build\Debug\outDebug.exe >nul
) else (
    echo Build failed
)
