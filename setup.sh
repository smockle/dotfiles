#!/usr/bin/env zsh
# shellcheck shell=bash
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
MACOS=$(uname -a | grep -Fq Darwin 2>/dev/null && echo "MACOS" || echo "")

# Pre-requisites
# - Log in to iCloud
# - Install 1Password from App Store
# - Set up Internet Accounts
# - Install Homebrew

# Homebrew
[ -n "${MACOS}" ] && brew bundle --file Brewfile
[ -n "${MACOS}" ] && brew link --overwrite --force node@14
npm install --global --force npm@latest
mkdir -p "${HOME}/.gnupg" && chmod 700 "${HOME}/.gnupg" && echo "pinentry-program $(which pinentry-mac)" > "${HOME}/.gnupg/gpg-agent.conf"

# App Store
[ -n "${MACOS}" ] && mas install 1333542190`#1Password7` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` \
  1529448980`#Reeder` \ 290986013`#Deliveries` 1477110326`#CapitalOneShopping` \
  ${WORK:+497799835}`#Xcode` ${WORK:+803453959}`#Slack` \
  ${WORK:+1461845568}`#Gifox` ${WORK:+1439967473}`#Okta`

# npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"

# vi
mkdir -p "${HOME}/.vim/backups"
mkdir -p "${HOME}/.vim/swaps"
mkdir -p "${HOME}/.vim/undo"
ln -fs "${DOTFILES_DIRECTORY}/.vimrc" "${HOME}/.vimrc"

# git
ln -fs "${DOTFILES_DIRECTORY}/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${DOTFILES_DIRECTORY}/.gitignore" "${HOME}/.gitignore"

# shell
ln -fs "${DOTFILES_DIRECTORY}/.zprofile" "${HOME}/.zprofile"
ln -fs "${DOTFILES_DIRECTORY}/.zprompt" "${HOME}/.zprompt"
ln -fs "${DOTFILES_DIRECTORY}/.zshrc" "${HOME}/.zshrc"

# fig
if [ ! -f "${HOME}/.fig" ]; then
  mkdir -p "${HOME}/.fig"
  ln -fs "${DOTFILES_DIRECTORY}/fig/settings.json" "${HOME}/.fig/settings.json"
fi

# ssh
if [ ! -f "${HOME}/.ssh/config" ]; then
  mkdir -p "${HOME}/.ssh"
  tee "${HOME}/.ssh/config" << EOF
Host *
  TCPKeepAlive yes
  ServerAliveInterval 10
  ServerAliveCountMax 10
  ForwardAgent yes
  AddKeysToAgent yes
  UseKeychain yes
EOF
fi
