# FreeGLUT CLI Installer for Windows (PowerShell)
# Run as Administrator

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FreeGLUT CLI Installer (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  Warning: Running without administrator privileges." -ForegroundColor Yellow
    Write-Host "   Global npm installation may fail. Please run PowerShell as Administrator." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Host "Installation cancelled." -ForegroundColor Red
        exit 1
    }
}

# Create temporary directory
$tempDir = Join-Path $env:TEMP "freeglut-setup-$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
Set-Location $tempDir

try {
    Write-Host "[1/3] Downloading FreeGLUT CLI from GitHub..." -ForegroundColor Green
    $zipUrl = "https://github.com/the-shoaib2/freeglut/archive/refs/heads/main.zip"
    $zipFile = Join-Path $tempDir "freeglut.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing

    Write-Host "[2/3] Extracting files..." -ForegroundColor Green
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    Set-Location (Join-Path $tempDir "freeglut-main\setup")

    Write-Host "[3/3] Installing 'glut' command globally from GitHub..." -ForegroundColor Green
    npm install -g "https://github.com/the-shoaib2/freeglut.git#main:setup"

    if ($LASTEXITCODE -ne 0) {
        throw "npm installation failed"
    }

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Running FreeGLUT Environment Setup" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    glut setup

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Installation Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "✨ The 'glut' command is now available globally." -ForegroundColor Green
    Write-Host ""
    Write-Host "Create your first project:" -ForegroundColor White
    Write-Host "  glut create MyProject" -ForegroundColor Yellow
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "❌ Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    exit 1
} finally {
    # Cleanup
    Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
    Set-Location $env:TEMP
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Done! Press Enter to exit..." -ForegroundColor Green
Read-Host
