@echo off
echo Installing CLI dependencies...
cd setup
call npm install

echo Linking 'glut' command globally...
call npm install -g .

echo.
echo 🚀 Environment Setup: Running 'glut setup'...
call glut setup

echo.
echo ✨ Success! The 'glut' command is now registered and ready.
echo You can now create projects from anywhere:
echo   glut create <ProjectName>
cd ..
