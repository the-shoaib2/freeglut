# FreeGLUT Scaffolder - Folder Structure

## Repository Structure

```
freeglut/
├── .github/                  # GitHub configuration
│   └── workflows/            # CI/CD workflows (if any)
│
├── .gitignore                # Git ignore patterns
├── README.md                 # Main documentation
├── setup.ps1                 # Windows installer script
├── setup.sh                  # macOS/Linux installer script
│
├── docs/                     # Documentation
│   ├── commands/             # Command reference
│   │   ├── create.md
│   │   ├── build.md
│   │   ├── run.md
│   │   ├── watch.md
│   │   ├── add.md
│   │   ├── clean.md
│   │   ├── status.md
│   │   └── setup.md
│   ├── folder-structure.md   # This file
│   ├── installation.md       # Installation guide
│   ├── troubleshooting.md    # Common issues
│   └── contributing.md       # Contribution guidelines
│
├── setup/                    # CLI package
│   ├── index.js              # Main CLI logic
│   ├── package.json          # NPM package config
│   ├── package-lock.json     # Dependency lock
│   ├── README.md             # Setup documentation
│   ├── node_modules/         # Dependencies
│   └── template/             # Project template
│       ├── .vscode/          # VS Code configuration
│       │   ├── c_cpp_properties.json
│       │   ├── launch.json
│       │   ├── settings.json
│       │   └── tasks.json
│       ├── _gitignore        # Template .gitignore
│       ├── build.bat         # Windows build script
│       ├── glut.json         # Project configuration
│       ├── main.cpp          # Starter application
│       └── STRUCTURE.md      # Template structure guide
│
└── tests/                    # Cross-platform tests
    ├── README.md             # Testing documentation
    ├── windows/              # Windows tests
    │   └── test.ps1
    ├── macos/                # macOS tests
    │   └── test.sh
    └── linux/                # Linux tests
        └── test.sh
```

## Directory Purposes

### Root Level

- **`.github/`** - GitHub-specific configuration (Actions, templates)
- **`.gitignore`** - Prevents committing build artifacts and dependencies
- **`README.md`** - Main project documentation and quick start
- **`setup.ps1`** - One-command Windows installation
- **`setup.sh`** - One-command macOS/Linux installation

### Documentation (`docs/`)

- **`commands/`** - Detailed reference for each CLI command
- **`folder-structure.md`** - This file, explains repository layout
- **`installation.md`** - Step-by-step installation instructions
- **`troubleshooting.md`** - Solutions to common problems
- **`contributing.md`** - Guidelines for contributors

### CLI Package (`setup/`)

- **`index.js`** - Core CLI implementation
  - Command parsing
  - Project scaffolding
  - Build system
  - Component generation

- **`package.json`** - NPM package metadata
  - Dependencies (commander, chalk, fs-extra, etc.)
  - Version information
  - Binary configuration

- **`template/`** - Files copied to new projects
  - Pre-configured VS Code settings
  - Build scripts
  - Starter OpenGL application

### Testing (`tests/`)

- **Platform-specific test scripts** - Automated validation
- **Test projects** - Created during test runs (gitignored)
- **README.md`** - Testing instructions and checklist

## Template Structure

When you run `glut create MyProject`, this structure is created:

```
MyProject/
├── .gitignore              # Ignores build/ and temporary files
├── .vscode/                # VS Code integration
│   ├── c_cpp_properties.json  # IntelliSense configuration
│   ├── launch.json            # Debugger configuration
│   ├── settings.json          # Editor settings
│   └── tasks.json             # Build task (F5 support)
├── build.bat               # Windows build script
├── glut.json               # Project metadata
├── main.cpp                # Starter OpenGL application
└── build/                  # Created on first build
    ├── app.exe (or app)    # Compiled executable
    ├── freeglut.dll        # Windows only
    └── obj/                # Object files
        └── *.obj
```

## File Purposes

### `.vscode/` Files

| File | Purpose |
|------|---------|
| `c_cpp_properties.json` | Configures IntelliSense for FreeGLUT headers |
| `launch.json` | Debugger settings (F5 to debug) |
| `settings.json` | Editor preferences |
| `tasks.json` | Build task configuration |

### Project Files

| File | Purpose |
|------|---------|
| `.gitignore` | Prevents committing build artifacts |
| `build.bat` | Manual Windows build script |
| `glut.json` | Project name, version, type |
| `main.cpp` | OpenGL application entry point |

### Build Output

| File/Directory | Purpose |
|----------------|---------|
| `build/app.exe` | Compiled Windows executable |
| `build/app` | Compiled macOS/Linux executable |
| `build/freeglut.dll` | FreeGLUT runtime (Windows) |
| `build/obj/` | Intermediate object files |

## Adding Components

When you run `glut add Player`, files are added to the root:

```
MyProject/
├── Player.h                # Header file
├── Player.cpp              # Implementation
├── main.cpp                # Existing
└── ... (other files)
```

The build system automatically detects and compiles all `.cpp` files.

## Ignored Files

The `.gitignore` prevents these from being committed:

```
build/                      # All build outputs
*.exe, *.o, *.obj          # Compiled files
*.dll, *.a, *.lib          # Libraries
*.log, *.tmp               # Temporary files
.DS_Store, Thumbs.db       # OS files
```

## See Also

- [Installation Guide](installation.md)
- [Command Reference](commands/)
- [Troubleshooting](troubleshooting.md)
