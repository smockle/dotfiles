#!/usr/bin/env zsh
# shellcheck shell=bash
set -euo pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
MACOS=$(uname -a | grep -Fq Darwin 2>/dev/null && echo "MACOS" || echo "")
CODESPACES=${CODESPACES:-}

# Pre-requisites
# - Log in to iCloud
# - Set up Internet Accounts
# - Install Homebrew

# shell & dotfiles
echo -e "\033[1mSetting up Zsh\033[0m"
cp -f "${DOTFILES_DIRECTORY}/.zshrc" "${HOME}/.zshrc"
source "${HOME}/.zshrc"
if [ -n "${CODESPACES}" ]; then
  sudo chsh -s "$(which zsh)" "$(whoami)"
  ln -nfs "/workspaces" "${HOME}/Developer"
  if [ ! -d "/workspaces/dotfiles" ]; then
    ln -nfs "${DOTFILES_DIRECTORY}" "/workspaces/dotfiles"
  fi
fi
echo -e "\033[1mZsh setup complete\033[0m\n"

# Homebrew & App Store
if [ -n "${MACOS}" ]; then
  echo -e "\033[1mSetting up Homebrew\033[0m"
  brew bundle --file Brewfile
  echo -e "\033[1mHomebrew setup complete\033[0m\n"
fi

# npm
echo -e "\033[1mSetting up npm\033[0m"
[ -z "${CODESPACES}" ] && npm install --location=global --force npm@latest
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
cp -f "${DOTFILES_DIRECTORY}/.vimrc" "${HOME}/.vimrc"
if [ -n "${MACOS}" ]; then
  tee "${HOME}/.vimrc" << EOF
" Use system clipboard
" even works in Vim compiled without '+clipboard'
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>
EOF
fi
echo -e "\033[1mVi setup complete\033[0m\n"

# git + gpg & diff-highlight
echo -e "\033[1mSetting up Git\033[0m"
cp -f "${DOTFILES_DIRECTORY}/.gitconfig" "${HOME}/.gitconfig"
cp -f "${DOTFILES_DIRECTORY}/.gitignore" "${HOME}/.gitignore"
if [ -n "${MACOS}" ]; then
  mkdir -p "${HOME}/.gnupg"
  chmod 700 "${HOME}/.gnupg"
  echo "pinentry-program $(which pinentry-mac)" > "${HOME}/.gnupg/gpg-agent.conf"
  git config --global "credential.helper" "osxkeychain"
else
  git config --global "credential.helper" "cache"
fi
if whence -p diff-highlight &>/dev/null; then
  git config --global "core.pager" "diff-highlight | less --tabs=4 -RXE"
elif [ -f "/usr/share/doc/git/contrib/diff-highlight/Makefile" ]; then
  cd "/usr/share/doc/git/contrib/diff-highlight"
  sudo make
  sudo chown "$(whoami):" diff-highlight
  chmod +x diff-highlight
  cd "${DOTFILES_DIRECTORY}"
  git config --global "core.pager" "diff-highlight | less --tabs=4 -RXE"
fi
echo -e "\033[1mGit setup complete\033[0m\n"

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
EOF
  if [ -n "${MACOS}" ]; then
    echo "  UseKeychain yes" >> "${HOME}/.ssh/config"
  fi
fi
echo -e "\033[1mSSH setup complete\033[0m\n"
