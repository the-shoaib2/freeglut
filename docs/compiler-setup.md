# Compiler Setup Guide

## Windows

### Quick Check

```powershell
g++ --version
```

If you see an error like `g++ is not recognized`, follow the installation steps below.

### Installation Options

#### Option 1: MinGW-w64 (Recommended)

**Download:**
1. Visit [winlibs.com](https://winlibs.com/)
2. Download "UCRT runtime" version (latest release)
3. Choose the `.zip` file (e.g., `winlibs-x86_64-posix-seh-gcc-13.2.0-mingw-w64ucrt-11.0.1-r5.zip`)

**Install:**
1. Extract to `C:\mingw64\`
2. Verify folder structure:
   ```
   C:\mingw64\
   ├── bin\
   │   ├── g++.exe
   │   ├── gcc.exe
   │   └── gdb.exe
   ├── include\
   └── lib\
   ```

**Add to PATH:**

**Method 1 - PowerShell (as Administrator):**
```powershell
$oldPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newPath = $oldPath + ';C:\mingw64\bin'
[Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')
```

**Method 2 - GUI:**
1. Press `Win + X`, select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "System variables", select "Path"
5. Click "Edit"
6. Click "New"
7. Add `C:\mingw64\bin`
8. Click "OK" on all dialogs

**Verify:**
```powershell
# Restart terminal
g++ --version
# Should show: g++ (GCC) 13.x.x
```

#### Option 2: MSYS2

**Install:**
1. Download from [msys2.org](https://www.msys2.org/)
2. Run installer, install to `C:\msys64\`
3. Open "MSYS2 UCRT64" from Start Menu
4. Run:
   ```bash
   pacman -Syu
   pacman -S mingw-w64-ucrt-x86_64-gcc
   ```

**Add to PATH:**
Add `C:\msys64\ucrt64\bin` to system PATH (see Method 2 above)

**Verify:**
```powershell
g++ --version
```

#### Option 3: Winget

```powershell
# Run as Administrator
winget install -e --id MSYS2.MSYS2
```

Then follow MSYS2 steps above.

### Troubleshooting

**"g++ still not recognized after installation"**
- Restart terminal completely
- Verify PATH includes compiler bin directory:
  ```powershell
  $env:Path -split ';' | Select-String mingw
  ```

**"Access denied when adding to PATH"**
- Run PowerShell as Administrator
- Or use GUI method

**"Multiple g++ versions found"**
```powershell
where.exe g++
# Shows all g++ locations
# First one in list is used
```

## macOS

### Install Xcode Command Line Tools

```bash
xcode-select --install
```

**Verify:**
```bash
g++ --version
# or
clang++ --version
```

### Alternative: Homebrew GCC

```bash
brew install gcc
```

## Linux

### Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install build-essential
```

**Verify:**
```bash
g++ --version
```

### Fedora

```bash
sudo dnf install gcc-c++
```

### Arch

```bash
sudo pacman -S base-devel
```

## Verification

After installation, verify everything works:

```bash
# Check compiler
g++ --version

# Check debugger (optional but recommended)
gdb --version

# Test compilation
echo 'int main() { return 0; }' > test.cpp
g++ test.cpp -o test
./test  # or test.exe on Windows
echo $?  # Should output: 0
rm test.cpp test  # or test.exe
```

## See Also

- [Installation Guide](installation.md)
- [Troubleshooting](troubleshooting.md)
