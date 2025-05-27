# Define Figma installer URL (auto-updated by Figma)
$figmaUrl = "https://desktop.figma.com/win/FigmaSetup.exe"
$installerPath = "$env:TEMP\FigmaSetup.exe"

Write-Host "Downloading Figma installer..."
Invoke-WebRequest -Uri $figmaUrl -OutFile $installerPath

Write-Host "Running Figma installer silently..."
Start-Process -FilePath $installerPath -ArgumentList "/silent" -Wait

Write-Host "Cleaning up installer..."
Remove-Item $installerPath

Write-Host "✅ Figma installation complete!" 