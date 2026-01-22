@echo off
REM FreeGLUT Project Build Script for Windows
REM This script compiles the project and copies necessary DLLs

echo.
echo ========================================
echo   Building FreeGLUT Project (Windows)
echo ========================================
echo.

REM Create build directory if it doesn't exist
if not exist build (
    echo Creating build directory...
    mkdir build
)

REM Compile all .cpp files
echo Compiling source files...
g++ *.cpp -o build\app.exe -I"C:\freeglut\include" -L"C:\freeglut\lib" -lfreeglut -lopengl32 -lglu32 -g

REM Check if compilation was successful
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Build completed successfully!
    echo Executable: build\app.exe
    
    REM Copy FreeGLUT DLL if it exists
    if exist "C:\freeglut\bin\freeglut.dll" (
        copy "C:\freeglut\bin\freeglut.dll" build\freeglut.dll >nul 2>&1
        if %errorlevel% equ 0 (
            echo FreeGLUT DLL copied to build directory.
        )
    ) else (
        echo WARNING: FreeGLUT DLL not found at C:\freeglut\bin\freeglut.dll
        echo The application may not run without this DLL.
    )
    
    echo.
    echo ========================================
    echo   Build Complete!
    echo ========================================
    echo.
    exit /b 0
) else (
    echo.
    echo [ERROR] Build failed!
    echo Please check the error messages above.
    echo.
    echo ========================================
    echo   Build Failed
    echo ========================================
    echo.
    exit /b 1
)
