# Cross-Platform Testing for FreeGLUT Scaffolder

This directory contains test projects and scripts for validating the FreeGLUT project scaffolder across different platforms.

## Directory Structure

```
tests/
├── windows/          # Windows-specific tests
├── macos/            # macOS-specific tests
├── linux/            # Linux-specific tests
└── README.md         # This file
```

## Testing Workflow

### 1. Windows Testing

**Prerequisites:**
- Windows 10/11
- MinGW GCC installed
- Node.js installed
- FreeGLUT installed at `C:\freeglut`

**Test Commands:**
```powershell
cd tests/windows
node ../../setup/index.js create WindowsTestProject
cd WindowsTestProject

# Test CLI build
node ../../../setup/index.js build

# Test manual build
.\build.bat

# Test VS Code (open in VS Code and press F5)
code .
```

**Expected Results:**
- ✅ Project creates successfully
- ✅ Build completes without errors
- ✅ `build/app.exe` and `build/freeglut.dll` are created
- ✅ Application runs and displays OpenGL window
- ✅ VS Code F5 debugging works

---

### 2. macOS Testing

**Prerequisites:**
- macOS 10.15+
- Xcode Command Line Tools
- Homebrew
- FreeGLUT (`brew install freeglut`)

**Test Commands:**
```bash
cd tests/macos
node ../../setup/index.js create MacTestProject
cd MacTestProject

# Test CLI build
node ../../../setup/index.js build

# Test VS Code (open in VS Code and press F5)
code .
```

**Expected Results:**
- ✅ Project creates successfully
- ✅ Build uses clang++ with GLUT framework
- ✅ `build/app` executable is created
- ✅ Application runs without framework errors
- ✅ VS Code F5 debugging works

---

### 3. Linux Testing

**Prerequisites:**
- Ubuntu 20.04+ or similar
- GCC/G++ installed
- FreeGLUT development package (`sudo apt-get install freeglut3-dev`)

**Test Commands:**
```bash
cd tests/linux
node ../../setup/index.js create LinuxTestProject
cd LinuxTestProject

# Test CLI build
node ../../../setup/index.js build

# Test VS Code (open in VS Code and press F5)
code .
```

**Expected Results:**
- ✅ Project creates successfully
- ✅ Build uses g++ with GL/GLU libraries
- ✅ `build/app` executable is created
- ✅ Application runs with proper X11 display
- ✅ VS Code F5 debugging works

---

## Test Checklist

### Core Functionality
- [ ] `glut create <project>` - Project scaffolding
- [ ] `glut build` - Debug build
- [ ] `glut build --release` - Release build
- [ ] `glut run` - Build and execute
- [ ] `glut watch` - Hot reload mode
- [ ] `glut add <component>` - Component generation
- [ ] `glut clean` - Cleanup
- [ ] `glut status` - Project info

### VS Code Integration
- [ ] F5 builds project
- [ ] F5 launches debugger
- [ ] Breakpoints work
- [ ] IntelliSense works

### Application Behavior
- [ ] Window displays correctly
- [ ] 6 shapes render (3 solid, 3 wireframe)
- [ ] Shapes rotate smoothly
- [ ] '+' key increases detail
- [ ] '-' key decreases detail
- [ ] 'q' or ESC quits

---

## Automated Testing Script

### Windows (PowerShell)
```powershell
# Run from tests/windows directory
$ErrorActionPreference = "Stop"

Write-Host "Creating test project..." -ForegroundColor Cyan
node ../../setup/index.js create AutoTestWin
cd AutoTestWin

Write-Host "Testing build..." -ForegroundColor Cyan
node ../../../setup/index.js build

if (Test-Path "build/app.exe") {
    Write-Host "✅ Build successful!" -ForegroundColor Green
} else {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

if (Test-Path "build/freeglut.dll") {
    Write-Host "✅ DLL copied!" -ForegroundColor Green
} else {
    Write-Host "❌ DLL missing!" -ForegroundColor Red
    exit 1
}

Write-Host "All tests passed!" -ForegroundColor Green
```

### macOS/Linux (Bash)
```bash
#!/bin/bash
set -e

echo "Creating test project..."
node ../../setup/index.js create AutoTestUnix
cd AutoTestUnix

echo "Testing build..."
node ../../../setup/index.js build

if [ -f "build/app" ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed!"
    exit 1
fi

echo "All tests passed!"
```

---

## Cleanup

After testing, remove test projects:

**Windows:**
```powershell
Remove-Item -Recurse -Force tests\windows\*TestProject
```

**macOS/Linux:**
```bash
rm -rf tests/macos/*TestProject
rm -rf tests/linux/*TestProject
```

---

## Reporting Issues

If tests fail, please report with:
1. Platform and version (e.g., Windows 11, macOS 14.2, Ubuntu 22.04)
2. Node.js version (`node -v`)
3. Compiler version (`g++ --version` or `clang++ --version`)
4. Full error output
5. Contents of `glut.json` in the test project

---

## CI/CD Integration

These tests can be integrated into GitHub Actions or other CI/CD pipelines. See `.github/workflows/` for examples.
