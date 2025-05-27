# Windows 10 Server Configuration Script

This PowerShell script configures a Windows 10 machine to behave like a server by:
1. Setting up auto-login
2. Disabling sleep and hibernation
3. Preventing screen lock
4. Keeping the system always on

## Quick Start

Run this command in PowerShell as Administrator:

```powershell
powershell -ExecutionPolicy Bypass -Command "& {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/heuko/useful-scripts/refs/heads/main/windows/configure-windows-server.ps1' -OutFile 'configure-windows-server.ps1'; .\configure-windows-server.ps1}"
```

## Manual Installation

1. Download the script:
   ```powershell
   Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/heuko/useful-scripts/refs/heads/main/windows/configure-windows-server.ps1' -OutFile 'configure-windows-server.ps1'
   ```

2. Run the script as Administrator:
   ```powershell
   .\configure-windows-server.ps1
   ```

## Requirements

- Windows 10
- Administrator privileges
- PowerShell 5.1 or later

### PowerShell Version Information
Windows 10 comes with multiple PowerShell versions:
- **Windows PowerShell** (PowerShell 5.1) - This is the version that can run this script
- **PowerShell Core** (PowerShell 6.0+) - Not compatible with this script

To check your PowerShell version:
```powershell
$PSVersionTable.PSVersion
```

To run the script:
1. Right-click on the Windows PowerShell icon
2. Select "Run as Administrator"
3. Navigate to the script directory
4. Run the script

## What the Script Does

1. **Auto-login Configuration**
   - Sets up automatic login with your credentials
   - Configures registry settings for auto-login

2. **Power Settings**
   - Disables sleep and hibernation
   - Sets power plan to high performance
   - Disables screen timeout

3. **Screen Lock Prevention**
   - Disables screen saver
   - Prevents screen lock on inactivity
   - Configures additional registry settings

## Security Notes

- The script requires administrator privileges
- Your password is handled securely using PowerShell's SecureString
- All sensitive data is cleaned up after script execution
- The script includes error handling and validation

## Troubleshooting

If you encounter any issues:
1. Ensure you're running PowerShell as Administrator
2. Check if your execution policy allows script execution
3. Verify your Windows username and password are correct
4. Make sure you're using Windows PowerShell (5.1) and not PowerShell Core

## License

MIT License - feel free to use and modify as needed.
