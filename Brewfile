# brew tap
tap "oven-sh/bun"

# brew list --installed-on-request
brew "gh"
brew "git"
brew "gnupg"
brew "gnutls"
brew "jq"
brew "node@24", postinstall: 'test -e "${HOMEBREW_PREFIX}/bin/node" || ln -s "${HOMEBREW_PREFIX}/opt/node@24" "${HOMEBREW_PREFIX}/bin/node"' # link node@24 to the node directory brew-installed prettier requires
brew "nvm"
brew "pinentry-mac"
brew "prettier", args: ["ignore-dependencies"] # ignore prettier’s dependency on node (providing node@24 instead)
brew "ripgrep"
brew "ruby"
brew "oven-sh/bun/bun"

# brew list --casks -1
cask "1password"
cask "bettertouchtool"
cask "copilot-cli"
cask "google-chrome"
cask "microsoft-auto-update"
cask "microsoft-teams"
cask "orbstack"
cask "visual-studio-code@insiders"
cask "zoom"

# code --list-extensions
vscode "esbenp.prettier-vscode"
vscode "github.codespaces"
vscode "ms-vscode-remote.remote-containers"
vscode "tyriar.sort-lines"
