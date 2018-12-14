#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion@2 git node@10 watchman
if [ $PERSONAL -eq 0 ]; then
  brew install awscli mosh
else
  brew install azure-cli kubernetes-cli
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
  brew cask install dropbox
else
  brew cask install firefox microsoft-teams parallels paw powershell sketch
fi
