#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion git node@10 watchman
if [ $PERSONAL -eq 0 ]; then
  brew install awscli
else
  brew install azure-cli
fi

## Cask
brew tap caskroom/versions
brew cask install bartender docker google-chrome shifty spectacle visual-studio-code-insiders
if [ $PERSONAL -eq 0 ]; then
  brew cask install dropbox
else
  brew cask install firefox microsoft-teams parallels@13 paw powershell sketch skype-for-business
fi