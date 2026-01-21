@echo off
set PROJECT_NAME=%1
if "%PROJECT_NAME%"=="" set PROJECT_NAME=Project

set TEMPLATE_DIR=%~dp0setup\template

if exist "%PROJECT_NAME%" (
    echo Error: Directory "%PROJECT_NAME%" already exists.
    exit /b 1
)

echo Creating project: %PROJECT_NAME%...
xcopy /E /I /Y "%TEMPLATE_DIR%" "%PROJECT_NAME%" >nul

cd "%PROJECT_NAME%"

echo Setting up dependencies...
if not exist deps mkdir deps
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/freeglut/freeglut/releases/download/v3.8.0/freeglut-3.8.0.tar.gz' -OutFile 'deps\freeglut.tar.gz'"

echo Extracting FreeGLUT...
powershell -Command "tar -xzf deps\freeglut.tar.gz -C deps\"
del deps\freeglut.tar.gz

echo Success! Project %PROJECT_NAME% created.
echo To start:
echo   cd %PROJECT_NAME%
echo   code .
