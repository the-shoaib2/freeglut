# OpenGL GLUT Cross-Platform Template

A clean, production-ready template for OpenGL and GLUT applications that works seamlessly on **Windows**, **Linux**, and **macOS**.

## Command List

### **1. Setup New Project**
Create a new FreeGLUT project from the root folder:
- **Mac / Linux**: `./setup.sh MyNewApp`
- **Windows**: `setup.bat MyNewApp`

### **2. Build Project**
Inside your new project directory:
- **Mac / Linux**: `./build.sh`
- **Windows**: `build.bat`

### **3. Run Application**
After a successful build:
- **Mac / Linux**: `./build/app`
alias create-gl-app='/path/to/setup.sh'

### macOS
- **Xcode Command Line Tools**: `xcode-select --install`
- (Optional) **XQuartz**: If you specifically want to use FreeGLUT via X11. However, this template defaults to the native Apple GLUT framework.

### Linux (Ubuntu/Debian)
- `sudo apt-get update`
- `sudo apt-get install build-essential freeglut3-dev libglew-dev`

### Windows
- **MinGW-w64**: Installed via MSYS2 or standalone.
- **FreeGLUT**: Place `freeglut.dll` in the project root or system path.

## How to Build & Run

### Using VS Code
1. Open this folder in VS Code.
2. Press `F5` to build and start debugging.

### Using CLI (macOS/Linux)
```bash
chmod +x build.sh
./build.sh
./build/app
```

### Using CLI (Windows)
```cmd
build.bat
build\app.exe
```

## Structure
- `main.cpp`: Your source code with cross-platform header logic.
- `.vscode/`: Configuration for building and debugging.
- `.gitignore`: Excludes build artifacts and local settings.
- `build/`: Destination for compiled binaries.

## Credits
Based on the FreeGLUT project: [https://github.com/freeglut/freeglut](https://github.com/freeglut/freeglut)
