# `glut setup` - Environment Setup

## Synopsis

```bash
glut setup
```

## Description

Installs and configures FreeGLUT for your platform. This is typically run automatically during CLI installation, but can be run manually if needed.

## Platform-Specific Behavior

### Windows

**What it does:**
1. Downloads precompiled FreeGLUT binaries
2. Extracts to `C:\freeglut\`
3. Organizes into `include/`, `lib/`, and `bin/` directories

**Installation paths:**
- Headers: `C:\freeglut\include\GL\glut.h`
- Libraries: `C:\freeglut\lib\libfreeglut.a`
- DLL: `C:\freeglut\bin\freeglut.dll`

**Requirements:**
- Administrator privileges (recommended)
- Internet connection

### macOS

**What it does:**
1. Checks for Homebrew
2. Runs `brew install freeglut`

**Requirements:**
- Homebrew installed
- Xcode Command Line Tools

**Manual installation:**
```bash
brew install freeglut
```

### Linux

**What it does:**
1. Runs `sudo apt-get update`
2. Installs `freeglut3-dev` package

**Requirements:**
- Debian/Ubuntu-based system
- sudo privileges

**Manual installation:**
```bash
# Ubuntu/Debian
sudo apt-get install freeglut3-dev

# Fedora
sudo dnf install freeglut-devel

# Arch
sudo pacman -S freeglut
```

## Example

```bash
glut setup
```

Output (Windows):
```
Setting up FreeGLUT 3.8.0 for win32...
Target directory: C:\freeglut
Downloading precompiled FreeGLUT binaries...
Extracting to C:\freeglut...
FreeGLUT setup completed on Windows.
Libraries installed to C:\freeglut\lib
Headers installed to C:\freeglut\include
```

## Troubleshooting

### Windows: Permission Denied
Run PowerShell as Administrator:
```powershell
Start-Process powershell -Verb RunAs
glut setup
```

### macOS: Homebrew Not Found
Install Homebrew first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Linux: apt-get Fails
Try manual installation:
```bash
sudo apt-get update
sudo apt-get install freeglut3-dev
```

## Verifying Installation

### Windows
```powershell
Test-Path C:\freeglut\include\GL\glut.h
Test-Path C:\freeglut\lib\libfreeglut.a
Test-Path C:\freeglut\bin\freeglut.dll
```

### macOS/Linux
```bash
pkg-config --modversion freeglut
```

## See Also

- [`glut create`](create.md) - Create new project
- [`glut build`](build.md) - Build project
