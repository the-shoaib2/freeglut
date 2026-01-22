# FreeGLUT CLI Installer for Windows (PowerShell)
# Run as Administrator

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FreeGLUT CLI Installer (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for Node.js/npm
if (-not (Get-Command "npm" -ErrorAction SilentlyContinue)) {
    Write-Host ""
    Write-Host "⚠️  Node.js/npm is not installed!" -ForegroundColor Yellow
    Write-Host "This tool requires Node.js to function." -ForegroundColor White
    Write-Host ""
    
    $install = Read-Host "Would you like to automatically install Node.js? (y/N)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        Write-Host "[0/3] Attempting to install Node.js via winget..." -ForegroundColor Green
        if (Get-Command "winget" -ErrorAction SilentlyContinue) {
            winget install -e --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Node.js installed successfully!" -ForegroundColor Green
                Write-Host "Refreshing environment variables..." -ForegroundColor Gray
                
                # Refresh PATH for current session
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
                
                if (-not (Get-Command "npm" -ErrorAction SilentlyContinue)) {
                    Write-Host "⚠️  Node.js installed but 'npm' is still not found in this session." -ForegroundColor Yellow
                    Write-Host "Please restart your terminal and run this installer again." -ForegroundColor White
                    Read-Host "Press Enter to exit..."
                    exit 1
                }
            }
            else {
                Write-Host "❌ auto-installation failed." -ForegroundColor Red
                Write-Host "Please install Node.js manually: https://nodejs.org/" -ForegroundColor White
                Read-Host "Press Enter to exit..."
                exit 1
            }
        }
        else {
            Write-Host "❌ 'winget' not found. Cannot auto-install." -ForegroundColor Red
            Write-Host "Please install Node.js manually: https://nodejs.org/" -ForegroundColor White
            Read-Host "Press Enter to exit..."
            exit 1
        }
    }
    else {
        Write-Host "Installation cancelled. Please install Node.js to continue." -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit 1
    }
}

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

    Write-Host "[3/3] Installing 'glut' command globally..." -ForegroundColor Green
    npm pack
    $tarball = Get-ChildItem "glut-*.tgz" | Select-Object -First 1
    if (-not $tarball) { throw "Failed to create npm package" }
    npm install -g $tarball.FullName

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

}
catch {
    Write-Host ""
    Write-Host "❌ Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    exit 1
}
finally {
    # Cleanup
    Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
    Set-Location $env:TEMP
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Done! Press Enter to exit..." -ForegroundColor Green
Read-Host
