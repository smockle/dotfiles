# Add `rvm` to `$PATH`.
export PATH="$PATH:/opt/local/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# Add `heroku` to `$PATH`.
export PATH="/usr/local/heroku/bin:$PATH"

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
alias trash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Update `ruby`, `brew` and `npm`, and their installed packages.
# Update /etc/hosts.
alias update='brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; gem update; wget -N -P ~/Projects/dotfiles http://someonewhocares.org/hosts/hosts; dscacheutil -flushcache'

# Set `wget` download location.
alias wget='wget -P ~/Downloads'

# OS X has no `md5sum`, so use `md5` as a fallback.
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback.
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Add tab completion for `rvm`.
source ~/.rvm/scripts/rvm

# Add tab completion for `brew`.
source `brew --repository`/Library/Contributions/brew_bash_completion.sh
