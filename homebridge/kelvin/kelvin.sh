#!/usr/bin/env bash
set -e

# Import environment variables
if [ ! -f .env ]; then
  echo "Missing .env file for Kelvin. Exiting."
  exit 1
fi
export $(cat .env | xargs)

# Install kelvin
mkdir -p ~/Downloads && cd $_
wget "https://github.com/stefanwichmann/kelvin/releases/download/v${VERSION}/kelvin-linux-arm-v${VERSION}.tar.gz"
tar -xvf "kelvin-linux-arm-v${VERSION}.tar.gz"
cd "kelvin-linux-arm-v${VERSION}"
sudo mkdir -p /var/lib/kelvin
sudo cp -Rf * /var/lib/kelvin/

# Create systemd service config files
sudo tee /etc/systemd/system/kelvin.service << EOF
[Unit]
Description=Kelvin
ConditionPathExists=/var/lib/kelvin/kelvin
After=syslog.target network-online.target

[Service]
Type=simple
User=kelvin
Group=kelvin

Restart=always
RestartSec=10
StartLimitInterval=60s

WorkingDirectory=/var/lib/kelvin
ExecStart=/var/lib/kelvin/kelvin

[Install]
WantedBy=multi-user.target
EOF

# Create systemd service user
if [[ ! $(id -u kelvin 2>/dev/null) ]]; then
  sudo useradd --system kelvin
fi

# Copy config file
cd "${HOME}/Developer/dotfiles/homebridge/kelvin"
eval "tee config.json << EOF
$(<config.json)
EOF
" 2>/dev/null
sudo mv config.json /var/lib/kelvin/config.json
git checkout -- config.json

# Enable the `kelvin` systemd service user to access files in /var/lib/kelvin
sudo chown -R kelvin:kelvin /var/lib/kelvin

# Enable the systemd service
sudo systemctl daemon-reload
sudo systemctl enable kelvin
sudo systemctl start kelvin
# Start, then press hue button. Restart if necessary
echo "Press the button on your Hue bridge"