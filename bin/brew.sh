#!/usr/bin/env bash

# Brew
brew update
brew install bash bash-completion coreutils git hub node@8 wget

# Cask
brew tap caskroom/versions
brew cask install bartender docker dropbox google-chrome-canary spectacle visual-studio-code-insiders