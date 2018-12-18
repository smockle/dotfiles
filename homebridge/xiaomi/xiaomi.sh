#!/usr/bin/env bash
set -e

# Import environment variables
if [ ! -f "$(dirname "$(readlink -f "$0")")/.env" ]; then
  echo "Missing .env file for Xiaomi Bridge. Exiting."
  exit 1
fi
export $(cat "$(dirname "$(readlink -f "$0")")/.env" | xargs)

# Create systemd service config files
sudo tee /etc/default/homebridge-xiaomi-air-purifier << EOF
# Defaults / Configuration options for homebridge
# The following settings tells homebridge where to find the config.json file and where to persist the data (i.e. pairing and others)
HOMEBRIDGE_OPTS=-D -U /var/lib/homebridge-xiaomi-air-purifier

# If you uncomment the following line, homebridge will log more
# You can display this via systemd's journalctl: journalctl -fu homebridge-xiaomi-air-purifier
# DEBUG=*
EOF

sudo tee /etc/systemd/system/homebridge-xiaomi-air-purifier.service << EOF
[Unit]
Description=Node.js HomeKit Server
After=syslog.target network-online.target

[Service]
Type=simple
User=homebridge
EnvironmentFile=/etc/default/homebridge-xiaomi-air-purifier
ExecStart=/home/pi/.npm-global/bin/homebridge \$HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# Create Homebridge config directory
sudo mkdir -p /var/lib/homebridge-xiaomi-air-purifier
sudo chmod -R 0777 /var/lib/homebridge-xiaomi-air-purifier

# Copy config file
cd "$(dirname "$(readlink -f "$0")")"
eval "tee config.json << EOF
$(<config.json)
EOF
" 2>/dev/null
sudo mv config.json /var/lib/homebridge-xiaomi-air-purifier/config.json
git checkout -- config.json

# Enable the `homebridge` systemd service user to access files in /var/lib/homebridge-xiaomi-air-purifier
sudo chown -R homebridge:homebridge /var/lib/homebridge-xiaomi-air-purifier

# Enable the systemd service
sudo systemctl daemon-reload
sudo systemctl enable homebridge-xiaomi-air-purifier
sudo systemctl start homebridge-xiaomi-air-purifier