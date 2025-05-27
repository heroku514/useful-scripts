# Windows Installation Scripts

This directory contains PowerShell scripts for silently installing various applications on Windows.

## Available Installation Scripts

- `install-figma.ps1` - Installs Figma Desktop
- `install-chrome.ps1` - Installs Google Chrome
- `install-vscode.ps1` - Installs Visual Studio Code
- `install-cursor.ps1` - Installs Cursor IDE

## Prerequisites

- Windows operating system
- PowerShell 5.1 or later
- Administrator privileges

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
   ```

## Notes

- All scripts download the latest version of each application
- Installations are performed silently (no user interaction required)
- Temporary installer files are automatically cleaned up after installation
- Progress messages will be displayed during the installation process

## Troubleshooting

If you encounter any issues:

1. Ensure you're running PowerShell as Administrator
2. Check your internet connection
3. Verify that no other installation of the same application is in progress
4. Check Windows Event Viewer for any installation-related errors
