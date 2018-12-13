#!/usr/bin/env bash
set -e
# Configures Raspberry Pi 2 (ARMv7) & 3 (ARMv8) running Raspbian Stretch Lite
# For installation instructions, see https://gist.github.com/smockle/295d7f1f837a45390e6125bea7c56b3a#on-the-host

# Set timezone 
sudo timedatectl set-timezone "America/Los_Angeles"

# Use CloudFlare DNS servers
if ! grep -qF -- "static domain_name_servers=1.1.1.1 1.0.0.1" /etc/dhcpcd.conf; then
    sudo echo "static domain_name_servers=1.1.1.1 1.0.0.1" >> /etc/dhcpcd.conf
fi

# Set up Kelvin
if [ ! -f /var/lib/kelvin/config.json ]; then
    echo "Setting up Kelvin…"
    bash "${HOME}/Developer/dotfiles/homebridge/kelvin/kelvin.sh"
    printf "Kelvin setup complete.\n\n"
fi

# Create Homebridge system user
if [[ ! $(id -u homebridge 2>/dev/null) ]]; then 
    sudo useradd --system homebridge
fi

# Add Roomba Bridge
if [ ! -f /var/lib/homebridge-roomba/config.json ]; then
    echo "Adding Roomba Bridge…"
    bash "${HOME}/Developer/dotfiles/homebridge/roomba/roomba.sh"
    printf "Roomba Bridge added.\n\n"
fi

# Add Xiaomi Air Purifier Bridge
if [ ! -f /var/lib/homebridge-xiaomi-air-purifier/config.json ]; then
    echo "Adding Xiaomi Air Purifier Bridge…"
    bash "${HOME}/Developer/dotfiles/homebridge/xiaomi/xiaomi.sh"
    echo "Xiaomi Air Purififer Bridge added."
fi