#!/usr/bin/env zsh
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)

# brew
brew tap homebrew/cask-versions
brew install clang-format diff-so-fancy git mas node@12 svgcleaner
brew cask install docker encryptme figma google-chrome hazel sketch visual-studio-code zoomus

# mas
mas install 409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` \
  1333542190`#1Password7` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  904280696`#Things3` 1482527526`#lire` 924726344`#Deliveries` \
  1482454543`#Twitter` 775737590`#iAWriter` 803453959`#Slack` \
  497799835`#Xcode`

# npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"

# vi
mkdir -p "${HOME}/.vim/backups"
mkdir -p "${HOME}/.vim/swaps"
mkdir -p "${HOME}/.vim/undo"
ln -fs "${DOTFILES_DIRECTORY}/vim/.vimrc" "${HOME}/.vimrc"

# git
ln -fs "${DOTFILES_DIRECTORY}/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${DOTFILES_DIRECTORY}/git/.gitignore" "${HOME}/.gitignore"

# shell
ln -fs "${DOTFILES_DIRECTORY}/shell/.zprofile" "${HOME}/.zprofile"
ln -fs "${DOTFILES_DIRECTORY}/shell/.zprompt" "${HOME}/.zprompt"
ln -fs "${DOTFILES_DIRECTORY}/shell/.zshrc" "${HOME}/.zshrc"

# ssh
if [ ! -f "${HOME}/.ssh/config" ]; then
  mkdir -p "${HOME}/.ssh"
  cp "${DOTFILES_DIRECTORY}/ssh/config" "${HOME}/.ssh/config"
fi

# Finder
if [ -d "${HOME}/Library/Mobile Documents/com~apple~Automator/Documents/Compress SVG.workflow" ]; then
  ln -fs "${HOME}/Library/Mobile Documents/com~apple~Automator/Documents/Compress SVG.workflow" "${HOME}/Library/Services/"
fi

# Visual Studio Code
VISUAL_STUDIO_CODE_DIRECTORY="${HOME}/Library/Application Support/Code/User"
mkdir -p "${VISUAL_STUDIO_CODE_DIRECTORY}"
ln -fs "${DOTFILES_DIRECTORY}/code/keybindings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/keybindings.json"
ln -fs "${DOTFILES_DIRECTORY}/code/settings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/settings.json"
unset VISUAL_STUDIO_CODE_DIRECTORY
code --install-extension dbaeumer.vscode-eslint \
     --install-extension EditorConfig.EditorConfig \
     --install-extension esbenp.prettier-vscode \
     --install-extension kumar-harsh.graphql-for-vscode \
     --install-extension ms-azuretools.vscode-docker \
     --install-extension ms-vscode.Go \
     --install-extension muuvmuuv.vscode-sundial \
     --install-extension VisualStudioExptTeam.vscodeintellicode \
     --install-extension zxh404.vscode-proto3
