# Troubleshooting

Common issues and solutions for the FreeGLUT scaffolder.

## Installation Issues

### `npm is not recognized`

**Cause:** Node.js not installed or not in PATH.

**Solution:**
```powershell
# Windows
winget install OpenJS.NodeJS.LTS

# macOS
brew install node

# Linux
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

After installation, restart your terminal.

### `glut: command not found`

**Cause:** CLI not installed globally or PATH not updated.

**Solution:**
```bash
npm install -g glut
# or
npm install -g /path/to/glut-1.2.0.tgz
```

Restart terminal after installation.

### Permission Denied (Windows)

**Cause:** Not running as Administrator.

**Solution:**
1. Right-click PowerShell
2. Select "Run as Administrator"
3. Run command again

### Permission Denied (macOS/Linux)

**Cause:** Insufficient permissions for global npm install.

**Solution:**
```bash
sudo npm install -g glut
```

## Build Issues

### `g++: command not found`

**Windows:**
```powershell
# Install MinGW
# Download from mingw.org
# Add C:\MinGW\bin to PATH
```

**macOS:**
```bash
xcode-select --install
```

**Linux:**
```bash
sudo apt-get install build-essential
```

### `GL/glut.h: No such file or directory`

**Cause:** FreeGLUT not installed.

**Solution:**
```bash
glut setup
```

Or manually:

**Windows:**
- Download from [transmissionzero.co.uk](https://www.transmissionzero.co.uk/software/freeglut-devel/)
- Extract to `C:\freeglut`

**macOS:**
```bash
brew install freeglut
```

**Linux:**
```bash
sudo apt-get install freeglut3-dev
```

### Build Succeeds but No Executable

**Check build directory:**
```bash
ls build/
# or
dir build
```

**Clean and rebuild:**
```bash
glut clean
glut build
```

### Linker Errors

**Cause:** Missing or incorrect library paths.

**Windows Solution:**
```bash
# Verify FreeGLUT installation
Test-Path C:\freeglut\lib\libfreeglut.a
Test-Path C:\freeglut\include\GL\glut.h
```

**macOS/Linux Solution:**
```bash
# Verify FreeGLUT installation
pkg-config --modversion freeglut
```

## Runtime Issues

### `freeglut.dll not found` (Windows)

**Cause:** DLL not in build directory or PATH.

**Solution:**
```bash
glut build
# DLL should be copied automatically
```

**Manual fix:**
```powershell
Copy-Item C:\freeglut\bin\freeglut.dll build\freeglut.dll
```

### Application Crashes on Startup

**Check:**
1. FreeGLUT properly installed
2. OpenGL drivers up to date
3. No syntax errors in code

**Debug:**
```bash
glut build
# Run with debugger
code .
# Press F5
```

### Black Window / Nothing Renders

**Common causes:**
- Display callback not set
- `glutMainLoop()` not called
- OpenGL initialization errors

**Check main.cpp:**
```cpp
glutDisplayFunc(display);  // Required
glutMainLoop();            // Required
```

### Window Doesn't Respond

**Cause:** Event loop not processing.

**Solution:** Ensure `glutMainLoop()` is called and display callback is set.

## VS Code Issues

### F5 Doesn't Build

**Cause:** Build task not configured.

**Solution:**
```bash
# Recreate project
glut create MyProject
cd MyProject
code .
```

### Debugger Won't Attach

**Windows:**
- Verify `gdb.exe` is in PATH
- Check `launch.json` has correct `miDebuggerPath`

**macOS:**
- Ensure Xcode Command Line Tools installed
- Use `lldb` debugger

**Linux:**
- Install GDB: `sudo apt-get install gdb`

### IntelliSense Errors

**Cause:** Include paths not configured.

**Solution:**
Check `.vscode/c_cpp_properties.json`:

**Windows:**
```json
"includePath": [
    "${workspaceFolder}/**",
    "C:/freeglut/include"
]
```

**macOS:**
```json
"includePath": [
    "${workspaceFolder}/**",
    "/usr/local/include"
]
```

## Component Generation Issues

### `glut add` Fails

**Cause:** Not in project directory.

**Solution:**
```bash
cd /path/to/your/project
glut add ComponentName
```

### Component Not Compiling

**Cause:** Syntax errors or missing includes.

**Solution:**
```bash
# Check component files
# Fix syntax errors
glut build
```

## Platform-Specific Issues

### Windows: PowerShell Execution Policy

**Error:** "cannot be loaded because running scripts is disabled"

**Solution:**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### macOS: "GLUT is deprecated"

**Expected:** This is a warning, not an error.

**Suppress:**
The template already includes `-DGL_SILENCE_DEPRECATION` flag.

### Linux: Display Not Found

**Cause:** No X11 display available.

**Solution:**
```bash
export DISPLAY=:0
```

Or run with X server active.

## Getting Help

If your issue isn't listed:

1. Check [GitHub Issues](https://github.com/the-shoaib2/freeglut/issues)
2. Run `glut status` to verify project setup
3. Check build output for specific errors
4. Create a new issue with:
   - Platform and version
   - Node.js version (`node -v`)
   - Compiler version (`g++ --version`)
   - Full error output

## See Also

- [Installation Guide](installation.md)
- [Command Reference](commands/)
- [Folder Structure](folder-structure.md)
