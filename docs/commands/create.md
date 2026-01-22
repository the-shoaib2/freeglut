# `glut create` - Create New Project

## Synopsis

```bash
glut create [project-name...]
```

## Description

Creates a new FreeGLUT project from the template with all necessary files and configurations for cross-platform OpenGL development.

## Arguments

- `[project-name...]` - Name of the project (optional, defaults to "Project")
  - Can include spaces (e.g., `glut create My Awesome Game`)
  - Will be used as the window title in the application

## What Gets Created

```
MyProject/
├── .gitignore           # Git ignore patterns
├── .vscode/             # VS Code configuration
│   ├── c_cpp_properties.json
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── build.bat            # Windows build script
├── glut.json            # Project configuration
└── main.cpp             # Starter OpenGL application
```

## Examples

### Basic Usage
```bash
glut create MyGame
```

### With Spaces in Name
```bash
glut create "My Awesome Game"
# or
glut create My Awesome Game
```

### Default Name
```bash
glut create
# Creates a project named "Project"
```

## What Happens

1. **Creates project directory** - Named after your project
2. **Copies template files** - All necessary starter files
3. **Renames .gitignore** - Converts `_gitignore` to `.gitignore`
4. **Updates glut.json** - Sets project name
5. **Injects project name** - Updates `glutCreateWindow()` in main.cpp
6. **Initializes Git** - Ready for version control

## Next Steps

After creating a project:

```bash
cd MyProject
code .              # Open in VS Code
# Press F5 to build and run
```

Or use CLI commands:
```bash
glut build          # Build the project
glut run            # Build and run
glut watch          # Hot reload mode
```

## See Also

- [`glut build`](build.md) - Build the project
- [`glut run`](run.md) - Build and run
- [`glut add`](add.md) - Add new components
