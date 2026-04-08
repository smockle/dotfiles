#!/usr/bin/env zsh
set -euo pipefail

# Link dotfiles
DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
cp -f "${DOTFILES_DIRECTORY}/.gitconfig" "${HOME}/.gitconfig"
cp -f "${DOTFILES_DIRECTORY}/.vimrc" "${HOME}/.vimrc"
cp -f "${DOTFILES_DIRECTORY}/.zshrc" "${HOME}/.zshrc"

# Configure npm
npm config set init-license "MIT"
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"

# Configure ruby (macOS only)
if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "gem: --user-install" > "${HOME}/.gemrc"
fi

# Configure vim (macOS only)
if [[ "$(uname -s)" == "Darwin" ]]; then
  tee -a "${HOME}/.vimrc" << EOF >/dev/null 2>&1

" Use system clipboard (even in Vim compiled without '+clipboard')
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>
EOF
fi

# Configure git + gpg (macOS only)
if [[ "$(uname -s)" == "Darwin" ]]; then
  mkdir -p "${HOME}/.gnupg"
  chmod 700 "${HOME}/.gnupg"
  echo "pinentry-program $(which pinentry-mac)" > "${HOME}/.gnupg/gpg-agent.conf"
  git config --global "credential.helper" "osxkeychain"
fi
