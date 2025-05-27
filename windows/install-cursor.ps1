# Define Cursor installer URL
$cursorUrl = "https://download.cursor.sh/windows/Cursor-Setup.exe"
$installerPath = "$env:TEMP\cursor_installer.exe"

Write-Host "Downloading Cursor installer..."
Invoke-WebRequest -Uri $cursorUrl -OutFile $installerPath

Write-Host "Running Cursor installer silently..."
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait

Write-Host "Cleaning up installer..."
Remove-Item $installerPath

Write-Host "✅ Cursor installation complete!" 