#!/usr/bin/env zsh
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
if hostname | grep -Fq "Mac-mini"; then
   SERVER=0; unset PORTABLE;
 else
   unset SERVER; PORTABLE=0;
 fi

# Pre-requisites
# - Log in to iCloud
# - Install 1Password from App Store
# - Set up Internet Accounts
# - Install Homebrew

# brew
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew install diff-so-fancy git node@14 ${SERVER:+awscli}
brew link --overwrite --force node@14
npm install --global --force npm@latest
brew cask install hazel visual-studio-code \
  ${PORTABLE:+adobe-creative-cloud} ${PORTABLE:+bettertouchtool} ${PORTABLE:+docker} \
  ${PORTABLE:+encryptme} ${PORTABLE:+figma} ${PORTABLE:+google-chrome} \
  ${PORTABLE:+paw} ${PORTABLE:+sketch} ${PORTABLE:+zoomus}  \
  ${SERVER:+adoptopenjdk8} ${SERVER:+switchresx} ${SERVER:+ubiquiti-unifi-controller}
if [ $SERVER -eq 0 ]; then
  brew tap homebrew-ffmpeg/ffmpeg
  brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac
  brew tap homebrew/cask-drivers
  brew install libjpeg silicon-labs-vcp-driver
fi

# App Store
# - Pages
# - Numbers
# - Keynote
# - Ulysses
# - Reeder
# - Deliveries
# - 1Password 7
# - The Unarchiver
# - Wipr
# - Capital One Shopping
#
# - AirBuddy 2
# - Xcode
# - Slack
# - Gifox
# - Okta

# npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"
if [ $SERVER -eq 0 ]; then
  npm install --global homebridge homebridge-ring homebridge-mi-airpurifier homebridge-roomba-stv
fi

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
