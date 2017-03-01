#!/usr/bin/env bash

##
## SOURCES
##

# BASH
# Style prompt
[ -r "$HOME/.bash_prompt" ] && [ -f "$HOME/.bash_prompt" ] && source "$HOME/.bash_prompt"

# BREW
# Enable brew's bash completion
if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  . "$(brew --prefix)/etc/bash_completion"
fi

# SUDO
# Add tab completion for sudo.
complete -cf sudo

##
## PATH
##

# Add ~/bin to $PATH
export PATH="$PATH:$HOME/bin"

# BREW
# Add $(brew --prefix)/bin to $PATH.
command -v brew >/dev/null 2>&1 && { export PATH="$(brew --prefix)/bin:$PATH" >&2; }

# NVS
export NVS_HOME="$HOME/.nvs"
[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"

# TRAVIS
# Add travis to $PATH.
[ -f /Users/clay/.travis/travis.sh ] && source /Users/clay/.travis/travis.sh

##
## SETTINGS
##

# ATOM
# Set $ATOM_PATH
if [[ -d "$HOME/Applications/Atom.app" ]]; then
  export ATOM_PATH="$HOME/Applications"
elif [[ -d "/Applications/Atom.app" ]]; then
  export ATOM_PATH="/Applications"
fi

# BASH
# Set default editor to nano
export EDITOR=nano

# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
export HISTCONTROL=ignoreboth

# Make specific commands not show up in history.
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Ellipsize directory path in prompt, when necessary.
export PROMPT_DIRTRIM=2

# Display a newline before new prompts
export PROMPTED=false
export PROMPT_COMMAND="if [[ \$PROMPTED = true ]]; then echo ''; fi; export PROMPTED=true; $PROMPT_COMMAND"

# GREP
# Always enable colored grep output.
export GREP_OPTIONS="--color=auto"

# LESS
# Apply syntax highlighting
hilite=$(which highlight)
export LESSOPEN="| $hilite %s --out-format xterm256 --quiet --force --style oceanic-next "

# Use color output for less.
export LESS=-RXE

# Highlight section titles in manual pages.
export LESS_TERMCAP_md=$orange

# LS
# Always use color output for ls.
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# MAN
# Don’t clear the screen after quitting a manual page.
export MANPAGER="less"

##
## COMMAND ALIASES
##

# ATOM BETA
alias atom='atom-beta'
alias apm='apm-beta'

# BREW
brew() {
  command=$1
  shift 1
  case $command in
  # Remove installed depedencies that are no longer used.
  "unbrew")
    command brew list | xargs -I{} sh -c 'printf "{}: "; echo `command brew uses --installed --recursive {}`;' | grep -vE '(bash|bash-completion|curl|flow|git|highlight|hub|mongodb|photoshop-jpegxr|photoshop-webp|watchman|wget)' | cut -d':' -f1 | xargs command brew uninstall
  ;;
  *)
    command brew "${command}" "$@"
  ;;
  esac
  return $?
}

# CD
__cd__() {
  ARGS="${@}"
  LAST_ARG="${@: -1}"
  OPTS=""
  if [[ "$ARGS" != "$LAST_ARG" ]]; then
    OPTS="${ARGS% *}"
  fi

  if [[ -f "$LAST_ARG" ]]; then
    # echo "Last argument is a file. Change to the directory that contains it."
    command cd $OPTS "$(dirname "$LAST_ARG")"
  else
    # echo "Fallback to command cd."
    command cd "$@"
  fi
}
alias cd='__cd__'

# DIFF
# Use git diff instead of diff.
alias diff='git diff'

