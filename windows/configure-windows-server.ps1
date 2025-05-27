# Windows 10 Server Configuration Script
# This script configures a Windows 10 machine to behave like a server by:
# 1. Setting up auto-login
# 2. Disabling sleep and hibernation
# 3. Preventing screen lock
# 4. Keeping the system always on

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "This script must be run as Administrator. Please restart PowerShell as Administrator and try again."
    exit 1
}

# Function to handle errors
function Handle-Error {
    param($ErrorMessage)
    Write-Error "Error: $ErrorMessage"
    Write-Host "Please check the error message and try again."
    exit 1
}

# Function to set auto-login
function Set-AutoLogin {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Username,
        
        [Parameter(Mandatory=$true)]
        [string]$Password,
        
        [Parameter(Mandatory=$false)]
        [string]$Domain = "."
    )

    try {
        Write-Host "Configuring auto-login..."
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" -Value "1"
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUsername" -Value $Username
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" -Value $Password
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultDomainName" -Value $Domain
        Write-Host "Auto-login configured successfully."
    }
    catch {
        Handle-Error "Failed to configure auto-login: $_"
    }
}

# Function to configure power settings
function Set-PowerSettings {
    try {
        Write-Host "Configuring power settings..."
        
        # Disable sleep and hibernation
        powercfg -change -standby-timeout-ac 0
        powercfg -change -hibernate-timeout-ac 0
        powercfg -hibernate off
        
        # Set power plan to high performance
        $highPerf = powercfg -l | Where-Object { $_ -like "*High performance*" } | ForEach-Object { $_.Split()[3] }
        if ($highPerf) {
            powercfg -setactive $highPerf
        }
        
        # Turn off screen timeout
        powercfg -change -monitor-timeout-ac 0
        
        Write-Host "Power settings configured successfully."
    }
    catch {
        Handle-Error "Failed to configure power settings: $_"
    }
}

# Function to prevent screen lock
function Set-ScreenLock {
    try {
        Write-Host "Configuring screen lock settings..."
        
        # Prevent screen saver lock
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive" -Value "0"
        
        # Additional registry tweaks to prevent lock screen
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "InactivityTimeoutSecs" -Value 0 -Type DWord
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "InactivityNoLock" -Value 1 -Type DWord
        
        Write-Host "Screen lock settings configured successfully."
    }
    catch {
        Handle-Error "Failed to configure screen lock settings: $_"
    }
}

# Main script execution
try {
    # Get user credentials
    $Username = Read-Host "Enter your Windows username"
    $Password = Read-Host "Enter your Windows password" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    
    # Execute configuration functions
    Set-AutoLogin -Username $Username -Password $PlainPassword
    Set-PowerSettings
    Set-ScreenLock
    
    Write-Host "`nConfiguration completed successfully!"
    Write-Host "Please restart your computer for all changes to take effect."
    
    # Clean up sensitive data
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    Remove-Variable PlainPassword, Password, BSTR
}
catch {
    Handle-Error "An unexpected error occurred: $_"
} 