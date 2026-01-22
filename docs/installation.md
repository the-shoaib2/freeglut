# Installation Guide

## Quick Installation (Recommended)

### Windows

**PowerShell (as Administrator):**
```powershell
irm https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.ps1 | iex
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.sh | bash
```

## Manual Installation

### Prerequisites

**All Platforms:**
- Node.js 16.0 or higher ([nodejs.org](https://nodejs.org/))

**Platform-Specific:**

**Windows:**
- MinGW GCC compiler
- Administrator privileges (for FreeGLUT installation)

**macOS:**
- Xcode Command Line Tools
- Homebrew

**Linux:**
- GCC/G++ compiler
- Build essentials

### Step-by-Step Installation

#### 1. Clone Repository

```bash
git clone https://github.com/the-shoaib2/freeglut.git
cd freeglut/setup
```

#### 2. Install Dependencies

```bash
npm install
```

#### 3. Create NPM Package

```bash
npm pack
```

#### 4. Install Globally

```bash
npm install -g glut-1.2.0.tgz
```

#### 5. Setup FreeGLUT

```bash
glut setup
```

### Verify Installation

```bash
glut version
```

Expected output:
```
glut CLI v1.2.0
```

## Platform-Specific Setup

### Windows

**Install MinGW:**
1. Download from [mingw.org](http://www.mingw.org/)
2. Install with C++ compiler
3. Add to PATH: `C:\MinGW\bin`

**Verify:**
```powershell
g++ --version
```

### macOS

**Install Homebrew:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Install Xcode Tools:**
```bash
xcode-select --install
```

### Linux (Ubuntu/Debian)

**Install Build Tools:**
```bash
sudo apt-get update
sudo apt-get install build-essential
```

## Troubleshooting Installation

### Node.js Not Found

**Windows:**
```powershell
winget install OpenJS.NodeJS.LTS
```

**macOS:**
```bash
brew install node
```

**Linux:**
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Permission Denied (Windows)

Run PowerShell as Administrator:
1. Right-click PowerShell
2. Select "Run as Administrator"
3. Run installation command again

### npm Command Not Found

Restart terminal after Node.js installation to refresh PATH.

### FreeGLUT Setup Fails

**Windows:**
- Check internet connection
- Run as Administrator
- Manually download from [transmissionzero.co.uk](https://www.transmissionzero.co.uk/software/freeglut-devel/)

**macOS:**
```bash
brew install freeglut
```

**Linux:**
```bash
sudo apt-get install freeglut3-dev
```

## Updating

```bash
npm update -g glut
```

## Uninstalling

```bash
npm uninstall -g glut
```

**Remove FreeGLUT (Windows):**
```powershell
Remove-Item -Recurse -Force C:\freeglut
```

## See Also

- [Command Reference](commands/)
- [Troubleshooting](troubleshooting.md)
- [Folder Structure](folder-structure.md)
