#!/usr/bin/env zsh
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)

# brew
brew tap homebrew/cask-versions
brew install diff-so-fancy git mas node@10 svgcleaner
brew cask install atom docker google-chrome hazel zoomus

# mas
mas install 409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` \
  1333542190`#1Password7` 441258766`#Magnet` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  904280696`#Things3` 1449412482`#Reeder4` 924726344`#Deliveries` 1384080005`#Tweetbot` \
  775737590`#iAWriter` 803453959`#Slack`

# npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"

# vi
mkdir -p "${HOME}/.vim/backups"
mkdir -p "${HOME}/.vim/swaps"
mkdir -p "${HOME}/.vim/undo"
ln -fs "${DOTFILES_DIRECTORY}/vim/.vimrc" "${HOME}/.vimrc"

# git
ln -fs "${DOTFILES_DIRECTORY}/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${DOTFILES_DIRECTORY}/git/.gitignore" "${HOME}/.gitignore"

# shell
ln -fs "${DOTFILES_DIRECTORY}/shell/.zprofile" "${HOME}/.zprofile"
ln -fs "${DOTFILES_DIRECTORY}/shell/.zprompt" "${HOME}/.zprompt"
ln -fs "${DOTFILES_DIRECTORY}/shell/.zshrc" "${HOME}/.zshrc"

# ssh
if [ ! -f "${HOME}/.ssh/config" ]; then
  mkdir -p "${HOME}/.ssh"
  cp "${DOTFILES_DIRECTORY}/ssh/config" "${HOME}/.ssh/config"
fi

# Finder
if [ -d "${HOME}/Library/Mobile Documents/com~apple~Automator/Documents/Compress SVG.workflow" ]; then
  ln -fs "${HOME}/Library/Mobile Documents/com~apple~Automator/Documents/Compress SVG.workflow" "${HOME}/Library/Services/"
fi

# Atom
mkdir -p "${HOME}/.atom"
ln -fs "${DOTFILES_DIRECTORY}/atom/config.cson" "${HOME}/.atom/config.cson"
ln -fs "${DOTFILES_DIRECTORY}/atom/keymap.cson" "${HOME}/.atom/keymap.cson"
apm install editorconfig linter mojave-dark-mode prettier-atom
