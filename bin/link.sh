#!/usr/bin/env bash

# Force create/replace symlinks
# COREUTILS
mkdir -p "${HOME}/bin"
ln -fs "/usr/local/opt/coreutils/libexec/gnubin/rm" "${HOME}/bin/rm"
ln -fs "/usr/local/opt/coreutils/libexec/gnubin/timeout" "${HOME}/bin/timeout"
mkdir -p "${HOME}/man"
ln -fs "/usr/local/opt/coreutils/libexec/gnuman/rm" "${HOME}/man/rm"
ln -fs "/usr/local/opt/coreutils/libexec/gnuman/timeout" "${HOME}/man/timeout"

# GIT
ln -fs "${HOME}/Projects/dotfiles/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${HOME}/Projects/dotfiles/git/.gitignore" "${HOME}/.gitignore"

# SHELL
ln -fs "${HOME}/Projects/dotfiles/shell/.bash_profile" "${HOME}/.bash_profile"
ln -fs "${HOME}/Projects/dotfiles/shell/.bash_prompt" "${HOME}/.bash_prompt"
ln -fs "${HOME}/Projects/dotfiles/shell/.bashenv" "${HOME}/.bashenv"
ln -fs "${HOME}/Projects/dotfiles/shell/.bashrc" "${HOME}/.bashrc"
ln -fs "${HOME}/Projects/dotfiles/shell/.inputrc" "${HOME}/.inputrc"
touch "${HOME}/.hushlogin"

# VISUAL STUDIO CODE
VISUAL_STUDIO_CODE_DIRECTORY="${HOME}/Library/Application Support/Code - Insiders/User"
mkdir -p "${VISUAL_STUDIO_CODE_DIRECTORY}"
ln -fs "${HOME}/Projects/dotfiles/code/keybindings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/keybindings.json"
ln -fs "${HOME}/Projects/dotfiles/code/settings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/settings.json"
