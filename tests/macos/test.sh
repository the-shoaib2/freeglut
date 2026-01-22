#!/bin/bash
# macOS Testing Script for FreeGLUT Scaffolder
# Run this script from the tests/macos directory

set -e

echo ""
echo "========================================"
echo "  FreeGLUT Scaffolder - macOS Tests"
echo "========================================"
echo ""

# Test 1: Project Creation
echo "[1/5] Testing project creation..."
node ../../setup/index.js create MacTestProject
if [ -d "MacTestProject" ]; then
    echo "✅ Project created successfully"
else
    echo "❌ Project creation failed"
    exit 1
fi

cd MacTestProject

# Test 2: CLI Build
echo ""
echo "[2/5] Testing CLI build..."
node ../../../setup/index.js build
echo "✅ CLI build successful"

# Test 3: Build Artifacts
echo ""
echo "[3/5] Verifying build artifacts..."
if [ -f "build/app" ]; then
    APP_SIZE=$(stat -f%z "build/app" 2>/dev/null || stat -c%s "build/app")
    echo "✅ app executable found ($APP_SIZE bytes)"
else
    echo "❌ app executable not found"
    cd ..
    exit 1
fi

# Test 4: Executable Permissions
echo ""
echo "[4/5] Checking executable permissions..."
if [ -x "build/app" ]; then
    echo "✅ Executable has correct permissions"
else
    echo "❌ Executable permissions incorrect"
    cd ..
    exit 1
fi

# Test 5: Component Generation
echo ""
echo "[5/5] Testing component generation..."
node ../../../setup/index.js add TestComponent
if [ -f "TestComponent.h" ] && [ -f "TestComponent.cpp" ]; then
    echo "✅ Component files generated"
else
    echo "❌ Component generation failed"
    cd ..
    exit 1
fi

# Cleanup
cd ..
echo ""
echo "========================================"
echo "  All Tests Passed! ✨"
echo "========================================"
echo ""
echo "Test project created at: tests/macos/MacTestProject"
echo "To clean up: rm -rf MacTestProject"
echo ""
