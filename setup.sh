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
echo -e "\033[1mSetting up Homebrew\033[0m"
[ -n "${MACOS}" ] && brew tap homebrew/bundle
[ -n "${MACOS}" ] && brew bundle --file Brewfile
[ -n "${MACOS}" ] && brew link --overwrite --force node@14
npm install --global --force npm@latest
mkdir -p "${HOME}/.gnupg" && chmod 700 "${HOME}/.gnupg" && echo "pinentry-program $(which pinentry-mac)" > "${HOME}/.gnupg/gpg-agent.conf"
echo -e "\033[1mHomebrew setup complete\033[0m\n"

# App Store
echo -e "\033[1mSetting up App Store\033[0m"
[ -n "${MACOS}" ] && mas install 1333542190`#1Password7` 425424353`#TheUnarchiver` 1365531024`#1Blocker` \
  409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` \
  1529448980`#Reeder` 290986013`#Deliveries` 1477110326`#CapitalOneShopping` \
  497799835`#Xcode` 803453959`#Slack` 1461845568`#Gifox` 1439967473`#Okta`
echo -e "\033[1mApp Store setup complete\033[0m\n"

# npm
echo -e "\033[1mSetting up npm\033[0m"
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"
echo -e "\033[1mnpm setup complete\033[0m\n"

# vi
echo -e "\033[1mSetting up Vi\033[0m"
mkdir -p "${HOME}/.vim/backups"
mkdir -p "${HOME}/.vim/swaps"
mkdir -p "${HOME}/.vim/undo"
ln -fs "${DOTFILES_DIRECTORY}/.vimrc" "${HOME}/.vimrc"
echo -e "\033[1mVi setup complete\033[0m\n"

# git
echo -e "\033[1mSetting up Git\033[0m"
ln -fs "${DOTFILES_DIRECTORY}/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${DOTFILES_DIRECTORY}/.gitignore" "${HOME}/.gitignore"
[ -n "${CODESPACES}" ] && git config --global "credential.helper" "cache" && git update-index --skip-worktree "${DOTFILES_DIRECTORY}/.gitconfig"
echo -e "\033[1mGit setup complete\033[0m\n"

# shell
echo -e "\033[1mSetting up Zsh\033[0m"
[ -n "${CODESPACES}" ] && sudo chsh -s "$(which zsh)" "$(whoami)"
ln -fs "${DOTFILES_DIRECTORY}/.zprofile" "${HOME}/.zprofile"
ln -fs "${DOTFILES_DIRECTORY}/.zprompt" "${HOME}/.zprompt"
ln -fs "${DOTFILES_DIRECTORY}/.zshrc" "${HOME}/.zshrc"
[ -n "${CODESPACES}" ] && ln -nfs "/workspaces" "${HOME}/Developer"
[ -n "${CODESPACES}" ] && [ ! -d "/workspaces/dotfiles" ] && ln -nfs "${DOTFILES_DIRECTORY}" "/workspaces/dotfiles"
echo -e "\033[1mZsh setup complete\033[0m\n"

# fig
echo -e "\033[1mSetting up Fig\033[0m"
if [ ! -f "${HOME}/.fig" ]; then
  mkdir -p "${HOME}/.fig"
  ln -fs "${DOTFILES_DIRECTORY}/fig/settings.json" "${HOME}/.fig/settings.json"
fi
echo -e "\033[1mFig setup complete\033[0m\n"

# ssh
echo -e "\033[1mSetting up SSH\033[0m"
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
echo -e "\033[1mSSH setup complete\033[0m\n"
