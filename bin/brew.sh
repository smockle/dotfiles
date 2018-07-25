#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion git node@8 watchman
if [ $PERSONAL -ne 0 ]; then
  brew install azure-cli
fi

## Cask
brew tap caskroom/versions
brew cask install 1password-beta bartender docker spectacle visual-studio-code-insiders
if [ $PERSONAL -eq 0 ]; then
  brew cask install dropbox
else
  brew cask install google-chrome microsoft-teams onedrive powershell sketch skype-for-business
fi