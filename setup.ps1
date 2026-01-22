# FreeGLUT CLI Installer for Windows (PowerShell)

Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        FreeGLUT CLI Installer (Windows)    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Auto-fix PowerShell Execution Policy
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq 'Restricted' -or $policy -eq 'Undefined' -or $policy -eq 'AllSigned') {
    Write-Host "🔧 Fixing PowerShell Execution Policy..." -ForegroundColor Cyan
    try {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "✅ Execution Policy updated." -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  Could not update Execution Policy." -ForegroundColor Yellow
        Write-Host "   Run: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
    }
}

# Check for Node.js/npm (prefer npm.cmd)
$npmCmd = "npm.cmd"
if (-not (Get-Command $npmCmd -ErrorAction SilentlyContinue)) {
    $npmCmd = "npm"
}

if (-not (Get-Command $npmCmd -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️  Node.js is not installed!" -ForegroundColor Yellow
    Write-Host "   This tool requires Node.js to function." -ForegroundColor White
    Write-Host ""
    
    $install = Read-Host "   Install Node.js automatically? (y/n)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        Write-Host "🚀 Installing Node.js via winget..." -ForegroundColor Cyan
        if (Get-Command "winget" -ErrorAction SilentlyContinue) {
            winget install -e --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Node.js installed successfully!" -ForegroundColor Green
                
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
                
                if (Get-Command "npm.cmd" -ErrorAction SilentlyContinue) {
                    $npmCmd = "npm.cmd"
                }
                elseif (Get-Command "npm" -ErrorAction SilentlyContinue) {
                    $npmCmd = "npm"
                }
                
                if (-not (Get-Command $npmCmd -ErrorAction SilentlyContinue)) {
                    Write-Host "❌ Node.js installed but npm not found." -ForegroundColor Red
                    Write-Host "   Please restart your terminal and run this installer again." -ForegroundColor White
                    Write-Host ""
                    Read-Host "Press Enter to exit"
                    exit 1
                }
            }
            else {
                Write-Host "❌ Installation failed." -ForegroundColor Red
                Write-Host "   Install manually: https://nodejs.org/" -ForegroundColor White
                Write-Host ""
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        else {
            Write-Host "❌ winget not found." -ForegroundColor Red
            Write-Host "   Install manually: https://nodejs.org/" -ForegroundColor White
            Write-Host ""
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
    else {
        Write-Host "🚫 Installation cancelled." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}
else {
    $nodeVersion = & node -v
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
}

Write-Host ""

# Check admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  Running without administrator privileges." -ForegroundColor Yellow
    Write-Host "   Global installation may fail." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "   Continue anyway? (y/n)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Host "🚫 Installation cancelled." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
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

    Write-Host "⚙️  [3/3] Installing 'glut' command..." -ForegroundColor Cyan
    & $npmCmd pack | Out-Null
    $tarball = Get-ChildItem "glut-*.tgz" | Select-Object -First 1
    if (-not $tarball) { throw "Failed to create npm package" }
    
    & $npmCmd install -g $tarball.FullName | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "npm installation failed"
    }

    Write-Host ""
    Write-Host "🔨 Initializing FreeGLUT..." -ForegroundColor Cyan
    & glut setup

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✨ Installation Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Create your first project:" -ForegroundColor White
    Write-Host "  glut create MyProject" -ForegroundColor Yellow
    Write-Host ""

}
catch {
    Write-Host ""
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
finally {
    Set-Location $env:TEMP
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "✅ Done! Press Enter to exit..." -ForegroundColor Green
Read-Host
