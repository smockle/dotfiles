#!/usr/bin/env bash

# Git
ln -fs "${HOME}/Projects/dotfiles/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${HOME}/Projects/dotfiles/git/.gitignore" "${HOME}/.gitignore"

# Shell
ln -fs "${HOME}/Projects/dotfiles/shell/.bash_profile" "${HOME}/.bash_profile"
ln -fs "${HOME}/Projects/dotfiles/shell/.bash_prompt" "${HOME}/.bash_prompt"
ln -fs "${HOME}/Projects/dotfiles/shell/.bashrc" "${HOME}/.bashrc"
ln -fs "${HOME}/Projects/dotfiles/shell/.inputrc" "${HOME}/.inputrc"
touch "${HOME}/.hushlogin"

# Visual Studio Code
VISUAL_STUDIO_CODE_DIRECTORY="${HOME}/Library/Application Support/Code/User"
mkdir -p "${VISUAL_STUDIO_CODE_DIRECTORY}"
ln -fs "${HOME}/Projects/dotfiles/code/keybindings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/keybindings.json"
ln -fs "${HOME}/Projects/dotfiles/code/settings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/settings.json"
unset VISUAL_STUDIO_CODE_DIRECTORY