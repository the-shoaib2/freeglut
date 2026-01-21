#!/bin/bash

# Usage: ./setup.sh [ProjectName]

PROJECT_NAME=${1:-"Project"}
TEMPLATE_DIR="$(dirname "$0")/template"

if [ -d "$PROJECT_NAME" ]; then
    echo "Error: Directory '$PROJECT_NAME' already exists."
    exit 1
fi

echo "Creating project: $PROJECT_NAME..."
cp -r "$TEMPLATE_DIR" "$PROJECT_NAME"

cd "$PROJECT_NAME" || exit

echo "Setting up dependencies..."
mkdir -p deps
curl -L https://github.com/freeglut/freeglut/releases/download/v3.8.0/freeglut-3.8.0.tar.gz -o deps/freeglut.tar.gz

echo "Extracting FreeGLUT..."
tar -xzf deps/freeglut.tar.gz -C deps/
rm deps/freeglut.tar.gz

echo "Success! Project $PROJECT_NAME created."
echo "To start:"
echo "  cd $PROJECT_NAME"
echo "  code ."
