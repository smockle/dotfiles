#!/usr/bin/env bash

# Install packages via Apt
if [[ $OSTYPE == "linux-gnu"* ]]; then
  echo "Installing packages via Apt…"
  bash "${HOME}/Developer/dotfiles/bin/apt.sh"
  printf "Installation complete.\n\n"
fi

# Install packages via Homebrew
if [[ $OSTYPE == "darwin"* ]]; then
  echo "Installing packages via Homebrew…"
  bash "${HOME}/Developer/dotfiles/bin/brew.sh"
  printf "Installation complete.\n\n"
fi

# Install global npm modules
echo "Installing modules via npm…"
bash "${HOME}/Developer/dotfiles/bin/npm.sh"
printf "Installation complete.\n\n"

# Force create/replace symlinks
echo "Creating symlinks…"
bash "${HOME}/Developer/dotfiles/bin/link.sh"
printf "Symlinks created.\n\n"

# Set custom macOS defaults
if [[ $OSTYPE == "darwin"* ]]; then
  echo "Setting macOS defaults…"
  bash "${HOME}/Developer/dotfiles/bin/defaults.sh"
  printf "Defaults set.\n\n"
fi

# Install Visual Studio Code extensions
if [[ ! $(uname -a | grep raspberrypi) ]]; then
  echo "Installing Visual Studio Code extensions…"
  bash "${HOME}/Developer/dotfiles/bin/code.sh"
  printf "Visual Studio Code extensions installed.\n\n"
fi

# Set up Homebridge
if [[ $(uname -a | grep raspberrypi) ]]; then
  echo "Setting up Homebridge…"
  bash "${HOME}/Developer/dotfiles/bin/homebridge.sh"
  echo "Homebridge setup complete."
fi