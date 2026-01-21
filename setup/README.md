## Quick Setup (Short Command)

If you have this repo cloned, you can use these short commands:

### Mac / Linux
```bash
./setup.sh MyNewApp
```

### Windows
```cmd
setup.bat MyNewApp
```

## Global Command (Optional)

To use it from anywhere, add this to your `.zshrc` or `.bashrc`:
```bash
alias create-gl-app='/path/to/freeglut/setup/setup.sh'
```
Then you can just run:
```bash
create-gl-app CoolProject
```

## Features

- **No Node.js Required**: Works with standard shell commands.
- **Auto-Setup**: Downloads FreeGLUT 3.8.0 into the project.

- **Cross-Platform**: Supports macOS, Linux, and Windows.
- **Auto-Setup**: Automatically downloads and extracts FreeGLUT 3.8.0 source into the `deps` folder.
- **Build Scripts**: Includes `build.sh` (macOS/Linux) and `build.bat` (Windows).
- **VS Code Ready**: Pre-configured `.vscode` settings for IntelliSense, tasks, and debugging.
- **Starter Code**: Includes a baseline `main.cpp` with a working OpenGL window.

## Development

1. Clone this repository.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Run locally:
   ```bash
   node index.js my-project
   ```

## Publishing to GitHub

1. Create a new repository on GitHub.
2. Push this folder to your repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```
3. To publish to NPM:
   - Ensure you have an NPM account.
   - Run `npm login`.
   - Run `npm publish`.

## License

MIT
