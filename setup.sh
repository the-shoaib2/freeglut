#!/bin/bash

echo ""
echo "========================================"
echo "  FreeGLUT CLI Installer (macOS/Linux)"
echo "========================================"
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

echo "[1/3] Downloading FreeGLUT CLI from GitHub..."
curl -fsSL https://github.com/the-shoaib2/freeglut/archive/refs/heads/main.tar.gz -o freeglut.tar.gz

echo "[2/3] Extracting files..."
tar -xzf freeglut.tar.gz
cd freeglut-main/setup || exit 1

echo "[3/3] Installing 'glut' command globally..."
npm pack
TARBALL=$(ls glut-*.tgz | head -n 1)
sudo npm install -g "$TARBALL"

echo ""
echo "========================================"
echo "  Running FreeGLUT Environment Setup"
echo "========================================"
echo ""
glut setup

echo ""
echo "========================================"
echo "  Installation Complete!"
echo "========================================"
echo ""
echo "✨ The 'glut' command is now available globally."
echo ""
echo "Create your first project:"
echo "  glut create MyProject"
echo ""

# Cleanup
echo "Cleaning up temporary files..."
cd /tmp || cd ~
rm -rf "$TEMP_DIR"

echo ""
echo "Done! Press Enter to exit..."
read -r
