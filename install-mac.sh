#!/usr/bin/env sh

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew install autoconf automake bash-completion brew-cask cloog-ppl015 fasd freetype gdbm ghi git gmp4 heroku-toolbelt hub imagemagick jpeg libgpg-error libiconv libksba libmpc08 libpng libtool libxml2 libxslt libyaml makedepend mpfr2 node openssl pkg-config ppl011 python readline sqlite wget xz

brew cask install atom anvil backblaze brackets dropbox-experimental eclipse-java firefox-nightly flash google-chrome-canary hipchat java onepassword-beta postgres rdio skype spotify steam vmware-fusion xamarin-studio

open '/opt/homebrew-cask/Caskroom/backblaze/latest/Backblaze Installer.app'
