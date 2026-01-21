# FreeGLUT Project Scaffolder

A comprehensive tool to setup FreeGLUT and scaffold new OpenGL/C++ projects with VS Code support on Windows, macOS, and Linux.

## Quick Start (All Platforms)

Run these three commands to get started:

1. **Setup the CLI:**
   ```bash
   # On macOS/Linux
   chmod +x setup.sh && ./setup.sh
   # On Windows (Admin recommended)
   .\setup.bat
   ```

2. **Setup FreeGLUT Environment:**
   ```bash
   glut setup
   ```

3. **Create Your First Project:**
   ```bash
   glut create MyProject
   ```

## Features

- **Cross-Platform**: Works on macOS (Silicon/Intel), Windows, and Linux.
- **Auto-Environment Setup**: Automatically downloads FreeGLUT or guides you through system-level installation.
- **VS Code Integration**: Pre-configured `.vscode` settings for building and debugging (F5 support).
- **Multi-File Support**: Automatically compiles all `.cpp` files in your project directory.

## Project Structure

When you create a project, it will have the following structure:
- `main.cpp`: Your entry point.
- `.vscode/`: Tasks and launch configurations for VS Code.

## How to Build

Simply open the project in VS Code and press **F5**. This will automatically compile all `.cpp` files and start debugging.
