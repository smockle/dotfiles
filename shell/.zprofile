#!/usr/bin/env zsh

# Enable experimental Docker CLI features
export DOCKER_CLI_EXPERIMENTAL="enabled"

# Set default editor to Vi
export EDITOR=vi

# Skip repeated commands in history.
setopt histignoredups

# Increase the maximum number of lines contained in the history file
# (default is 500)
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTFILE=~/.zhistory

# Homebrew path prefix
HOMEBREW_PREFIX=$(dirname "$(dirname "$(whence -p brew)")")
export HOMEBREW_PREFIX

# Always use color output for ls.
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Don’t clear the screen after paging.
export LESS=-RXE

# Highlight section titles in manual pages.
# [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null && LESS_TERMCAP_md=$(tput setaf 3)
# export LESS_TERMCAP_md

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less"

# Ellipsize directory path in prompt, when necessary.
export PROMPT_DIRTRIM=2

# Use 256 colors
infocmp xterm-256color >/dev/null 2>&1 && export TERM='xterm-256color'

declare -a PATH_ADDITIONS=(
  "${HOMEBREW_PREFIX}/opt/node@10/bin" # Add brew-install node@10
  "${HOMEBREW_PREFIX}/share/npm/bin" # Add npm-installed package bin
  "${HOMEBREW_PREFIX}/sbin"
  "${HOMEBREW_PREFIX}/bin"
  "${HOME}/Library/Python/2.7/bin" # Add 'pip --user'-installed package bin
)
for p in $PATH_ADDITIONS; do
  if [ -d "${p}" ]; then
    PATH="${p}:$PATH"
  fi
done
unset PATH_ADDITIONS
export PATH

# Case-insensitive globbing (used in pathname expansion)
unsetopt CASE_GLOB

# Use the string that has already been typed as the prefix for searching
# through commands (i.e. more intelligent Up/Down-arrow behavior)
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Move cursor forward/backward by word (⌥→/⌥←)
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# Edit commands in vi
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "v" edit-command-line

# Fix backspace when existing vi mode
bindkey -v "^?" backward-delete-char

# Use git diff instead of diff
alias diff="git diff"

# Always enable colored `grep` output
alias grep='grep --color=auto'

# Use colors in ls
alias ls="command ls -G"

# Use custom git subfunctions
source "${HOME}/Developer/dotfiles/git/git"

# Set prompt
source "${HOME}/.zprompt"
