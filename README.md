# FreeGLUT Project Framework 🚀

A professional, cross-platform CLI tool to scaffold, build, and manage OpenGL applications with C++ and FreeGLUT.

[![npm version](https://img.shields.io/npm/v/glut.svg)](https://www.npmjs.com/package/glut)
[![License: MIT](https://img.shields.io/badge/License-MIT-azure.svg)](https://opensource.org/licenses/MIT)

---

## 🔥 Why FreeGLUT Framework?

*   **Zero Configuration** — Scaffold a project and run it with one command.
*   **Auto-Compiler Setup** — Detects and installs MinGW/GCC automatically on Windows.
*   **Hot Reloading** — Rebuilds and restarts your app instantly on file changes.
*   **Integrated Debugging** — Pre-configured VS Code tasks and launch settings.
*   **Native Performance** — Optimized builds for Windows, macOS, and Linux.

---

## 🚀 Quick Start

### 1. Install CLI
**Windows (PowerShell Admin):**
```powershell
irm https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.ps1 | iex
```
**macOS / Linux (Bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/the-shoaib2/freeglut/main/setup.sh | bash
```

### 2. Scaffold & Run
```bash
glut create MyProject
cd MyProject
glut run
```

---

## �️ Essential Commands

| Command | Action |
|:---|:---|
| `glut create <name>` | Scaffold a new project structure |
| `glut build` | Compile the project (Automatic environment check) |
| `glut run` | Build and launch the application |
| `glut watch` | Active monitoring with hot-reloading |
| `glut add <name>` | Generate a new C++ component class |
| `glut clean` | Clear all build artifacts |

---

## � Framework Structure

Generated projects are minimal and framework-driven:

```text
MyProject/
├── .vscode/          # Professional VS Code configuration
├── main.cpp          # Demo app with developer branding
├── glut.json         # Project metadata
└── README.md         # Local project documentation
```

> [!TIP]
> Use `glut watch` for the best development experience. It automatically handles recompilation while you code!

---

## � Resources

*   📖 [Installation Guide](docs/installation.md)
*   🔧 [Compiler Setup](docs/compiler-setup.md)
*   🎯 [Command Reference](docs/commands/)
*   🐞 [Troubleshooting](docs/troubleshooting.md)

---

## 🤝 Contributing

We welcome contributions! Please check out the [Contributing Guide](docs/contributing.md).

Developed with ❤️ by [MD Shoaib Khan (the-shoaib2)](https://github.com/the-shoaib2)
