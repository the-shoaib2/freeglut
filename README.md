# FreeGLUT Project Scaffolder

A comprehensive tool to setup FreeGLUT and scaffold new OpenGL/C++ projects with VS Code support on Windows, macOS, and Linux.

## Quick Start (One-Command Installation)

Install the FreeGLUT CLI tool directly without cloning the repository:

### One-Command Installation (Recommended)

Run this in your terminal to download and install automatically:

#### Windows (PowerShell as Admin)
```powershell
irm https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.ps1 | iex
```

#### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.sh | bash
```



---

**After installation, create your first project:**

```bash
glut create MyProject
```

## Features

- **Framework Commands**:
  - `glut watch`: **Hot Reloading** for C++! Rebuilds and restarts your app on every save.
  - `glut add <name>`: Instantly generate C++ header and source pairs.
  - `glut clean`: Quickly wipe build artifacts.
  - `glut status`: Get a snapshot of your project and source files.
- **Production Performance**:
  - `glut build --release`: Peak optimization with `-O3` and symbol stripping.
  - **Modern C++**: Projects use **C++17** by default for professional performance and features.
- **Auto-Environment Setup**: Automatically downloads FreeGLUT or guides you through system-level installation.
- **Smart Scaffolding**: 
  - Automatically initializes a **Git repository**.
  - Injects your project name into the code (e.g., as the window title).
- **CLI Lifecycle Support**:
  - `glut build`: Compile your project from the terminal.
  - `glut run`: Build and execute your project instantly.
- **VS Code Integration**: Pre-configured `.vscode` settings for building and debugging (F5 support).

## Manual Build & Run

While VS Code is recommended, you can manage your project entirely from the CLI:
```bash
glut watch          # Hot-reload mode (rebuild on save)
glut build --release # Build for production (-O3)
glut run            # Debug build and execute
glut add Player     # Generate Player.h and Player.cpp
glut clean          # Clear build folder
glut status         # Show project info
glut help           # Show command help
glut version        # Show CLI version
```
