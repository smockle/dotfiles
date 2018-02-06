#!/usr/bin/env bash

# Force create/replace symlinks
# Coreutils
mkdir -p "${HOME}/bin"
ln -fs "/usr/local/opt/coreutils/libexec/gnubin/rm" "${HOME}/bin/rm"
ln -fs "/usr/local/opt/coreutils/libexec/gnubin/timeout" "${HOME}/bin/timeout"
mkdir -p "${HOME}/man"
ln -fs "/usr/local/opt/coreutils/libexec/gnuman/rm" "${HOME}/man/rm"
ln -fs "/usr/local/opt/coreutils/libexec/gnuman/timeout" "${HOME}/man/timeout"

# Git
ln -fs "${HOME}/Projects/dotfiles/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${HOME}/Projects/dotfiles/git/.gitignore" "${HOME}/.gitignore"

# GPG
mkdir -p "${HOME}/.gnupg"
ln -fs "${HOME}/Projects/dotfiles/gpg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
ln -fs "${HOME}/Projects/dotfiles/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"

# Shell
ln -fs "${HOME}/Projects/dotfiles/shell/.bash_profile" "${HOME}/.bash_profile"
ln -fs "${HOME}/Projects/dotfiles/shell/.bash_prompt" "${HOME}/.bash_prompt"
ln -fs "${HOME}/Projects/dotfiles/shell/.bashenv" "${HOME}/.bashenv"
ln -fs "${HOME}/Projects/dotfiles/shell/.bashrc" "${HOME}/.bashrc"
ln -fs "${HOME}/Projects/dotfiles/shell/.inputrc" "${HOME}/.inputrc"
touch "${HOME}/.hushlogin"

# Visual Studio Code
VISUAL_STUDIO_CODE_DIRECTORY="${HOME}/Library/Application Support/Code/User"
mkdir -p "${VISUAL_STUDIO_CODE_DIRECTORY}"
ln -fs "${HOME}/Projects/dotfiles/code/keybindings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/keybindings.json"
ln -fs "${HOME}/Projects/dotfiles/code/settings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/settings.json"
unset VISUAL_STUDIO_CODE_DIRECTORY