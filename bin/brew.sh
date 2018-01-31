#!/usr/bin/env bash

# Determine whether to install personal or work packages
PERSONAL=$(! grep -Fq "xamarin" "${HOME}/.npmrc"; echo $?)

## Brew
brew update
brew install bash bash-completion coreutils git gnupg gpg-agent hub node@8 pinentry-mac watchman wget

## Cask
brew tap caskroom/versions
brew cask install bartender docker google-chrome-canary spectacle visual-studio-code-insiders
if [ $PERSONAL -eq 0 ]; then
  brew cask install dropbox now steam
else
  brew cask install firefoxnightly iina microsoft-teams onedrive
fi