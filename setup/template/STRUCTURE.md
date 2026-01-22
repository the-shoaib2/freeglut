# Project Structure

This document explains the folder structure of your FreeGLUT project.

## Directory Layout

```
MyProject/
├── .gitignore              # Git ignore patterns
├── .vscode/                # VS Code configuration
│   ├── c_cpp_properties.json
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── build.bat               # Windows build script
├── glut.json               # Project configuration
├── main.cpp                # Main application
├── STRUCTURE.md            # This file
└── build/                  # Build output (created automatically)
    ├── app.exe             # Your executable
    ├── freeglut.dll        # FreeGLUT runtime (Windows)
    └── obj/                # Object files
```

## File Descriptions

### Configuration Files

**`.gitignore`**
- Prevents build artifacts from being committed to Git
- Ignores `build/`, `*.exe`, `*.dll`, etc.

**`glut.json`**
- Project metadata (name, version, type)
- Used by `glut status` command

**`build.bat`** (Windows only)
- Manual build script
- Alternative to `glut build` command

### VS Code Integration (`.vscode/`)

**`c_cpp_properties.json`**
- Configures IntelliSense
- Sets include paths for FreeGLUT headers

**`launch.json`**
- Debugger configuration
- Enables F5 debugging

**`settings.json`**
- Editor preferences
- C++ specific settings

**`tasks.json`**
- Build task configuration
- Runs when you press F5

### Source Files

**`main.cpp`**
- Entry point of your application
- Contains `main()` function
- Starter OpenGL code with rotating shapes

## Adding Components

Use `glut add <ComponentName>` to create new files:

```bash
glut add Player
```

This creates:
```
MyProject/
├── Player.h                # Header file
├── Player.cpp              # Implementation
└── ... (existing files)
```

Components are automatically compiled on next build.

## Build Directory

The `build/` directory is created automatically when you build:

```
build/
├── app.exe (or app)        # Executable
├── freeglut.dll            # Windows only
└── obj/                    # Object files
    ├── main.obj
    ├── Player.obj
    └── ...
```

**Note:** This directory is in `.gitignore` and should not be committed.

## Typical Workflow

1. **Edit source files** - Modify `.cpp` and `.h` files
2. **Build** - Press F5 or run `glut build`
3. **Run** - Application launches automatically
4. **Debug** - Set breakpoints and use debugger
5. **Add components** - Use `glut add` for new files
6. **Commit** - Git ignores build artifacts automatically

## Clean Build

To remove all build artifacts:

```bash
glut clean
```

This deletes the entire `build/` directory.

## See Also

- Run `glut help` for command reference
- Check `README.md` for project-specific information
