# KeepRunningWhenLidClosed.ps1
# This script sets the laptop lid close action to "Do Nothing"
# Works for both Plugged in (AC) and On Battery (DC)

Write-Host "Configuring laptop to keep running when the lid is closed..." -ForegroundColor Cyan

# Set for Plugged in (AC)
powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0

# Set for On Battery (DC)
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0

# Apply the changes immediately
powercfg /SETACTIVE SCHEME_CURRENT

Write-Host "Done! ✅ The laptop will now stay running when you close the lid." -ForegroundColor Green
