# FreeGLUT Project Scaffolder

A production-grade CLI tool to scaffold cross-platform OpenGL/C++ projects with FreeGLUT. Features hot reloading, VS Code integration, and automated environment setup for Windows, macOS, and Linux.

[![npm version](https://img.shields.io/npm/v/glut.svg)](https://www.npmjs.com/package/glut)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- 🚀 **One-Command Installation** - Get started in seconds
- 🔥 **Hot Reloading** - Auto-rebuild and restart on file changes
- 🎯 **VS Code Integration** - F5 debugging out of the box
- 🏗️ **Component Generation** - Instant C++ class scaffolding
- ⚡ **Incremental Builds** - Only recompile changed files
- 🌍 **Cross-Platform** - Windows, macOS, and Linux support
- 📦 **Auto-Environment Setup** - FreeGLUT installation handled for you
- 🎨 **Modern C++17** - Professional-grade project structure

## 🚀 Quick Start

### Installation

**Windows (PowerShell as Admin):**
```powershell
irm https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.ps1 | iex
```

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.sh | bash
```

### Create Your First Project

```bash
glut create MyGame
cd MyGame
code .
# Press F5 to build and run!
```

## 📚 Documentation

### Command Reference

| Command | Description |
|---------|-------------|
| [`glut create`](docs/commands/create.md) | Create new project |
| [`glut build`](docs/commands/build.md) | Compile project |
| [`glut run`](docs/commands/run.md) | Build and execute |
| [`glut watch`](docs/commands/watch.md) | Hot reload mode |
| [`glut add`](docs/commands/add.md) | Generate component |
| [`glut clean`](docs/commands/clean.md) | Remove build artifacts |
| [`glut status`](docs/commands/status.md) | Show project info |
| [`glut setup`](docs/commands/setup.md) | Install FreeGLUT |

### Guides

- 📖 [Installation Guide](docs/installation.md)
- 🔧 [Troubleshooting](docs/troubleshooting.md)
- 📁 [Folder Structure](docs/folder-structure.md)
- 🤝 [Contributing](docs/contributing.md)

## 💡 Usage Examples

### Basic Workflow

```bash
# Create project
glut create "My Awesome Game"
cd "My Awesome Game"

# Add components
glut add Player
glut add Enemy
glut add GameEngine

# Build and run
glut run

# Or use hot reload
glut watch
```

### Production Build

```bash
glut build --release
# Optimized with -O3, stripped symbols
```

### VS Code Integration

```bash
code .
# Press F5 to build and debug
# Set breakpoints and step through code
```

## 🏗️ Project Structure

Generated projects include:

```
MyGame/
├── .vscode/              # VS Code configuration
├── main.cpp              # Starter OpenGL app
├── glut.json             # Project metadata
├── build.bat             # Windows build script
├── README.md             # Project documentation
└── STRUCTURE.md          # Folder structure guide
```

See [Folder Structure](docs/folder-structure.md) for details.

## 🎮 Default Controls

Template projects include:

- **+** - Increase shape detail
- **-** - Decrease shape detail
- **q** or **ESC** - Quit

## 🔧 Requirements

- **Node.js** 16.0+ ([nodejs.org](https://nodejs.org/))
- **C++ Compiler:**
  - Windows: MinGW GCC
  - macOS: Xcode Command Line Tools
  - Linux: GCC/G++

FreeGLUT is installed automatically via `glut setup`.

## 🧪 Testing

Cross-platform test suite included:

```bash
# Windows
cd tests/windows
.\test.ps1

# macOS/Linux
cd tests/macos  # or tests/linux
./test.sh
```

## 🤝 Contributing

Contributions are welcome! See [Contributing Guide](docs/contributing.md).

## 📝 License

MIT © [the-shoaib2](https://github.com/the-shoaib2)

## 🙏 Acknowledgments

- [FreeGLUT](http://freeglut.sourceforge.net/) - OpenGL Utility Toolkit
- [Commander.js](https://github.com/tj/commander.js/) - CLI framework
- [Chalk](https://github.com/chalk/chalk) - Terminal styling

## 📞 Support

- 📫 [GitHub Issues](https://github.com/the-shoaib2/freeglut/issues)
- 📖 [Documentation](docs/)
- 💬 [Discussions](https://github.com/the-shoaib2/freeglut/discussions)

---

**Made with ❤️ for OpenGL developers**
