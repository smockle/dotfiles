#!/usr/bin/env zsh
set -euo pipefail

# Detect operating system
case "$(uname -s)" in
  Darwin) os="macOS" ;;
  *) os="Linux" ;;
esac

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

# Configure ruby
if [[ "$os" == "macOS" ]]; then
  echo "gem: --user-install" > "${HOME}/.gemrc"
fi

# Configure vim
if [[ "$os" == "macOS" ]]; then
  tee -a "${HOME}/.vimrc" << EOF >/dev/null 2>&1

" Use system clipboard (even in Vim compiled without '+clipboard')
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>
EOF
fi

# Configure git
mkdir -p "${HOME}/.config/git"
curl -fsSL "https://raw.githubusercontent.com/github/gitignore/main/Global/${os}.gitignore" -o "${HOME}/.config/git/ignore"

# Configure gpg
if [[ "$os" == "macOS" ]]; then
  mkdir -p "${HOME}/.gnupg"; chmod 700 "${HOME}/.gnupg"
  pinentry_mac=$(command -v pinentry-mac)
  echo "pinentry-program ${pinentry_mac}" > "${HOME}/.gnupg/gpg-agent.conf"
  git config --global "credential.helper" "osxkeychain"
fi
# Generate a throwaway GPG secret key for locally-signing public keys in Codespaces
if [[ -n "${CODESPACES-}" ]] && ! gpg --with-colons --list-secret-keys 2>/dev/null | grep -q '^sec:'; then
  gpg --batch --pinentry-mode loopback --passphrase '' --quick-gen-key "Codespace Local Trust <codespace@example.invalid>" default default never >/dev/null 2>&1
fi
# Import and locally-sign GPG public keys
for key in \
  "519E74EE9A65A441395531E91E6BEB6FED57655B https://github.com/smockle.gpg" \
  "968479A1AFF927E37D1A566BB5690EEEBB952194 https://github.com/web-flow.gpg"
do
  fpr="${key%% *}"
  url="${key#* }"
  curl -fsSL "$url" | gpg --import >/dev/null 2>&1
  if gpg --list-secret-keys >/dev/null 2>&1 && gpg --with-colons --list-keys "$fpr" 2>/dev/null | grep -q '^pub:'; then
    printf 'y\n' | gpg --batch --yes --command-fd 0 --edit-key "$fpr" lsign save >/dev/null 2>&1
  fi
done
