# `glut add` - Add Component

## Synopsis

```bash
glut add <name>
```

## Description

Generates a new C++ component with header and source files following best practices.

## Arguments

- `<name>` - Component name (required)
  - Should be PascalCase (e.g., `Player`, `GameEngine`)
  - Will be used for class name and file names

## What Gets Created

For `glut add Player`:

### Player.h
```cpp
/*
 * Player.h - Component for MyProject
 */

#ifndef PLAYER_H
#define PLAYER_H

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

class Player {
public:
    Player();
    void draw();
};

#endif
```

### Player.cpp
```cpp
/*
 * Player.cpp - Component for MyProject
 */

#include "Player.h"
#include <iostream>

Player::Player() {
    // Constructor
}

void Player::draw() {
    // Drawing logic here
}
```

## Examples

### Add Single Component
```bash
glut add Player
```

Output:
```
✔ Created Player.h
✔ Created Player.cpp

New component added to the project. It will be picked up automatically on next build.
```

### Add Multiple Components
```bash
glut add Enemy
glut add Bullet
glut add PowerUp
```

## Features

- **Header guards** - Prevents multiple inclusion
- **Platform detection** - Correct GLUT includes
- **Project name injection** - Comments include your project name
- **Auto-compilation** - Next build includes new files automatically

## Using the Component

1. **Include in main.cpp**:
```cpp
#include "Player.h"
```

2. **Create instance**:
```cpp
Player player;
```

3. **Use in display function**:
```cpp
static void display(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    player.draw();
    glutSwapBuffers();
}
```

4. **Build**:
```bash
glut build
```

## Naming Conventions

**Good names:**
- `Player`
- `GameEngine`
- `ParticleSystem`
- `AudioManager`

**Avoid:**
- `player` (lowercase)
- `PLAYER` (all caps)
- `my-component` (hyphens)
- `my_component` (underscores for classes)

## See Also

- [`glut build`](build.md) - Compile new components
- [`glut status`](status.md) - View all source files
