#!/usr/bin/env bash

# Automator
if [[ $OSTYPE == "darwin"* ]]; then
  if [ -d ~/Library/Mobile\ Documents/com~apple~Automator/Documents/Compress\ SVG.workflow ]; then
    ln -fs ~/Library/Mobile\ Documents/com~apple~Automator/Documents/Compress\ SVG.workflow ~/Library/Services/
  fi
fi

# Vi
mkdir -p ~/.vim/backups
mkdir -p ~/.vim/swaps
mkdir -p ~/.vim/undo
ln -fs "${HOME}/Developer/dotfiles/vim/colors" "${HOME}/.vim"
ln -fs "${HOME}/Developer/dotfiles/vim/.vimrc" "${HOME}/.vimrc"

# Git
ln -fs "${HOME}/Developer/dotfiles/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${HOME}/Developer/dotfiles/git/.gitignore" "${HOME}/.gitignore"

# Shell
ln -fs "${HOME}/Developer/dotfiles/shell/.bash_profile" "${HOME}/.bash_profile"
ln -fs "${HOME}/Developer/dotfiles/shell/.bash_prompt" "${HOME}/.bash_prompt"
ln -fs "${HOME}/Developer/dotfiles/shell/.bashrc" "${HOME}/.bashrc"
ln -fs "${HOME}/Developer/dotfiles/shell/.inputrc" "${HOME}/.inputrc"
touch "${HOME}/.hushlogin"

# SSH
if [ ! -f "${HOME}/.ssh/config" ]; then
  mkdir -p "${HOME}/.ssh"
  cp "${HOME}/Developer/dotfiles/ssh/config" "${HOME}/.ssh/config"
fi

# Visual Studio Code
if [[ $OSTYPE == "darwin"* ]]; then
  VISUAL_STUDIO_CODE_DIRECTORY="${HOME}/Library/Application Support/Code/User"
  mkdir -p "${VISUAL_STUDIO_CODE_DIRECTORY}"
  ln -fs "${HOME}/Developer/dotfiles/code/keybindings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/keybindings.json"
  ln -fs "${HOME}/Developer/dotfiles/code/settings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/settings.json"
  unset VISUAL_STUDIO_CODE_DIRECTORY
fi