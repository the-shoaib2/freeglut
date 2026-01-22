# FreeGLUT CLI Installer for Windows (PowerShell)
# Run as Administrator

Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        FreeGLUT CLI Installer (Windows)    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 1. Check PowerShell Execution Policy
$policy = Get-ExecutionPolicy
if ($policy -eq 'Restricted' -or $policy -eq 'AllSigned') {
    Write-Host "⚠️  PowerShell Execution Policy is too restrictive ($policy)." -ForegroundColor Yellow
    Write-Host "   This prevents Node.js scripts from running correctly." -ForegroundColor White
    $fixPolicy = Read-Host "   Would you like to set it to 'RemoteSigned' for the current user? (y/n)"
    if ($fixPolicy -eq 'y' -or $fixPolicy -eq 'Y') {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "✅ Execution Policy updated to RemoteSigned." -ForegroundColor Green
    }
    else {
        Write-Host "❌ Warning: Script execution is still restricted. Installation WILL likely fail." -ForegroundColor Red
    }
}

# 2. Check for Node.js/npm (Prefer .cmd to avoid .ps1 policy issues)
$npmCmd = "npm"
if (Get-Command "npm.cmd" -ErrorAction SilentlyContinue) {
    $npmCmd = "npm.cmd"
}

if (-not (Get-Command $npmCmd -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️  Node.js/npm is not installed!" -ForegroundColor Yellow
    Write-Host "   This tool requires Node.js to function." -ForegroundColor White
    Write-Host ""
    
    $install = Read-Host "   Would you like to automatically install Node.js? (y/n)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        Write-Host "🚀 [0/3] Attempting to install Node.js via winget..." -ForegroundColor Cyan
        if (Get-Command "winget" -ErrorAction SilentlyContinue) {
            winget install -e --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Node.js installed successfully!" -ForegroundColor Green
                Write-Host "🔄 Refreshing environment variables..." -ForegroundColor Gray
                
                # Refresh PATH for current session
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
                
                # Re-check for npm.cmd after path refresh
                if (Get-Command "npm.cmd" -ErrorAction SilentlyContinue) {
                    $npmCmd = "npm.cmd"
                }
                
                if (-not (Get-Command $npmCmd -ErrorAction SilentlyContinue)) {
                    Write-Host "❌ Node.js installed but '$npmCmd' is still not found in this session." -ForegroundColor Red
                    Write-Host "   Please restart your terminal and run this installer again." -ForegroundColor White
                    Write-Host ""
                    Read-Host "Press Enter to exit..."
                    exit 1
                }
            }
            else {
                Write-Host "❌ Auto-installation failed." -ForegroundColor Red
                Write-Host "   Please install Node.js manually: https://nodejs.org/" -ForegroundColor White
                Write-Host ""
                Read-Host "Press Enter to exit..."
                exit 1
            }
        }
        else {
            Write-Host "❌ 'winget' not found. Cannot auto-install." -ForegroundColor Red
            Write-Host "   Please install Node.js manually: https://nodejs.org/" -ForegroundColor White
            Write-Host ""
            Read-Host "Press Enter to exit..."
            exit 1
        }
    }
    else {
        Write-Host "🚫 Installation cancelled. Please install Node.js to continue." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
}
else {
    $nodeVersion = node -v
    Write-Host "✅ Node.js Status: Found ($nodeVersion)" -ForegroundColor Green
}

Write-Host ""

# 3. Check for admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  Warning: Running without administrator privileges." -ForegroundColor Yellow
    Write-Host "   Global installation may fail. Please run PowerShell as Administrator." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "   Continue anyway? (y/n)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Host "🚫 Installation cancelled." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
}

# Create temporary directory
$tempDir = Join-Path $env:TEMP "freeglut-setup-$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
Set-Location $tempDir

try {
    Write-Host "📦 [1/3] Downloading FreeGLUT CLI..." -ForegroundColor Cyan
    $zipUrl = "https://github.com/the-shoaib2/freeglut/archive/refs/heads/main.zip"
    $zipFile = Join-Path $tempDir "freeglut.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing

    Write-Host "📂 [2/3] Extracting files..." -ForegroundColor Cyan
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    Set-Location (Join-Path $tempDir "freeglut-main\setup")

    Write-Host "⚙️  [3/3] Installing 'glut' command globally..." -ForegroundColor Cyan
    & $npmCmd pack | Out-Null
    $tarball = Get-ChildItem "glut-*.tgz" | Select-Object -First 1
    if (-not $tarball) { throw "Failed to create npm package" }
    
    # Use npm.cmd for the actual install too
    & $npmCmd install -g $tarball.FullName | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "npm installation failed"
    }

    Write-Host ""
    Write-Host "🔨 Initializing FreeGLUT Environment..." -ForegroundColor Cyan
    & glut setup

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✨ Installation Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "The 'glut' command is now available globally." -ForegroundColor White
    Write-Host ""
    Write-Host "Create your first project:" -ForegroundColor White
    Write-Host "  glut create MyProject" -ForegroundColor Yellow
    Write-Host ""

}
catch {
    Write-Host ""
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}
finally {
    # Cleanup
    Set-Location $env:TEMP
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "✅ Done! Press Enter to exit..." -ForegroundColor Green
Read-Host
