# `glut run` - Build and Run

## Synopsis

```bash
glut run [options]
```

## Description

Builds the project and immediately executes the resulting application.

## Options

- `-r, --release` - Run optimized release build

## Examples

### Debug Run
```bash
glut run
```

### Release Run
```bash
glut run --release
# or
glut run -r
```

## What Happens

1. **Builds project** - Compiles all source files
2. **Links executable** - Creates binary
3. **Launches application** - Runs the program
4. **Shows output** - Displays program output in terminal

## Output

```
🔨 Building project for win32 [Debug]...
  Compiling main.cpp...
  Linking Debug binary...

✔ Debug build successful!
🚀 Launching app.exe...
--- Program Output ---
[Your application runs here]
```

## Keyboard Controls (Default Template)

- **+** - Increase shape detail
- **-** - Decrease shape detail
- **q** or **ESC** - Quit application

## Troubleshooting

### Application Doesn't Start

**Windows:**
- Ensure `freeglut.dll` is in build directory
- Run `glut setup` if DLL is missing

**macOS:**
- Check Homebrew FreeGLUT installation
- Run `brew install freeglut`

**Linux:**
- Verify X11 display is available
- Install `freeglut3-dev` package

### Black Window
- Check OpenGL initialization code
- Verify display callback is set
- Ensure `glutMainLoop()` is called

## See Also

- [`glut build`](build.md) - Build only
- [`glut watch`](watch.md) - Auto-rebuild and restart
