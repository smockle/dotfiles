#!/usr/bin/env zsh
# shellcheck shell=bash
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)

if hostname | grep -Fq "Mac-mini"; then
  SERVER=0; unset WORK; unset NOTSERVER;
elif [ -d "${HOME}/Developer/github" ]; then
  unset SERVER; WORK=0; NOTSERVER=0;
else
  unset SERVER; unset WORK; NOTSERVER=0;
fi

# Pre-requisites
# - Log in to iCloud
# - Install 1Password from App Store
# - Set up Internet Accounts
# - Install Homebrew

# Homebrew
brew tap homebrew/cask
brew tap homebrew/cask-versions
[ -n "${SERVER}" ] && brew tap homebrew-ffmpeg/ffmpeg
[ -n "${SERVER}" ] && brew tap homebrew/cask-drivers
brew install bettertouchtool diff-so-fancy git hazel mas node@14 nova visual-studio-code \
  ${SERVER:+adoptopenjdk8} ${SERVER:+awscli} ${SERVER:+libjpeg} ${SERVER:+switchresx} \
  ${SERVER:+ubiquiti-unifi-controller} ${SERVER:+silicon-labs-vcp-driver} \
  ${WORK:+adobe-creative-cloud} ${WORK:+docker} ${WORK:+encryptme} ${WORK:+figma} \
  ${WORK:+google-chrome} ${WORK:+paw} ${WORK:+sketch} ${WORK:+zoomus} \
  ${NOTSERVER:+shellcheck}
[ -n "${SERVER}" ] && brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac
brew link --overwrite --force node@14
npm install --global --force npm@latest

# App Store
mas install 409201541`#Pages` 409203825`#Numbers` 409183694`#Keynote` \
  1333542190`#1Password7` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  ${NOTSERVER:+1225570693}`#Ulysses` ${NOTSERVER:+1529448980}`#Reeder` \
  ${NOTSERVER:+290986013}`#Deliveries` ${NOTSERVER:+1477110326}`#Wikibuy` \
  ${WORK:+497799835}`#Xcode` ${WORK:+803453959}`#Slack` \
  ${WORK:+1461845568}`#Gifox` ${WORK:+1439967473}`#Okta`

# AirBuddy 2
# https://v2.airbuddy.app

# npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"
[ -n "${SERVER}" ] && npm install --global homebridge homebridge-ring homebridge-mi-airpurifier homebridge-roomba-stv

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

# Visual Studio Code
VISUAL_STUDIO_CODE_DIRECTORY="${HOME}/Library/Application Support/Code/User"
mkdir -p "${VISUAL_STUDIO_CODE_DIRECTORY}"
ln -fs "${DOTFILES_DIRECTORY}/code/keybindings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/keybindings.json"
ln -fs "${DOTFILES_DIRECTORY}/code/settings.json" "${VISUAL_STUDIO_CODE_DIRECTORY}/settings.json"
unset VISUAL_STUDIO_CODE_DIRECTORY
code --install-extension amatiasq.sort-imports \
     --install-extension bierner.jsdoc-markdown-highlighting \
     --install-extension dbaeumer.vscode-eslint \
     --install-extension EditorConfig.EditorConfig \
     --install-extension esbenp.prettier-vscode \
     --install-extension mikestead.dotenv \
     --install-extension ms-vscode-remote.remote-ssh \
     --install-extension ms-vscode-remote.remote-ssh-edit \
     --install-extension VisualStudioExptTeam.vscodeintellicode \
     --install-extension wayou.file-icons-mac
[ -n "${NOTSERVER}" ] && code --install-extension timonwong.shellcheck
