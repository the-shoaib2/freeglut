#!/bin/bash

# Create build directory
mkdir -p build/Debug

# Detect OS
OS="$(uname)"

if [ "$OS" == "Darwin" ]; then
    # macOS
    clang++ main.cpp -o build/app -framework GLUT -framework OpenGL -DGL_SILENCE_DEPRECATION -g
    # Symlink for VS Code extensions expecting 'outDebug'
    ln -sf ../app build/Debug/outDebug
elif [ "$OS" == "Linux" ]; then
    # Linux
    g++ main.cpp -o build/app -lglut -lGL -lGLU -g
    ln -sf ../app build/Debug/outDebug
fi

if [ $? -eq 0 ]; then
    echo "Build successful: ./build/app"
else
    echo "Build failed"
fi
