@echo off
echo Installing CLI dependencies...
cd setup
call npm install

echo Linking 'glut' command globally...
call npm install -g .

echo.
echo Success! The 'glut' command is now available.
echo Next steps:
echo   1. Run 'glut setup' to configure your environment.
echo   2. Run 'glut create <ProjectName>' to start a new project.
cd ..
