#!/usr/bin/env bash

# Brew
brew update
brew install bash bash-completion coreutils git gnupg gpg-agent hub node@8 pinentry-mac wget

# Cask
brew tap caskroom/versions
brew cask install bartender docker dropbox google-chrome-canary spectacle visual-studio-code-insiders