# GIT
# Add hub alias.
git() {
  command=$1
  shift 1
  case $command in
  # Create a new branch with the same name if one does not exist,
  # safer than `git config --global push.default current`.
  "push")
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    if [[ -z $(git config "branch.$BRANCH_NAME.merge") && -z "$@" ]]; then
      hub push --set-upstream origin "$BRANCH_NAME"
    elif [[ -z $(git config "branch.$BRANCH_NAME.merge") ]]; then
      hub push --set-upstream "$@"
    else
      hub push "$@"
    fi
  ;;
  # Check other host if no repo exists at default host.
  "clone")
    hub clone "$@"
    if [ $? -eq 1 ]
    then
      GITHUB_HOST=$(git config --global hub.host) hub clone "$@"
    fi
  ;;
  # Remove all local branches that have been merged into master.
  # http://stackoverflow.com/a/17029936/1923134
  "unbranch")
    git fetch --prune && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
  ;;
  "diff")
    hub diff --color "$@" | diff-so-fancy
  ;;
  *)
    hub "${command}" "$@"
  ;;
  esac
  return $?
}

# LS
# Detect which ls flavor is in use.
if ls --color > /dev/null 2>&1; then # GNU ls
  alias ls="command ls --color"
else # OS X ls
  alias ls="command ls -G"
fi

__ls__() {
  ARGS="${@}"
  LAST_ARG="${@: -1}"
  OPTS=""
  if [[ "$ARGS" != "$LAST_ARG" ]]; then
    OPTS="${ARGS% *}"
  fi

  if [[ -f "$LAST_ARG" ]]; then
    # echo "Last argument is a file. List the directory that contains it."
    echo "${green}$(dirname "$LAST_ARG")${reset}"
    ls "$(dirname "$LAST_ARG")"
  else
    # echo "Fallback to command ls."
    ls "$@"
  fi
}
alias ls='__ls__'

# LESS
__less__() {
  ARGS="${@}"
  LAST_ARG="${@: -1}"
  OPTS=""
  if [[ "$ARGS" != "$LAST_ARG" ]]; then
    OPTS="${ARGS% *}"
  fi

  if [[ -z "$LAST_ARG" ]]; then
    # echo "No argument given. List the current directory."
    echo "${green}. is a directory${reset}"
    ls .
  elif [[ -d "$LAST_ARG" ]]; then
    # echo "Last argument is a directory. List it."
    echo "${green}$LAST_ARG is a directory${reset}"
    ls "$LAST_ARG"
  else
    # echo "Fallback to command less."
    less "$@"
  fi
}
alias less='__less__'

# MORE
alias more='less'

# NVS
eval "_$(declare -f nvs)"
nvs() {
  command=$1
  shift 1
  case $command in
  "upgrade")
    # Store old version
    local OLD=$(_nvs ls | grep '>' | tr -d '>#')
    local LTS='node/6'
    # Determine new version to install
    NEW='latest'
    if [ "$(echo $OLD | grep $LTS)" ]; then
      NEW='lts'
    fi
    # Install and use new version
    _nvs add $NEW && _nvs use $NEW
    # Compare old and new versions
    NEW=$(_nvs ls | grep '>' | tr -d '>#')
    if [ "$NEW" != "$OLD" ]; then
      # Migrate old version to new version, uninstall old version, and link new version
      _nvs migrate $OLD $NEW && _nvs rm $OLD && _nvs link
    fi;
  ;;
  *)
    _nvs "${command}" "$@"
  ;;
  esac
  return $?
}

##
## CUSTOM COMMANDS
##g

# CD
verbose() {
  __cd__verbose() {
    __cd__ "$@" && ls -a
  }
  alias cd='__cd__verbose'
  echo "Maximum verbosity"
}

brief() {
  __cd__brief() {
    __cd__ "$@" && ls
  }
  alias cd='__cd__brief'
  echo "Medium verbosity"
}

superbrief() {
  alias cd='__cd__'
  echo "Low verbosity"
}

# KEYBASE
# Download and import GPG public keys for everyone I track on https://keybase.io.
get_keys() {
  keybase list-tracking | xargs -I_ curl https://keybase.io/_/key.asc | gpg --import
}

# TRASH
# Empty the Trash on all mounted volumes and the main HDD.
# Clear Apple’s System Logs to improve shell startup speed.
trash() {
  sudo rm -rfv /Volumes/*/.Trashes
  sudo rm -rfv ~/.Trash
  sudo rm -rfv /private/var/log/asl/*.asl
}
