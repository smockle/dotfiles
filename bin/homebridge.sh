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

# Enable 'wait-online'
sudo systemctl enable systemd-networkd-wait-online.service

# Configure unattended upgrades
if [ -f /etc/apt/apt.conf.d/50unattended-upgrades ]; then
    # Specify which packages can be updated
    sudo sed -i.bak '/^\s*Unattended-Upgrade::Origins-Pattern [{]\s*$/,/^[}][;]\s*$/c\
Unattended-Upgrade::Origins-Pattern {\
    "origin=Debian,codename=${distro_codename},label=Debian-Security";\
    "origin=Raspbian,codename=${distro_codename},label=Raspbian";\
    "origin=Raspberry Pi Foundation,codename=${distro_codename},label=Raspberry Pi Foundation";\
    "origin=Node Source,codename=${distro_codename},label=Node Source";\
};' /etc/apt/apt.conf.d/50unattended-upgrades
sudo rm /etc/apt/apt.conf.d/50unattended-upgrades.bak

    # Reboot automatically
    sudo sed -i 's/^\/\/Unattended-Upgrade::Automatic-Reboot "false";/Unattended-Upgrade::Automatic-Reboot "true";/g' /etc/apt/apt.conf.d/50unattended-upgrades
    sudo sed -i 's/^\/\/Unattended-Upgrade::Automatic-Reboot-Time "02:00";/Unattended-Upgrade::Automatic-Reboot-Time "02:00";/g' /etc/apt/apt.conf.d/50unattended-upgrades

    # Autoremove dependencies
    sudo sed -i 's/^\/\/Unattended-Upgrade::Remove-Unused-Dependencies "false";/Unattended-Upgrade::Remove-Unused-Dependencies "true";/g' /etc/apt/apt.conf.d/50unattended-upgrades
fi
if [ ! -f /etc/apt/apt.conf.d/20auto-upgrades ]; then
    # Update package lists and packages
sudo tee /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
fi

# Create Homebridge system user
if [[ ! $(id -u homebridge 2>/dev/null) ]]; then 
    sudo useradd --system homebridge
fi

# Add Lutron Caséta Bridge
if [ ! -f /var/lib/homebridge-lutron/config.json ]; then
    echo "Adding Lutron Bridge…"
    bash "${HOME}/Developer/dotfiles/homebridge/lutron/lutron.sh"
    printf "Lutron Bridge added.\n\n"
fi

# Add Roomba Bridge
if [ ! -f /var/lib/homebridge-roomba/config.json ]; then
    echo "Adding Roomba Bridge…"
    bash "${HOME}/Developer/dotfiles/homebridge/roomba/roomba.sh"
    printf "Roomba Bridge added.\n\n"
fi

# Add Xiaomi Air Purifier Bridge
if [ ! -f /var/lib/homebridge-xiaomi-air-purifier/config.json ]; then
    echo "Adding Xiaomi Bridge…"
    bash "${HOME}/Developer/dotfiles/homebridge/xiaomi/xiaomi.sh"
    echo "Xiaomi Bridge added."
fi