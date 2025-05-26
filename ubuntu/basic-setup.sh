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

# Install Docker
echo "Step 4: Installing Docker..."
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
echo "Step 5: Installing Docker Compose..."
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
echo "Step 6: Installing Google Chrome..."
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
echo "Step 7: Installing Visual Studio Code..."
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
echo "Step 8: Installing Cursor..."
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


