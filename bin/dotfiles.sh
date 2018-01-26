#!/usr/bin/env bash

# Install packages via Homebrew
echo "Installing packages via Homebrew…"
bash "${HOME}/Projects/dotfiles/bin/brew.sh"
printf "Installation complete.\n\n"

# Force create/replace symlinks
echo "Creating symlinks…"
bash "${HOME}/Projects/dotfiles/bin/link.sh"
printf "Symlinks created.\n\n"

# Set custom macOS defaults
echo "Setting macOS defaults…"
bash "${HOME}/Projects/dotfiles/bin/defaults.sh"
echo "Defaults set."