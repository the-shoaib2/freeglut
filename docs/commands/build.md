# `glut build` - Build Project

## Synopsis

```bash
glut build [options]
```

## Description

Compiles the project using incremental compilation for faster builds. Only recompiles changed source files.

## Options

- `-r, --release` - Build with optimizations (`-O3 -s`)

## How It Works

### Incremental Compilation

1. **Scans for .cpp files** - Finds all source files
2. **Checks timestamps** - Compares source vs object files
3. **Compiles changed files** - Only rebuilds what's needed
4. **Links executable** - Creates final binary

### Build Modes

**Debug Mode** (default):
- Includes debug symbols (`-g`)
- No optimizations
- Faster compilation
- Easier debugging

**Release Mode** (`--release`):
- Full optimizations (`-O3`)
- Stripped symbols (`-s`)
- Smaller binary
- Maximum performance

## Platform-Specific Behavior

### Windows
- Compiler: `g++` (MinGW)
- Output: `build/app.exe`
- Libraries: `-lfreeglut -lopengl32 -lglu32`
- DLL: Automatically copies `freeglut.dll` to build directory

### macOS
- Compiler: `clang++`
- Output: `build/app`
- Frameworks: `-framework GLUT -framework OpenGL`
- Flag: `-DGL_SILENCE_DEPRECATION`

### Linux
- Compiler: `g++`
- Output: `build/app`
- Libraries: `-lglut -lGL -lGLU`

## Examples

### Debug Build
```bash
glut build
```

### Release Build
```bash
glut build --release
# or
glut build -r
```

## Build Output

```
🔨 Building project for win32 [Debug]...
  Compiling main.cpp...
  Compiling Player.cpp...
  Linking Debug binary...
  FreeGLUT DLL copied to build directory.

✔ Debug build successful!
```

## Build Directory Structure

```
build/
├── app.exe (or app)     # Executable
├── freeglut.dll         # Windows only
└── obj/                 # Object files
    ├── main.obj
    └── Player.obj
```

## Troubleshooting

### Build Fails
- Check for syntax errors in .cpp files
- Ensure all #include files exist
- Verify FreeGLUT is installed

### DLL Missing (Windows)
- Run `glut setup` to install FreeGLUT
- Check `C:\freeglut\bin\freeglut.dll` exists

### Linker Errors
- Ensure all .cpp files are in project root
- Check function definitions match declarations

## See Also

- [`glut run`](run.md) - Build and run
- [`glut clean`](clean.md) - Clean build artifacts
- [`glut watch`](watch.md) - Auto-rebuild on changes
