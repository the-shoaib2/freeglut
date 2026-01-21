@echo off
echo.
echo ========================================
echo   FreeGLUT CLI Installer (Windows)
echo ========================================
echo.

REM Create temporary directory
set TEMP_DIR=%TEMP%\freeglut-setup-%RANDOM%
mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

echo [1/3] Downloading FreeGLUT CLI from GitHub...
curl -fsSL https://github.com/the-shoaib2/freeglut/archive/refs/heads/main.zip -o freeglut.zip

echo [2/3] Extracting files...
tar -xf freeglut.zip
cd freeglut-main\setup

echo [3/3] Installing 'glut' command globally...
call npm install -g .

echo.
echo ========================================
echo   Running FreeGLUT Environment Setup
echo ========================================
echo.
call glut setup

echo.
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo ✨ The 'glut' command is now available globally.
echo.
echo Create your first project:
echo   glut create MyProject
echo.
echo Cleaning up temporary files...
cd /d %TEMP%
rmdir /s /q "%TEMP_DIR%"

echo.
echo Done! You can close this window.
pause
