# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    exit
}

# Set TLS 1.2 for GitHub API
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Remove existing installer if present
$installerPath = "$env:TEMP\GitInstaller.exe"
Remove-Item $installerPath -ErrorAction SilentlyContinue

Write-Host "Fetching latest Git release information..."
try {
    $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest"
    $asset = $latestRelease.assets | Where-Object { $_.name -like "*64-bit.exe" } | Select-Object -First 1
    $downloadUrl = $asset.browser_download_url

    Write-Host "Downloading Git installer..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    # Verify the downloaded file
    $fileInfo = Get-Item $installerPath
    if ($fileInfo.Length -eq 0) {
        throw "Downloaded file is empty"
    }
    Write-Host "Downloaded file size: $([math]::Round($fileInfo.Length / 1MB, 2)) MB"

    Write-Host "Running Git installer silently..."
    Start-Process -FilePath $installerPath -ArgumentList '/VERYSILENT', '/NORESTART' -Wait

    Write-Host "Cleaning up installer..."
    Remove-Item $installerPath

    # Verify Git installation
    $gitVersion = git --version
    if ($gitVersion) {
        Write-Host "✅ Git installation complete!"
        Write-Host "Installed version: $gitVersion"
    } else {
        Write-Warning "Git installation may have failed. Please verify manually."
    }
} catch {
    Write-Error "An error occurred: $_"
    Write-Host "Cleaning up..."
    Remove-Item $installerPath -ErrorAction SilentlyContinue
    exit 1
} 