#!/usr/bin/env bash

# Determine whether to install personal or work modules
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

# Install global npm modules
if [[ ! $(uname -a | grep raspberrypi) ]]; then
  npm i -g diff-so-fancy svgo
  if [ ! $PERSONAL -eq 0 ]; then
    npm i -g @mobile-center/clusterficks
  fi
else
  mkdir -p ~/.npm-global
  npm config set prefix '~/.npm-global'
sudo tee /etc/profile.d/npm-global.sh << EOF
if [ -d "/home/pi/.npm-global" ] ; then
    PATH="/home/pi/.npm-global/bin:\$PATH"
fi
EOF
  sudo chmod +x /etc/profile.d/npm-global.sh
  source /etc/profile
  npm i -g npm@latest
  npm install -g homebridge @smockle/homebridge-lutron-caseta homebridge-mi-airpurifier homebridge-roomba-stv miio
fi

# When running `npm init`, suggest the MIT license (default: ISC license)
npm config set init-license "MIT"

# When running `npm init`, suggest me as the author
if [[ ! $(uname -a | grep raspberrypi) ]]; then
  npm config set init-author-email "clay@smockle.com"
  npm config set init-author-name "Clay Miller"
  npm config set init-author-url "https://www.smockle.com"
fi
