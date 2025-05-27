# Define Chrome installer URL
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$installerPath = "$env:TEMP\chrome_installer.exe"

Write-Host "Downloading Chrome installer..."
Invoke-WebRequest -Uri $chromeUrl -OutFile $installerPath

Write-Host "Running Chrome installer silently..."
Start-Process -FilePath $installerPath -ArgumentList "/silent /install" -Wait

Write-Host "Cleaning up installer..."
Remove-Item $installerPath

Write-Host "✅ Chrome installation complete!" 