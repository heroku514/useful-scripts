run this command first
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

# Windows Installation Scripts

This directory contains PowerShell scripts for silently installing various applications on Windows.

## Available Installation Scripts

- `install-figma.ps1` - Installs Figma Desktop
- `install-chrome.ps1` - Installs Google Chrome
- `install-vscode.ps1` - Installs Visual Studio Code
- `install-cursor.ps1` - Installs Cursor IDE
- `install-docker.ps1` - Installs Docker Desktop (requires Windows 10 Pro/Enterprise/Education)
- `install-git.ps1` - Installs Git for Windows (64-bit)

## Prerequisites

- Windows operating system
- PowerShell 5.1 or later
- Administrator privileges
- For Docker Desktop:
  - Windows 10 Pro, Enterprise, or Education (64-bit)
  - WSL 2 enabled (script will attempt to enable this)

## How to Run

1. Open PowerShell as Administrator:
   - Right-click on PowerShell
   - Select "Run as Administrator"

2. Navigate to the scripts directory:
   ```powershell
   cd path\to\windows\folder
   ```

3. Run any of the installation scripts:
   ```powershell
   .\install-figma.ps1
   .\install-chrome.ps1
   .\install-vscode.ps1
   .\install-cursor.ps1
   .\install-docker.ps1
   .\install-git.ps1
   ```

## Notes

- All scripts download the latest version of each application
- Installations are performed silently (no user interaction required)
- Temporary installer files are automatically cleaned up after installation
- Progress messages will be displayed during the installation process
- Docker Desktop installation requires a system restart after completion
- Git installation includes automatic version verification

## Troubleshooting

If you encounter any issues:

1. Ensure you're running PowerShell as Administrator
2. Check your internet connection
3. Verify that no other installation of the same application is in progress
4. Check Windows Event Viewer for any installation-related errors
5. For Docker Desktop:
   - Ensure your Windows version supports WSL 2
   - Check if virtualization is enabled in BIOS
   - Verify Windows features are properly enabled
6. For Git:
   - Check if the download was successful (file size verification)
   - Verify Git installation using `git --version`
   - Ensure no previous Git installation is in progress
