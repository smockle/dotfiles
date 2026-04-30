# brew tap
tap "oven-sh/bun"

# brew list --installed-on-request
brew "gh", postinstall: <<~EOS
  gh extension install --force github/gh-aw
  gh extension install --force github/gh-models
EOS
brew "git"
brew "gnupg"
brew "gnutls"
brew "jq"
brew "mas"
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

# mas list
mas "Amphetamine", id: 937984704
mas "Apple Configurator", id: 1037126344
mas "iMovie", id: 408981434
mas "Keynote", id: 361285480
mas "Microsoft Remote Desktop", id: 1295203466
mas "Numbers", id: 361304891
mas "Pages", id: 361309726
mas "Parcel", id: 375589283
mas "Pixelmator Pro", id: 1289583905
mas "The Unarchiver", id: 425424353
mas "Wipr", id: 1662217862
mas "Xcode", id: 497799835

# code --list-extensions
vscode "esbenp.prettier-vscode"
vscode "github.codespaces"
vscode "ms-vscode-remote.remote-containers"
vscode "tyriar.sort-lines"
