#!/bin/bash

# Script to setup SSH server on Ubuntu 22.04
# This script will:
# 1. Update system packages
# 2. Install OpenSSH server
# 3. Configure firewall rules

echo "Starting SSH server setup..."

# Update system packages
echo "Step 1: Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install OpenSSH server
echo "Step 2: Installing OpenSSH server..."
if ! dpkg -l | grep -q openssh-server; then
    sudo apt install openssh-server -y
    echo "OpenSSH server installed successfully"
else
    echo "OpenSSH server is already installed, skipping installation"
fi

# Configure firewall
echo "Step 3: Configuring firewall rules..."
sudo ufw status
sudo ufw enable
sudo ufw allow ssh

echo "SSH server setup completed successfully!"

# Install Git
echo "Step 4: Installing Git..."
if ! command -v git &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y git
    echo "Git installed successfully"
else
    echo "Git is already installed, skipping installation"
fi

# Install Node.js and npm
echo "Step 5: Installing Node.js and npm..."
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    sudo apt-get update
    # Install Node.js from NodeSource for latest LTS
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js and npm installed successfully"
else
    echo "Node.js and npm are already installed, skipping installation"
fi

# Install Docker
echo "Step 6: Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker installed successfully"
else
    echo "Docker is already installed, skipping installation"
fi

# Install Docker Compose
echo "Step 7: Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
    echo "Docker Compose installed successfully"
else
    echo "Docker Compose is already installed, skipping installation"
fi

# Add current user to docker group to run docker without sudo
sudo usermod -aG docker $USER
echo "Added current user to docker group. Please log out and log back in for the changes to take effect."

# Install Google Chrome
echo "Step 8: Installing Google Chrome..."
if ! command -v google-chrome &> /dev/null; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install -y google-chrome-stable
    echo "Google Chrome installed successfully"
else
    echo "Google Chrome is already installed, skipping installation"
fi

# Install Visual Studio Code
echo "Step 9: Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get update
    sudo apt-get install -y code
    echo "Visual Studio Code installed successfully"
else
    echo "Visual Studio Code is already installed, skipping installation"
fi

# Install Cursor
echo "Step 10: Installing Cursor..."
if ! command -v cursor &> /dev/null; then
    # Download and install Cursor
    wget -O cursor.deb https://download.cursor.sh/linux_deb/cursor_latest_amd64.deb
    sudo dpkg -i cursor.deb
    sudo apt-get install -f -y
    rm cursor.deb
    echo "Cursor installed successfully"
else
    echo "Cursor is already installed, skipping installation"
fi


# Configure system to never sleep, lock, or log off
echo "Step 11: Configuring system power and lock settings..."

# Disable screen lock
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver lock-delay 0

# Disable automatic suspend
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Configure power settings
sudo tee /etc/systemd/logind.conf << EOF
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore
EOF

# Reload systemd to apply changes
sudo systemctl restart systemd-logind

# Set Ubuntu version to 22.04
echo "Step 12: Setting Ubuntu version to 22.04..."
if [ -f /etc/os-release ]; then
    sudo sed -i 's/VERSION_ID=.*/VERSION_ID="22.04"/' /etc/os-release
    echo "Ubuntu version set to 22.04"
else
    echo "Warning: Could not find /etc/os-release file"
fi

echo "System configured to run continuously without sleep or lock"

# Enable remote sharing
echo "Step 13: Enabling remote sharing..."

# Install required packages
sudo apt-get update
sudo apt-get install -y openssh-server xrdp

# Configure XRDP
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Configure firewall to allow RDP connections
sudo ufw allow 3389/tcp

# Add user to xrdp group
sudo usermod -a -G xrdp $USER

# Configure XRDP to use Xorg
sudo tee /etc/xrdp/startwm.sh << EOF
#!/bin/sh
if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi
startxfce4
EOF

sudo chmod +x /etc/xrdp/startwm.sh

# Restart XRDP service
sudo systemctl restart xrdp

echo "Remote sharing enabled. You can now connect using RDP on port 3389"
