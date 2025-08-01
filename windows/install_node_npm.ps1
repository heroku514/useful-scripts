# PowerShell script to silently install Node.js and npm on Windows 10

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to silently install Node.js
function Install-NodeJS {
    Write-Host "📦 Installing Node.js silently..." -ForegroundColor Yellow
    
    try {
        # Try to install using winget (Windows Package Manager) - preferred method
        if (Test-Command "winget") {
            Write-Host "🔧 Using winget to install Node.js..." -ForegroundColor Cyan
            winget install OpenJS.NodeJS --silent --accept-source-agreements --accept-package-agreements
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Node.js installed successfully via winget" -ForegroundColor Green
                return $true
            }
        }
        
        # Fallback: Download and install Node.js directly
        Write-Host "🔧 Using direct download method..." -ForegroundColor Cyan
        $nodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
        $nodeInstaller = "$env:TEMP\node-installer.msi"
        
        Write-Host "📥 Downloading Node.js installer..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller -UseBasicParsing
        
        Write-Host "🔧 Installing Node.js silently..." -ForegroundColor Yellow
        $process = Start-Process msiexec.exe -Wait -ArgumentList "/i $nodeInstaller /quiet /norestart" -PassThru
        
        # Clean up installer
        Remove-Item $nodeInstaller -Force -ErrorAction SilentlyContinue
        
        if ($process.ExitCode -eq 0) {
            Write-Host "✅ Node.js installed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ Node.js installation failed with exit code: $($process.ExitCode)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Failed to install Node.js: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to refresh environment variables
function Refresh-Environment {
    Write-Host "🔄 Refreshing environment variables..." -ForegroundColor Cyan
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Main execution
Write-Host "🚀 Node.js and npm Installation Script for Windows 10" -ForegroundColor Magenta
Write-Host "==================================================" -ForegroundColor Magenta

# Check if Node.js and npm are already installed
$nodeAvailable = Test-Command "node"
$npmAvailable = Test-Command "npm"

if ($nodeAvailable -and $npmAvailable) {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "✅ Node.js ($nodeVersion) and npm ($npmVersion) are already installed!" -ForegroundColor Green
    Write-Host "📍 Node.js location: $(Get-Command node | Select-Object -ExpandProperty Source)" -ForegroundColor Cyan
    Write-Host "📍 npm location: $(Get-Command npm | Select-Object -ExpandProperty Source)" -ForegroundColor Cyan
    exit 0
}

# Check what's missing
if (-not $nodeAvailable) {
    Write-Host "⚠️ Node.js is not installed" -ForegroundColor Yellow
}
if (-not $npmAvailable) {
    Write-Host "⚠️ npm is not installed" -ForegroundColor Yellow
}

# Install Node.js (which includes npm)
Write-Host "`n🔧 Starting Node.js installation..." -ForegroundColor Yellow
$installSuccess = Install-NodeJS

if ($installSuccess) {
    # Refresh environment variables
    Refresh-Environment
    
    # Verify installation
    Start-Sleep -Seconds 2  # Give system time to update PATH
    
    $nodeAvailable = Test-Command "node"
    $npmAvailable = Test-Command "npm"
    
    if ($nodeAvailable -and $npmAvailable) {
        $nodeVersion = node --version
        $npmVersion = npm --version
        Write-Host "`n🎉 Installation successful!" -ForegroundColor Green
        Write-Host "✅ Node.js version: $nodeVersion" -ForegroundColor Green
        Write-Host "✅ npm version: $npmVersion" -ForegroundColor Green
        Write-Host "📍 Node.js location: $(Get-Command node | Select-Object -ExpandProperty Source)" -ForegroundColor Cyan
        Write-Host "📍 npm location: $(Get-Command npm | Select-Object -ExpandProperty Source)" -ForegroundColor Cyan
    } else {
        Write-Host "`n⚠️ Installation completed but verification failed." -ForegroundColor Yellow
        Write-Host "💡 You may need to restart your terminal or computer for changes to take effect." -ForegroundColor Yellow
    }
} else {
    Write-Host "`n❌ Installation failed. Please try running the script as Administrator." -ForegroundColor Red
    Write-Host "💡 Alternative: Download Node.js manually from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n✨ Installation process completed!" -ForegroundColor Magenta 
