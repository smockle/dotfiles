#!/usr/bin/env zsh
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
if grep -Fq "AppCenter" "${HOME}/.npmrc"; then
  WORK=0; unset PERSONAL;
else
  unset WORK; PERSONAL=0;
fi

# brew
brew tap homebrew/cask-versions
brew install diff-so-fancy git mas node@10 svgcleaner \
  ${PERSONAL:+awscli} ${PERSONAL:+travis} \
  ${WORK:+azure-cli} ${WORK:+kubernetes-cli} ${WORK:+mono}
brew cask install docker google-chrome hazel visual-studio-code \
  ${WORK:+dotnet-sdk} ${WORK:+microsoft-teams} ${WORK:+paw} ${WORK:+powershell}

# mas
mas install 409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` \
  1333542190`#1Password7` 904280696`#Things3` 441258766`#Magnet` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  ${PERSONAL:880001334}`#Reeder3` ${PERSONAL:+924726344}`#Deliveries` ${PERSONAL:+1384080005}`#Tweetbot` ${PERSONAL:+775737590}`#iAWriter` \
  ${WORK:+823766827}`#OneDrive` ${WORK:+462054704}`#MicrosoftWord` ${WORK:+803453959}`#Slack` 

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
code --install-extension EditorConfig.EditorConfig \
     --install-extension esbenp.prettier-vscode \
     --install-extension PeterJausovec.vscode-docker \
     --install-extension VisualStudioExptTeam.vscodeintellicode \
     ${WORK:+$(x=(--install-extension msjsdiag.debugger-for-chrome); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vscode.csharp); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vscode.PowerShell); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vscode.vscode-typescript-tslint-plugin); echo "${x[@]}")}

unset WORK
unset PERSONAL
