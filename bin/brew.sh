#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion@2 git node@10 watchman
if [ $PERSONAL -eq 0 ]; then
  brew install awscli
else
  brew install azure-cli kubernetes-cli mono
fi

# Bash
if [ -f $(dirname $(dirname $(type -p brew)))/bin/bash ]; then
  if ! grep -qF -- "$(dirname $(dirname $(type -p brew)))/bin/bash" /etc/shells; then
    echo "$(dirname $(dirname $(type -p brew)))/bin/bash" | sudo tee -a /etc/shells
  fi
  if [ "$SHELL" != "$(dirname $(dirname $(type -p brew)))/bin/bash" ]; then
    sudo chsh -s "$(dirname $(dirname $(type -p brew)))/bin/bash"
    chsh -s "$(dirname $(dirname $(type -p brew)))/bin/bash"
  fi
fi

## Cask
brew tap caskroom/versions
brew cask install bartender docker google-chrome shifty spectacle visual-studio-code
if [ $PERSONAL -eq 0 ]; then
  brew tap mengbo/ch340g-ch34g-ch34x-mac-os-x-driver https://github.com/mengbo/ch340g-ch34g-ch34x-mac-os-x-driver
  brew cask install arduino dropbox wch-ch34x-usb-serial-driver
else
  brew cask install dotnet-sdk firefox microsoft-teams parallels paw powershell sketch
fi
