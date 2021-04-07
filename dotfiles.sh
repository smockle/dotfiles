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
[ -n "${SERVER}" ] && brew tap homebrew/cask-drivers
brew install bettertouchtool daisydisk diff-so-fancy git gnupg hazel \
  mas node@14 nova pinentry-mac \
  ${SERVER:+adoptopenjdk8} ${SERVER:+awscli} ${SERVER:+cleanmymac} \
  ${SERVER:+switchresx} ${SERVER:+ubiquiti-unifi-controller} \
  ${WORK:+docker} ${WORK:+encryptme} ${WORK:+figma} ${WORK:+google-chrome} \
  ${WORK:+paw} ${WORK:+sketch} ${WORK:+visual-studio-code} ${WORK:+zoomus} \
  ${NOTSERVER:+shellcheck}
brew link --overwrite --force node@14
npm install --global --force npm@latest
mkdir -p "${HOME}/.gnupg" && chmod 700 "${HOME}/.gnupg" && echo "pinentry-program $(which pinentry-mac)" > "${HOME}/.gnupg/gpg-agent.conf"

# App Store
mas install 1333542190`#1Password7` 425424353`#TheUnarchiver` 1320666476`#Wipr` \
  ${NOTSERVER:+409201541}`#Pages` ${NOTSERVER:+409203825}`#Numbers` ${NOTSERVER:+409183694}`#Keynote` \
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
NPM_ROOT=$(npm root -g)
[ -n "${SERVER}" ] && npm install --global homebridge homebridge-ring homebridge-mi-airpurifier homebridge-roomba-stv
[ -n "${SERVER}" ] && ln -fs "${NPM_ROOT}/homebridge-ring/node_modules/ffmpeg-for-homebridge/ffmpeg" "/usr/local/bin/ffmpeg"
unset NPM_ROOT

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

# server
if [ -n "${SERVER}" ]; then
  declare -a LAUNCH_DAEMONS=(
    "com.homebridge.server.plist"
    "com.smockle.ddns53.plist"
    "com.smockle.kvm.plist"
    "com.smockle.wifi.plist"
    "com.unifi.controller.plist"
  )
  declare -a LAUNCH_AGENTS=(
    "com.smockle.res.plist"
  )
  for x in $LAUNCH_DAEMONS; do
    if [ -f "${DOTFILES_DIRECTORY}/server/${x}" ]; then
      echo "Loading ${x}"
      sudo launchctl unload "/Library/LaunchDaemons/${x}" 2>/dev/null
      sudo cp -f "${DOTFILES_DIRECTORY}/server/${x}" "/Library/LaunchDaemons"
      sudo launchctl load "/Library/LaunchDaemons/${x}"
      echo "Loaded ${x}"
    fi
  done
  for x in $LAUNCH_AGENTS; do
    if [ -f "${DOTFILES_DIRECTORY}/server/${x}" ]; then
      echo "Loading ${x}"
      launchctl unload "${HOME}/Library/LaunchAgents/${x}" 2>/dev/null
      cp -f "${DOTFILES_DIRECTORY}/server/${x}" "${HOME}/Library/LaunchAgents"
      launchctl load "${HOME}/Library/LaunchAgents/${x}"
      echo "Loaded ${x}"
    fi
  done
  unset x
  unset LAUNCH_DAEMONS
  unset LAUNCH_AGENTS
fi
