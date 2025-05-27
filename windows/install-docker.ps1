# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    exit
}

# Define Docker Desktop installer URL
$dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

# Enable WSL 2
Write-Host "Enabling WSL 2..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Host "Downloading Docker Desktop installer..."
Invoke-WebRequest -Uri $dockerUrl -OutFile $installerPath

Write-Host "Running Docker Desktop installer silently..."
Start-Process -FilePath $installerPath -ArgumentList "install --quiet" -Wait

Write-Host "Cleaning up installer..."
Remove-Item $installerPath

Write-Host "✅ Docker Desktop installation complete!"
Write-Host "Please restart your computer to complete the installation." 