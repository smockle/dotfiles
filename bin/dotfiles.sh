#!/usr/bin/env bash

# Install packages via Homebrew
echo "Installing packages via Homebrew…"
bash "${HOME}/Developer/dotfiles/bin/brew.sh"
printf "Installation complete.\n\n"

# Install global npm modules
echo "Installing modules via npm…"
bash "${HOME}/Developer/dotfiles/bin/npm.sh"
printf "Installation complete.\n\n"

# Force create/replace symlinks
echo "Creating symlinks…"
bash "${HOME}/Developer/dotfiles/bin/link.sh"
printf "Symlinks created.\n\n"

# Set custom macOS defaults
echo "Setting macOS defaults…"
bash "${HOME}/Developer/dotfiles/bin/defaults.sh"
printf "Defaults set.\n\n"

# Configure Docker CLI
echo "Configuring Docker CLI…"
bash "${HOME}/Developer/dotfiles/bin/docker.sh"
printf "Docker CLI configured.\n\n"

# Install Visual Studio Code extensions
echo "Installing Visual Studio Code extensions…"
bash "${HOME}/Developer/dotfiles/bin/code.sh"
printf "Visual Studio Code extensions installed.\n\n"
