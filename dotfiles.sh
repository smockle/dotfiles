#!/usr/bin/env zsh
setopt pipefail

DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
if hostname | grep -Fq "Mac-mini"; then
   SERVER=0; unset PORTABLE;
 else
   unset SERVER; PORTABLE=0;
 fi

# brew
brew tap homebrew/cask-drivers
brew tap homebrew/cask-versions
brew install clang-format diff-so-fancy git mas node@12 svgcleaner yarn ${SERVER:+awscli} ${SERVER:+mariadb}
brew link --overwrite --force node@12
brew cask install docker figma google-chrome hazel microblog sketch visual-studio-code zoomus ${PORTABLE:+encryptme} ${PORTABLE:+luna-secondary} ${SERVER:+adoptopenjdk8} ${SERVER:+luna-display} ${SERVER:+silicon-labs-vcp-driver} ${SERVER:+ubiquiti-unifi-controller}
if [ $SERVER -eq 0 ]; then
  brew tap homebrew-ffmpeg/ffmpeg
  brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac
  brew services start mariadb
fi

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
if [ $SERVER -eq 0 ]; then
  yarn global add homebridge homebridge-ring homebridge-mi-airpurifier homebridge-smartthings-v2 homebridge-harmony-tv-smockle
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
code --install-extension amatiasq.sort-imports \
     --install-extension dbaeumer.vscode-eslint \
     --install-extension EditorConfig.EditorConfig \
     --install-extension esbenp.prettier-vscode \
     --install-extension iocave.customize-ui \
     --install-extension iocave.monkey-patch \
     --install-extension VisualStudioExptTeam.vscodeintellicode \
     --install-extension wayou.vscode-icons-mac




