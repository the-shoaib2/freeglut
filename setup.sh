#!/bin/bash

echo ""
echo "========================================"
echo "  FreeGLUT CLI Installer (macOS/Linux)"
echo "========================================"
echo ""

# Check for Node.js/npm
if ! command -v npm &> /dev/null; then
    echo ""
    echo "⚠️  Node.js/npm is not installed!"
    echo "This tool requires Node.js to function."
    echo ""
    read -p "Would you like to automatically install Node.js? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                echo "[0/3] Installing Node.js via Homebrew..."
                brew install node
            else
                echo "❌ Homebrew not found. Please install Node.js manually: https://nodejs.org/"
                exit 1
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt-get &> /dev/null; then
                echo "[0/3] Installing Node.js via apt..."
                sudo apt-get update && sudo apt-get install -y nodejs npm
            else
                echo "❌ Package manager not supported. Please install Node.js manually: https://nodejs.org/"
                exit 1
            fi
        else
            echo "❌ OS not supported for auto-install. Please install Node.js manually."
            exit 1
        fi
        
        if ! command -v npm &> /dev/null; then
            echo "⚠️  Node.js installed but 'npm' is still not found in this session."
            echo "Please restart your terminal and run this installer again."
            exit 1
        fi
    else
        echo "Installation cancelled. Please install Node.js to continue."
        exit 1
    fi
fi

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
