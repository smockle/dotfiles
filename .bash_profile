##
## PLATFORM-INDEPENDENT
##

[ -r "$HOME/.bash_prompt" ] && [ -f "$HOME/.bash_prompt" ] && source "$HOME/.bash_prompt"

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

# Set default editor to nano
export EDITOR=nano

# Set default tidy config file
export HTML_TIDY="$HOME/.tidyrc"

# Add ~/bin to $PATH
export PATH="$PATH:$HOME/bin"

# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
export HISTCONTROL=ignoreboth

# Make specific commands not show up in history.
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Ellipsize directory path in prompt, when necessary.
export PROMPT_DIRTRIM=2

# Make commands in one terminal instantly available to commands in another.
export PROMPTED=false
export PROMPT_COMMAND="history -a; history -c; history -r; if [[ \$PROMPTED = true ]]; then echo ''; fi; export PROMPTED=true; $PROMPT_COMMAND"

# Use color output for less.
export LESS=-RXE

# Highlight section titles in manual pages.
export LESS_TERMCAP_md=$orange

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less"

# Detect which ls flavor is in use.
if ls --color > /dev/null 2>&1; then # GNU ls
  alias ls="command ls --color"
else # OS X ls
  alias ls="command ls -G"
fi

# Always use color output for ls.
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Update monkeydo.
_update_monkeydo() {
  monkeydo update
}

# Update the Node Package Manager and Node packages.
# https://gist.github.com/othiym23/4ac31155da23962afd0e
_update_npm_bloody() {
  npm -g install npm@next
  for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f3)
  do
    npm -g install "$package"
  done
}

_update_npm() {
  npm -g install npm@latest
  for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f3)
  do
    npm -g install "$package"
  done
}

# Update Ruby gems and the Heroku toolbelt.
_update_gems() {
  gem update
  heroku update
  heroku plugins:update
}

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
  *)
    hub "${command}" "$@"
  ;;
  esac
  return $?
}

# Use git diff instead of diff.
alias diff='git diff'


##
## WINDOWS-SPECIFIC
##


if [[ $platform == 'windows' ]]; then
  command cd ~

  # Add fasd to $PATH
  export PATH="/c/Users/Clay/Projects/fasd:$PATH"

  # Add hub to $PATH
  export PATH="/c/Program Files/hub:$PATH"

  # ifconfig does not exist in Git Bash (Windows).
  alias ifconfig='ipconfig'

  # more does not exist in Git Bash (Windows).
  alias more='less'

  # open does not exist in Git Bash (Windows).
  alias open='start'
fi


##
## OSX-SPECIFIC
##


if [[ $platform == 'osx' ]]; then
  # Add $(brew --prefix)/bin to $PATH.
  export PATH="$(brew --prefix)/bin:$PATH"

  # Enable brew's bash completion
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    . "$(brew --prefix)/etc/bash_completion"
  fi

  # Set $ATOM_PATH
  if [[ -d "$HOME/Applications/Atom.app" ]]; then
    export ATOM_PATH="$HOME/Applications"
  elif [[ -d "/Applications/Atom.app" ]]; then
    export ATOM_PATH="/Applications"
  fi

  # Add psql to $PATH.
  export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"

  # Update Homebrew and Homebrew packages.
  _update_brew() {
    brew update
    brew upgrade
    brew cleanup
    brew cask cleanup
  }

  # Update Python utilities.
  _update_python() {
    pip install --upgrade setuptools
    pip install --upgrade pip
  }

  _update_osx() {
    sudo softwareupdate -i -a
  }

  # Empty the Trash on all mounted volumes and the main HDD.
  # Clear Apple’s System Logs to improve shell startup speed.
  trash() {
    sudo rm -rfv /Volumes/*/.Trashes
    sudo rm -rfv ~/.Trash
    sudo rm -rfv /private/var/log/asl/*.asl
  }
fi


##
## NON-WINDOWS
##


if [[ $platform != 'windows' ]]; then
  # Always enable colored grep output.
  export GREP_OPTIONS="--color=auto"

  # Add travis to $PATH.
  [ -f /Users/clay/.travis/travis.sh ] && source /Users/clay/.travis/travis.sh

  # Add rvm to $PATH
  export PATH="$PATH:$HOME/.rvm/bin"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

  # Update the Ruby Version Manager and Ruby.
  _update_rvm() {
    rvm requirements
    rvm get head
    rvm requirements
    rvm install 2.1
    rvm use 2.1
    rvm default 2.1
  }

  # Update hosts file.
  _update_hosts() {
    wget -N -P ~/Projects/dotfiles http://someonewhocares.org/hosts/hosts
    sudo cp -f ~/Projects/dotfiles/hosts /etc/hosts
    dscacheutil -flushcache
  }

  # Download and import GPG public keys for everyone I track on https://keybase.io.
  _update_keys() {
    keybase list-tracking | xargs -I_ curl https://keybase.io/_/key.asc | gpg --import
  }

  # Set wget download location.
  alias wget='wget -P ~/Downloads'

  # Add tab completion for sudo.
  complete -cf sudo
fi


##
## CROSS-PLATFORM
##

# Start fasd
eval "$(fasd --init auto)"
_shibboleth_cd() {
  if [[ -d $1 ]]; then
    command cd "$1"
  elif [[ -f $1 ]]; then
    command cd "$(dirname "$1")"
  else
    fasd_cd -d "$1"
  fi
}
alias cd='_shibboleth_cd'

mdn() {
  if [[ $platform == 'windows' ]]; then
    start "http://mdn.io/$(echo "$@")"
  else
    open "http://mdn.io/$(echo "$@")"
  fi
}

verbose() {
  _shibboleth_cd_verbose() {
    _shibboleth_cd "$@" && ls -a
  }
  alias cd='_shibboleth_cd_verbose'
  echo "Maximum verbosity"
}

brief() {
  _shibboleth_cd_brief() {
    _shibboleth_cd "$@" && ls
  }
  alias cd='_shibboleth_cd_brief'
  echo "Medium verbosity"
}

superbrief() {
  alias cd='_shibboleth_cd'
  echo "Low verbosity"
}

splash() {
  echo "But nothing happened."
}

xyzzy() {
  echo "A hollow voice says, 'Fool.'"
}

alias wait="echo \"Time passes.\" && wait"

# Update system.
update() {
  _update_monkeydo
  if [[ $platform == 'osx' ]]; then
    _update_brew
    _update_python
  fi
  _update_npm
  if [[ $platform != 'windows' ]]; then
    _update_rvm
  fi
  _update_gems
  if [[ $platform == 'osx' ]]; then
    _update_osx
  fi
  if [[ $platform != 'windows' ]]; then
    _update_hosts
    _update_keys
  fi
}
