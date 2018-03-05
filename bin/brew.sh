#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "xamarin" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion coreutils git gnupg gpg-agent hub node@8 pinentry-mac watchman wget

## Cask
brew tap caskroom/versions
brew cask install bartender google-chrome spectacle visual-studio-code
if [ $PERSONAL -eq 0 ]; then
  brew cask install dropbox steam
else
  brew cask install docker firefox iina microsoft-teams onedrive
fi