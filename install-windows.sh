#!/usr/bin/env sh

# Install git # Includes Bash
# Install io.js
# Install git-credential-winstore
# Install atom
# Install Google Chome Canary
# Install VisualStudio
# Install hub (https://github.com/github/hub/releases)

# Copy SSH keys
start ~/.ssh

# Install fasd and mktemp
cd ~/Projects
git clone clvv/fasd
wget "http://downloads.sourceforge.net/project/mingw/MSYS/Extension/mktemp/mktemp-1.6-2/mktemp-1.6-2-msys-1.0.13-bin.tar.lzma?r=&ts=1413107452&use_mirror=hivelocity"
# Extract mktemp to ~/Projects/fasd

# Clone dotfiles
cd ~/Projects
git clone smockle/dotfiles

# Update hosts file
sudo mv /c/Windows/system32/drivers/etc/hosts ~/Projects/dotfiles/hosts.bak
sudo cp ~/Projects/dotfiles/hosts /c/Windows/system32/drivers/etc/hosts
