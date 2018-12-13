#!/usr/bin/env bash
set -e

# Import environment variables
if [ ! -f .env ]; then
  echo "Missing .env file for Roomba Bridge. Exiting."
  exit 1
fi
export $(cat .env | xargs)

# Create systemd service config files
sudo tee /etc/default/homebridge-roomba << EOF
# Defaults / Configuration options for homebridge
# The following settings tells homebridge where to find the config.json file and where to persist the data (i.e. pairing and others)
HOMEBRIDGE_OPTS=-U /var/lib/homebridge-roomba

# If you uncomment the following line, homebridge will log more
# You can display this via systemd's journalctl: journalctl -fu homebridge-roomba
# DEBUG=*
EOF

sudo tee /etc/systemd/system/homebridge-roomba.service << EOF
[Unit]
Description=Node.js HomeKit Server
After=syslog.target network-online.target

[Service]
Type=simple
User=homebridge
EnvironmentFile=/etc/default/homebridge-roomba
ExecStart=/home/pi/.npm-global/bin/homebridge \$HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# Create Homebridge config directory
sudo mkdir -p /var/lib/homebridge-roomba
sudo cp -Rf ~/.homebridge/persist /var/lib/homebridge-roomba
sudo chmod -R 0777 /var/lib/homebridge-roomba

# Copy config file
cd "${HOME}/Developer/dotfiles/homebridge/roomba"
eval "tee config.json << EOF
$(<config.json)
EOF
" 2>/dev/null
sudo mv config.json /var/lib/homebridge-roomba/config.json
git checkout -- config.json

# Enable the `homebridge` systemd service user to access files in /var/lib/homebridge-roomba
sudo chown -R homebridge:homebridge /var/lib/homebridge-roomba

# Enable the systemd service
sudo systemctl daemon-reload
sudo systemctl enable homebridge-roomba
sudo systemctl start homebridge-roomba