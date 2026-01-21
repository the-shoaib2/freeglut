#!/bin/bash

# Setup script for FreeGLUT CLI Tool

echo "Installing CLI dependencies..."
cd setup || exit
npm install

echo "Linking 'glut' command globally..."
# Using 'npm install -g .' to ensure the binary is registered
sudo npm install -g .

echo ""
echo "Success! The 'glut' command is now available."
echo "Next steps:"
echo "  1. Run 'glut setup' to configure your environment."
echo "  2. Run 'glut create <ProjectName>' to start a new project."
