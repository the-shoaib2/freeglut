# Windows Testing Script for FreeGLUT Scaffolder
# Run this script from the tests/windows directory

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FreeGLUT Scaffolder - Windows Tests" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Project Creation
Write-Host "[1/5] Testing project creation..." -ForegroundColor Yellow
try {
    node ../../setup/index.js create WindowsTestProject
    if (Test-Path "WindowsTestProject") {
        Write-Host "✅ Project created successfully" -ForegroundColor Green
    } else {
        throw "Project directory not found"
    }
} catch {
    Write-Host "❌ Project creation failed: $_" -ForegroundColor Red
    exit 1
}

Set-Location WindowsTestProject

# Test 2: CLI Build
Write-Host ""
Write-Host "[2/5] Testing CLI build..." -ForegroundColor Yellow
try {
    node ../../../setup/index.js build
    Write-Host "✅ CLI build successful" -ForegroundColor Green
} catch {
    Write-Host "❌ CLI build failed: $_" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Test 3: Build Artifacts
Write-Host ""
Write-Host "[3/5] Verifying build artifacts..." -ForegroundColor Yellow
$exeExists = Test-Path "build/app.exe"
$dllExists = Test-Path "build/freeglut.dll"

if ($exeExists -and $dllExists) {
    $exeSize = (Get-Item "build/app.exe").Length
    $dllSize = (Get-Item "build/freeglut.dll").Length
    Write-Host "✅ app.exe found ($exeSize bytes)" -ForegroundColor Green
    Write-Host "✅ freeglut.dll found ($dllSize bytes)" -ForegroundColor Green
} else {
    if (-not $exeExists) {
        Write-Host "❌ app.exe not found" -ForegroundColor Red
    }
    if (-not $dllExists) {
        Write-Host "❌ freeglut.dll not found" -ForegroundColor Red
    }
    Set-Location ..
    exit 1
}

# Test 4: Manual Build Script
Write-Host ""
Write-Host "[4/5] Testing manual build script..." -ForegroundColor Yellow
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
try {
    .\build.bat
    if (Test-Path "build/app.exe") {
        Write-Host "✅ Manual build successful" -ForegroundColor Green
    } else {
        throw "app.exe not created"
    }
} catch {
    Write-Host "❌ Manual build failed: $_" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Test 5: Component Generation
Write-Host ""
Write-Host "[5/5] Testing component generation..." -ForegroundColor Yellow
try {
    node ../../../setup/index.js add TestComponent
    if ((Test-Path "TestComponent.h") -and (Test-Path "TestComponent.cpp")) {
        Write-Host "✅ Component files generated" -ForegroundColor Green
    } else {
        throw "Component files not found"
    }
} catch {
    Write-Host "❌ Component generation failed: $_" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Cleanup
Set-Location ..
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  All Tests Passed! ✨" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Test project created at: tests/windows/WindowsTestProject" -ForegroundColor Gray
Write-Host "To clean up: Remove-Item -Recurse -Force WindowsTestProject" -ForegroundColor Gray
Write-Host ""
