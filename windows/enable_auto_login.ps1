#Requires -RunAsAdministrator

# Script to enable Windows auto-login
# Note: This script must be run as Administrator

param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$true)]
    [string]$Password
)

# Registry path for Winlogon settings
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if running as administrator
if (-not (Test-Administrator)) {
    Write-Error "This script must be run as Administrator. Please restart PowerShell as Administrator and try again."
    exit 1
}

try {
    # Set registry values
    Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1" -Type String
    Set-ItemProperty -Path $regPath -Name "DefaultUsername" -Value $Username -Type String
    Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value $Password -Type String
    Set-ItemProperty -Path $regPath -Name "DefaultDomainName" -Value "." -Type String

    Write-Host "Auto-login has been configured successfully!" -ForegroundColor Green
    Write-Host "Please restart your computer for the changes to take effect." -ForegroundColor Yellow
    Write-Host "`nNote: Your password is stored in plain text in the registry. Only use this on secure, non-shared computers." -ForegroundColor Red
}
catch {
    Write-Error "An error occurred while configuring auto-login: $_"
    exit 1
} 