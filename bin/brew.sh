#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "xamarin" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion git node@8 watchman

## Cask
brew tap caskroom/versions
brew cask install 1password-beta bartender docker spectacle visual-studio-code-insiders
if [ $PERSONAL -eq 0 ]; then
  brew cask install dropbox
else
  brew cask install google-chrome microsoft-teams onedrive powershell sketch
fi