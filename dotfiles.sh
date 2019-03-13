#!/usr/bin/env bash
set -eo pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
if grep -Fq "AppCenter" "${HOME}/.npmrc"; then
  WORK=0; unset PERSONAL;
else
  unset WORK; PERSONAL=0;
fi

# brew
brew tap homebrew/cask-versions \
  ${PERSONAL:+mengbo/ch340g-ch34g-ch34x-mac-os-x-driver}
brew install bash bash-completion@2 diff-so-fancy git mas node@10 shellcheck svgcleaner watchman \
  ${PERSONAL:+awscli} ${PERSONAL:+travis} \
  ${WORK:+azure-cli} ${WORK:+carthage} ${WORK:+kubernetes-cli} ${WORK:+mono}
brew cask install bartender docker google-chrome shifty visual-studio-code \
  ${PERSONAL:+arduino} ${PERSONAL:+dropbox} ${PERSONAL:+wch-ch34x-usb-serial-driver} \
  ${WORK:+dotnet-sdk} ${WORK:+java} ${WORK:+microsoft-teams} ${WORK:+parallels} ${WORK:+paw} ${WORK:+powershell} ${WORK:+sketch}

# mas
mas install 409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` 497799835`#Xcode` \
  1333542190`#1Password7` 904280696`#Things3` 441258766`#Magnet` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  ${PERSONAL:880001334}`#Reeder3` +${PERSONAL:+1225570693}`#Ulysses` ${PERSONAL:+924726344}`#Deliveries`
  ${WORK:+803453959}`#Slack` ${WORK:+1295203466}`#MicrosoftRemoteDesktop` ${WORK:+823766827}`#OneDrive` ${WORK:+462054704}`#MicrosoftWord`

# npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"

# vi
mkdir -p "${HOME}/.vim/backups"
mkdir -p "${HOME}/.vim/swaps"
mkdir -p "${HOME}/.vim/undo"
ln -fs "${DOTFILES_DIRECTORY}/vim/colors" "${HOME}/.vim"
ln -fs "${DOTFILES_DIRECTORY}/vim/.vimrc" "${HOME}/.vimrc"

# git
ln -fs "${DOTFILES_DIRECTORY}/git/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${DOTFILES_DIRECTORY}/git/.gitignore" "${HOME}/.gitignore"

# shell
HOMEBREW_BASH_PATH="$(dirname "$(dirname "$(type -p brew)")")/bin/bash"
if [ -f "${HOMEBREW_BASH_PATH}" ]; then
  if ! grep -qF -- "${HOMEBREW_BASH_PATH}" /etc/shells; then
    echo "${HOMEBREW_BASH_PATH}" | sudo tee -a /etc/shells
  fi
  if [ "$SHELL" != "${HOMEBREW_BASH_PATH}" ]; then
    sudo chsh -s "${HOMEBREW_BASH_PATH}"
    chsh -s "${HOMEBREW_BASH_PATH}"
  fi
fi
unset HOMEBREW_BASH_PATH
ln -fs "${DOTFILES_DIRECTORY}/shell/.bash_profile" "${HOME}/.bash_profile"
ln -fs "${DOTFILES_DIRECTORY}/shell/.bash_prompt" "${HOME}/.bash_prompt"
ln -fs "${DOTFILES_DIRECTORY}/shell/.bashrc" "${HOME}/.bashrc"
ln -fs "${DOTFILES_DIRECTORY}/shell/.inputrc" "${HOME}/.inputrc"
touch "${HOME}/.hushlogin"

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
     --install-extension LinusU.auto-dark-mode \
     --install-extension PeterJausovec.vscode-docker \
     --install-extension smockle.xcode-default-theme \
     --install-extension timonwong.shellcheck \
     --install-extension VisualStudioExptTeam.vscodeintellicode \
     ${PERSONAL:+$(x=(--install-extension ginfuru.ginfuru-vscode-jekyll-syntax); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension msjsdiag.debugger-for-chrome); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vscode.csharp); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vscode.PowerShell); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vscode.vscode-typescript-tslint-plugin); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension ms-vsliveshare.vsliveshare); echo "${x[@]}")} \
     ${WORK:+$(x=(--install-extension redhat.vscode-xml); echo "${x[@]}")}

unset WORK
unset PERSONAL
