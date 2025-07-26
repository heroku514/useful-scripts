#!/bin/bash
# This script disables suspend/hibernate when the laptop lid is closed

CONFIG_FILE="/etc/systemd/logind.conf"

echo "Configuring Ubuntu to keep running after lid close..."

# Backup the original file if not already backed up
if [ ! -f "${CONFIG_FILE}.bak" ]; then
    sudo cp $CONFIG_FILE ${CONFIG_FILE}.bak
    echo "Backup created at ${CONFIG_FILE}.bak"
fi

# Edit or add HandleLidSwitch settings
sudo sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' $CONFIG_FILE
sudo sed -i 's/^HandleLidSwitch=.*/HandleLidSwitch=ignore/' $CONFIG_FILE || echo "HandleLidSwitch=ignore" | sudo tee -a $CONFIG_FILE

sudo sed -i 's/^#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' $CONFIG_FILE
sudo sed -i 's/^HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' $CONFIG_FILE || echo "HandleLidSwitchDocked=ignore" | sudo tee -a $CONFIG_FILE

# Restart systemd-logind to apply changes
sudo systemctl restart systemd-logind

echo "✅ Done! Your laptop will now keep running when the lid is closed."
