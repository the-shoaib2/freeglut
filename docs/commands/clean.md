# `glut clean` - Clean Build Artifacts

## Synopsis

```bash
glut clean
```

## Description

Removes all build artifacts and intermediate files, forcing a complete rebuild on next build.

## What Gets Removed

```
build/
├── app.exe (or app)
├── freeglut.dll
└── obj/
    ├── main.obj
    └── *.obj
```

## Example

```bash
glut clean
```

Output:
```
🧹 Cleaning build artifacts...
✔ Project cleaned.
```

If nothing to clean:
```
Nothing to clean.
```

## When to Use

### Force Complete Rebuild
```bash
glut clean
glut build
```

### Fix Linker Issues
Sometimes old object files cause problems:
```bash
glut clean
glut build
```

### Before Release Build
Clean before creating production build:
```bash
glut clean
glut build --release
```

### Reduce Repository Size
Before committing (though build/ is in .gitignore):
```bash
glut clean
git status
```

## What Stays

- Source files (*.cpp, *.h)
- Configuration files (glut.json, .vscode/)
- Documentation
- .gitignore

## See Also

- [`glut build`](build.md) - Rebuild after cleaning
- [`glut status`](status.md) - View project info
