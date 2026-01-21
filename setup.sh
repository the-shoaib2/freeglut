#!/bin/bash

# Setup script for FreeGLUT CLI Tool

echo "Installing CLI dependencies..."
cd setup || exit
npm install

echo "Linking 'glut' command globally..."
sudo npm install -g .

echo ""
echo "🚀 Environment Setup: Running 'glut setup'..."
glut setup

echo ""
echo "✨ Success! The 'glut' command is now registered and ready."
echo "You can now create projects from anywhere:"
echo "  glut create <ProjectName>"
echo ""
