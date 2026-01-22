# `glut status` - Project Information

## Synopsis

```bash
glut status
```

## Description

Displays information about the current project including name, version, and source files.

## Example Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project: MyAwesomeGame
Version: 1.0.0
Type:    freeglut-project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Source files (4): main.cpp, Player.cpp, Enemy.cpp, Bullet.cpp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Information Displayed

- **Project name** - From glut.json
- **Version** - Project version
- **Type** - Project type (always "freeglut-project")
- **Source files** - Count and list of all .cpp files

## When to Use

### Check Project Setup
```bash
cd MyProject
glut status
```

### Verify Components Added
After adding components:
```bash
glut add Player
glut status
# Should show Player.cpp in source files
```

### Quick Project Overview
```bash
glut status
```

## Requirements

Must be run inside a FreeGLUT project directory (contains `glut.json`).

## Error Messages

### Not in Project
```
✖ Error: Not a FreeGLUT project (missing glut.json).
Navigate to your project folder or use "glut create" to start a new one.
```

## See Also

- [`glut create`](create.md) - Create new project
- [`glut add`](add.md) - Add components
