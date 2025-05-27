# Step 1: Open PowerShell as Administrator
# Right-click on PowerShell and select "Run as Administrator"

# Step 2: Install OpenSSH Server
# This command adds the OpenSSH Server capability to Windows
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Step 3: Start the SSH service
# This command starts the SSH daemon service
Start-Service sshd

# Step 4: Configure SSH to start automatically
# This sets the SSH service to start automatically when Windows boots
Set-Service -Name sshd -StartupType 'Automatic'

# Step 5: Configure Windows Firewall
# This creates a new firewall rule to allow incoming SSH connections on port 22
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Step 6: Verify installation
# You can verify the installation by:
# 1. Checking if the service is running: Get-Service sshd
# 2. Testing SSH connection from another machine: ssh username@your-ip-address