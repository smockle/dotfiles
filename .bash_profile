# Set default editor to nano.
export EDITOR=nano

# Add `rvm` to `$PATH`.
export PATH="$PATH:/opt/local/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# Add `$(brew --prefix)/bin` to `$PATH`.
export PATH="$(brew --prefix)/bin:$PATH"

# Add `heroku` to `$PATH`.
# export PATH="/usr/local/heroku/bin:$PATH"

# Add `psql` to `$PATH`.
export PATH="/Applications/Postgres93.app/Contents/MacOS/bin:$PATH"

# Add `stapler` to `$PATH`.
export PATH="$HOME/Projects/stapler:$PATH"

# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
export HISTCONTROL=ignoreboth

# Make specific commands not show up in history.
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less -X"

# Always enable colored `grep` output.
export GREP_OPTIONS="--color=auto"

# Detect which `ls` flavor is in use.
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# Always use color output for `ls`.
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Empty the Trash on all mounted volumes and the main HDD.
# Clear Apple’s System Logs to improve shell startup speed.
trash() {
  sudo rm -rfv /Volumes/*/.Trashes
  sudo rm -rfv ~/.Trash
  sudo rm -rfv /private/var/log/asl/*.asl
}

# Update Homebrew and Homebrew packages.
_update_brew() {
  brew update
  brew upgrade
  brew cleanup
}

# Update the Node Package Manager and Node packages.
_update_npm() {
  npm update npm -g
  npm update -g
}

# Update the Ruby Version Manager and Ruby.
_update_rvm() {
  rvm requirements
  rvm get head
  rvm requirements
  rvm install 2.1.0
  rvm use 2.1.0
  rvm default 2.1.0
}

# Update Ruby gems and the Heroku toolbelt.
_update_gems() {
  gem update
  heroku update
}

_update_osx() {
  sudo softwareupdate -i -a
}

# Update hosts file.
_update_hosts() {
  wget -N -P ~/Projects/dotfiles http://someonewhocares.org/hosts/hosts
  cp -f ~/Projects/dotfiles/hosts /etc/hosts
  dscacheutil -flushcache
}

# Update system.
update() {
  _update_brew
  _update_npm
  _update_rvm
  _update_gems
  _update_osx
  _update_hosts
}

# Set `curl` download location.
_curl() { (cd ~/Downloads && curl $*) }
# alias curl='_curl'

# Set `wget` download location.
alias wget='wget -P ~/Downloads'

# Perform bundle operations.
alias buns='bundle install && bundle update'

# Flush DNS cache.
alias flush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Add hub alias
eval "$(hub alias -s)"

# OS X has no `md5sum`, so use `md5` as a fallback.
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback.
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Use `hk` instead of `heroku`.
alias heroku='hk'

# Use `git diff` instead of `diff`.
alias diff='git diff'

# Add tab completion for `sudo`.
complete -cf sudo

# Add tab completion for `rvm`.
source ~/.rvm/scripts/rvm

# Add tab completion for `brew`.
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Add tab completion for `yo`.
# https://gist.github.com/natchiketa/6095984
function _yo_generator_complete_() {
	local local_modules=$(if [ -d node_modules ]; then echo "node_modules:"; fi)
	local usr_local_modules=$(if [ -d /usr/local/lib/node_modules ]; then echo "/usr/local/lib/node_modules:"; fi)
	local win_roam_modules=$(if [ -d $(which yo)/../node_modules ]; then echo "$(which yo)/../node_modules:"; fi)
	local node_dirs="${local_modules}${usr_local_modules}${win_roam_modules}${NODE_PATH}"
	local generators_all=$(for dir in $(echo $node_dirs | tr ":" "\n"); do command ls -1 $dir | grep ^generator- | cut -c11-; done)
	local word=${COMP_WORDS[COMP_CWORD]}
	local generators_filtered=$(if [ -z "$word" ]; then echo "$generators_all"; else echo "$generators_all" | grep $word; fi)
	COMPREPLY=($generators_filtered)
}
complete -F _yo_generator_complete_ yo
