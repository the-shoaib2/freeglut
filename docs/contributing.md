# Contributing to FreeGLUT Scaffolder

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community

## How to Contribute

### Reporting Bugs

1. Check [existing issues](https://github.com/the-shoaib2/freeglut/issues)
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Platform and version info
   - Code samples if applicable

### Suggesting Features

1. Check existing feature requests
2. Create an issue describing:
   - The problem it solves
   - Proposed solution
   - Alternative solutions considered
   - Additional context

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes**
   - Follow existing code style
   - Add tests if applicable
   - Update documentation

4. **Test your changes**
   ```bash
   cd tests/windows
   .\test.ps1
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "Add amazing feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**
   - Describe your changes
   - Reference related issues
   - Include screenshots if UI changes

## Development Setup

### Prerequisites

- Node.js 16.0+
- Git
- Platform-specific compilers (MinGW, Xcode, GCC)

### Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/freeglut.git
cd freeglut

# Install dependencies
cd setup
npm install

# Test locally
node index.js create TestProject
```

### Project Structure

```
freeglut/
├── docs/                 # Documentation
│   ├── commands/         # Command reference
│   └── *.md             # Guides
├── setup/               # CLI package
│   ├── index.js         # Main logic
│   ├── package.json     # NPM config
│   └── template/        # Project template
└── tests/               # Cross-platform tests
```

## Coding Guidelines

### JavaScript (index.js)

- Use ES6+ features
- Async/await for async operations
- Clear variable names
- Comment complex logic

**Example:**
```javascript
async function performBuild(isRelease) {
    const platform = process.platform;
    const mode = isRelease ? 'Release' : 'Debug';
    
    console.log(chalk.cyan(`🔨 Building for ${platform} [${mode}]...`));
    // ... build logic
}
```

### C++ (template files)

- Follow C++17 standard
- Use consistent indentation (4 spaces)
- Comment public APIs
- Platform-specific code in `#ifdef` blocks

**Example:**
```cpp
#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif
```

### Documentation

- Use Markdown
- Include code examples
- Cross-reference related docs
- Keep language clear and concise

## Testing

### Automated Tests

**Windows:**
```powershell
cd tests/windows
.\test.ps1
```

**macOS/Linux:**
```bash
cd tests/macos  # or tests/linux
chmod +x test.sh
./test.sh
```

### Manual Testing

1. Create test project
2. Build and run
3. Test all commands
4. Verify VS Code integration

### Test Checklist

- [ ] `glut create` works
- [ ] `glut build` compiles successfully
- [ ] `glut run` executes
- [ ] `glut watch` hot reloads
- [ ] `glut add` generates files
- [ ] `glut clean` removes artifacts
- [ ] VS Code F5 debugging works
- [ ] Cross-platform compatibility

## Documentation Updates

When adding features:

1. Update command docs in `docs/commands/`
2. Update main README.md
3. Update template README.md if needed
4. Add troubleshooting entries if applicable

## Release Process

1. Update version in `package.json`
2. Update CHANGELOG.md
3. Create git tag
4. Publish to npm
5. Create GitHub release

## Questions?

- Open an issue for questions
- Check existing documentation
- Review closed issues for similar questions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions make this project better for everyone! 🎉
