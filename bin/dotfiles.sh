#!/usr/bin/env bash

# Install packages via Homebrew
echo "Installing packages via Homebrew…"
bash "${HOME}/Projects/dotfiles/bin/brew.sh"
printf "Installation complete.\n\n"

# Install global npm modules
echo "Installing modules via npm…"
bash "${HOME}/Projects/dotfiles/bin/npm.sh"
printf "Installation complete.\n\n"

# Force create/replace symlinks
echo "Creating symlinks…"
bash "${HOME}/Projects/dotfiles/bin/link.sh"
printf "Symlinks created.\n\n"

# Set custom macOS defaults
echo "Setting macOS defaults…"
bash "${HOME}/Projects/dotfiles/bin/defaults.sh"
printf "Defaults set.\n\n"

# Install Visual Studio Code extensions
echo "Installing Visual Studio Code extensions…"
bash "${HOME}/Projects/dotfiles/bin/code.sh"
echo "Visual Studio Code extensions installed."
