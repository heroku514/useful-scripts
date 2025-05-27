# Define VS Code installer URL
$vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
$installerPath = "$env:TEMP\vscode_installer.exe"

Write-Host "Downloading VS Code installer..."
Invoke-WebRequest -Uri $vscodeUrl -OutFile $installerPath

Write-Host "Running VS Code installer silently..."
Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT /MERGETASKS=!runcode" -Wait

Write-Host "Cleaning up installer..."
Remove-Item $installerPath

Write-Host "✅ VS Code installation complete!" 