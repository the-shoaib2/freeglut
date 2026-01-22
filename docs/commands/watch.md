# `glut watch` - Hot Reload Mode

## Synopsis

```bash
glut watch
```

## Description

Monitors source files for changes and automatically rebuilds and restarts the application. Perfect for rapid development.

## How It Works

1. **Builds project** - Initial compilation
2. **Launches application** - Starts the program
3. **Watches files** - Monitors `*.cpp` and `*.h` files
4. **Detects changes** - File save triggers rebuild
5. **Restarts app** - Automatically relaunches

## Example Session

```bash
glut watch
```

Output:
```
👀 Watch mode active. Monitoring for changes...

🔨 Building project for win32 [Debug]...
  Compiling main.cpp...
  Linking Debug binary...

✔ Debug build successful!
🚀 Launching app.exe...

[Application runs]

[You edit main.cpp and save]

♻  Change detected, restarting...
🔨 Building project for win32 [Debug]...
  Compiling main.cpp...
  Linking Debug binary...

✔ Debug build successful!
🚀 Launching app.exe...
```

## Watched Files

- All `*.cpp` files in project root
- All `*.h` files in project root

## Platform Behavior

### Windows
- Kills previous process with `taskkill`
- Restarts automatically

### macOS/Linux
- Sends SIGTERM to previous process
- Restarts automatically

## Tips

- **Save often** - Each save triggers rebuild
- **Fix errors quickly** - Build failures pause watch mode
- **Use with dual monitors** - Code on one, app on another

## Stopping Watch Mode

Press **Ctrl+C** in the terminal to stop watching.

## See Also

- [`glut build`](build.md) - Manual build
- [`glut run`](run.md) - Single run
