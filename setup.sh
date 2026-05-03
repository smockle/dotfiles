#!/usr/bin/env zsh
set -euo pipefail

# Copy dotfiles
DOTFILES_DIRECTORY=$(cd "${0%/*}" && pwd -P)
cp -f "${DOTFILES_DIRECTORY}/.gitconfig" "${HOME}/.gitconfig"
cp -f "${DOTFILES_DIRECTORY}/.vimrc" "${HOME}/.vimrc"
cp -f "${DOTFILES_DIRECTORY}/.profile" "${HOME}/.profile"
cp -f "${DOTFILES_DIRECTORY}/.bashrc" "${HOME}/.bashrc"
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

# Configure git + gpg
if [[ "$(uname -s)" == "Darwin" ]]; then
  mkdir -p "${HOME}/.gnupg"
  chmod 700 "${HOME}/.gnupg"
  pinentry_mac=$(command -v pinentry-mac)
  echo "pinentry-program ${pinentry_mac}" > "${HOME}/.gnupg/gpg-agent.conf"
  git config --global "credential.helper" "osxkeychain"
fi
# Generate a throwaway GPG secret key for locally-signing real GPG public keys in Codespaces
if [ -n "${CODESPACES-}" ] && ! gpg --with-colons --list-secret-keys 2>/dev/null | grep -q '^sec:'; then
  gpg --batch --pinentry-mode loopback --passphrase '' --quick-gen-key "Codespace Local Trust <codespace@example.invalid>" default default never >/dev/null 2>&1
fi
# Import and locally-sign smockle’s GPG public key
SMOCKLE_FPR="519E74EE9A65A441395531E91E6BEB6FED57655B"
curl -fsSL https://github.com/smockle.gpg | gpg --import >/dev/null 2>&1 || exit 1
if gpg --with-colons --list-keys "$SMOCKLE_FPR" 2>/dev/null | grep -q '^pub:' && gpg --list-secret-keys >/dev/null 2>&1; then
  printf 'y\n' | gpg --batch --yes --command-fd 0 --edit-key "$SMOCKLE_FPR" lsign save >/dev/null 2>&1
fi
# Import and locally-sign GitHub’s GPG public key for web commits
WEB_FLOW_FPR="968479A1AFF927E37D1A566BB5690EEEBB952194"
curl -fsSL https://github.com/web-flow.gpg | gpg --import >/dev/null 2>&1 || exit 1
if gpg --with-colons --list-keys "$WEB_FLOW_FPR" 2>/dev/null | grep -q '^pub:' && gpg --list-secret-keys >/dev/null 2>&1; then
  printf 'y\n' | gpg --batch --yes --command-fd 0 --edit-key "$WEB_FLOW_FPR" lsign save >/dev/null 2>&1
fi