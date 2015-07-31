#!/usr/bin/env bash

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
export PROMPT_COMMAND="if [[ \$PROMPTED = true ]]; then echo ''; fi; export PROMPTED=true; $PROMPT_COMMAND"

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

# Set Go environment variables
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# Set Node environment variables
export NODE_REPL_HISTORY_FILE="$HOME/.node_history"

# Update monkeydo.
_update_monkeydo() {
  monkeydo update
}

# Update the Node Package Manager and Node packages.
# https://gist.github.com/othiym23/4ac31155da23962afd0e
_update_npm_bloody() {
  npm i -g npm@next
  for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f3)
  do
    npm i -g "$package"
  done
}

_update_npm() {
  npm i -g npm@3.0-latest
  for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f3)
  do
    npm i -g "$package"
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

  # Add nvmw to $PATH.
  export NVMW_HOME="C:\\Users\\clay\\.nvmw\\"
  nvmw use iojs > /dev/null
  alias node='iojs'
  export PATH="$HOME/.nvmw/iojs/latest:$PATH"

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
  # Source nvm
  source ~/.nvm/nvm.sh
  [[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

  # Set NVM mirror
  # export NVM_NODEJS_ORG_MIRROR=npm.taobao.org/mirrors/node/
  export NVM_NODEJS_ORG_MIRROR=https://nodejs.org/dist
  export NVM_IOJS_ORG_MIRROR=https://iojs.org/dist

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

  # Add chefdk to $PATH.
  # Works around https://github.com/chef/chef-dk/issues/419.
  export PATH="/opt/chefdk/bin:$PATH"

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

# Update hosts file.
_update_hosts() {
  wget -N -P ~/Projects/dotfiles http://someonewhocares.org/hosts/hosts

  if [[ $platform == 'osx' ]]; then
    sudo cp -f ~/Projects/dotfiles/hosts /etc/hosts
    dscacheutil -flushcache
  elif [[ $platform == 'windows' ]]; then
    sudo move "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts.bak"
    sudo copy "C:\Users\clay\Projects\dotfiles\hosts" "C:\Windows\System32\drivers\etc\hosts"
  fi
}

# Download and import GPG public keys for everyone I track on https://keybase.io.
_update_keys() {
  keybase list-tracking | xargs -I_ curl https://keybase.io/_/key.asc | gpg --import
}

# Predictive cd
_shibboleth_cd() {
  ARGS="${@}"
  LAST_ARG="${@: -1}"
  OPTS=""
  if [[ "$ARGS" != "$LAST_ARG" ]]; then
    OPTS="${ARGS% *}"
  fi

  if [[ -z "$LAST_ARG" ]]; then
    # echo "No argument given. Fallback to command cd."
    command cd "$@"
  elif [[ -d "$LAST_ARG" ]]; then
    # echo "Last argument is a directory. Change to it.
    command cd "$@"
  elif [[ -f "$LAST_ARG" ]]; then
    # echo "Last argument is a file. Change to the directory that contains it."
    command cd $OPTS "$(dirname "$LAST_ARG")"
  elif [[ "${LAST_ARG::1}" == "-" ]]; then
    # echo "Last argument is an option. Fallback to command cd."
    command cd "$@"
  elif [[ ! -z "$(fasd -d "$LAST_ARG")" ]]; then
    # echo "Last argument is a directory. Change to it.
    # echo "${green}$(fasd -d "$LAST_ARG")${reset}"
    command cd $OPTS "$(fasd -d "$LAST_ARG")"
  elif [[ ! -z "$(fasd -f "$LAST_ARG")" ]]; then
    # echo "Last argument is a file. Change to the directory that contains it."
    # echo "${green}$(dirname "$(fasd -f "$LAST_ARG")")${reset}"
    command cd $OPTS "$(dirname "$(fasd -f "$LAST_ARG")")"
  else
    # echo "Fallback to command cd."
    command cd "$@"
  fi
}
alias cd='_shibboleth_cd'

# Predictive ls
_shibboleth_ls() {
  ARGS="${@}"
  LAST_ARG="${@: -1}"
  OPTS=""
  if [[ "$ARGS" != "$LAST_ARG" ]]; then
    OPTS="${ARGS% *}"
  fi

  if [[ -z "$LAST_ARG" ]]; then
    # echo "No argument given. List the current directory."
    ls "$@"
  elif [[ -d "$LAST_ARG" ]]; then
    # echo "Last argument is a directory. List it."
    ls "$@"
  elif [[ -f "$LAST_ARG" ]]; then
    # echo "Last argument is a file. List the directory that contains it."
    echo "${green}$(dirname "$LAST_ARG")${reset}"
    ls "$(dirname "$LAST_ARG")"
  elif [[ "${LAST_ARG::1}" == "-" ]]; then
    # echo "Last argument is an option. Fallback to command ls."
    ls "$@"
  elif [[ ! -z "$(fasd -d "$LAST_ARG")" ]]; then
    # echo "Last argument is a directory. List it."
    echo "${green}$(fasd -d "$LAST_ARG")${reset}"
    ls $OPTS "$(fasd -d "$LAST_ARG")"
  elif [[ ! -z "$(fasd -f "$LAST_ARG")" ]]; then
    # echo "Last argument is a file. List the directory that contains it."
    echo "${green}$(dirname "$(fasd -f "$LAST_ARG")")${reset}"
    ls $OPTS "$(dirname "$(fasd -f "$LAST_ARG")")"
  else
    # echo "Fallback to command ls."
    ls "$@"
  fi
}
alias ls='_shibboleth_ls'

# Predictive less
_shibboleth_less() {
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
  elif [[ -f "$LAST_ARG" ]]; then
    # echo "Last argument is a file. Display its contents."
    less "$@"
  elif [[ "${LAST_ARG::1}" == "-" ]]; then
    # echo "Last argument is an option. Fallback to command less."
    less "$@"
  elif [[ ! -z "$(fasd -d "$LAST_ARG")" ]]; then
    # echo "List the specified directory."
    echo "${green}$(fasd -d "$LAST_ARG")${reset}"
    ls "$(fasd -d "$LAST_ARG")"
  elif [[ ! -z "$(fasd -f "$LAST_ARG")" ]]; then
    # echo "Last argument is a file. Display its contents."
    echo "${green}$(fasd -f "$LAST_ARG")${reset}"
    less $OPTS "$(fasd -f "$LAST_ARG")"
  else
    # echo "Fallback to command less."
    less "$@"
  fi
}
alias less='_shibboleth_less'
alias more='less'

# Teach open about the Internet
_shibboleth_open() {
  ARGS="${@}"
  LAST_ARG="${@: -1}"
  OPTS=""
  if [[ "$ARGS" != "$LAST_ARG" ]]; then
    OPTS="${ARGS% *}"
  fi

  if [[ -z $@ ]]; then
    # echo "No argument given. Fallback to command open."
    open "$@"
  elif [[ -e "$LAST_ARG" ]]; then
    # echo "Last argument is a file or directory. Open it."
    open "$@"
  elif [[ "${LAST_ARG::1}" == "-" ]]; then
    # echo "Last argument is an option. Fallback to command open."
    open "$@"
  elif ([[ ${LAST_ARG,,} == *".co"* ]] ||
        [[ ${LAST_ARG,,} == *".me"* ]] ||
        [[ ${LAST_ARG,,} == *".org"* ]] ||
        [[ ${LAST_ARG,,} == *".net"* ]] ||
        [[ ${LAST_ARG,,} == *".gov"* ]] ||
        [[ ${LAST_ARG,,} == *".io"* ]] ||
        [[ ${LAST_ARG,,} == *"localhost"* ]]) &&
        [[ ! ${LAST_ARG,,} == *"http"* ]]; then
    # echo "Last argument is a website. Open it."
    open $OPTS "http://${LAST_ARG}"
  else
    # echo "Fallback to command open."
    open "$@"
  fi
}
alias open='_shibboleth_open'

# From http://stackoverflow.com/a/21951256/1923134
abspath() {
  local thePath

  if [[ ! "$1" =~ ^/ ]];then
    thePath="$PWD/$1"
  else
    thePath="$1"
  fi

  echo "$thePath"|(
    IFS=/
    read -a parr
    declare -a outp
    for i in "${parr[@]}"; do
      case "$i" in
      ''|.) continue ;;
      ..)
        len=${#outp[@]}
        if ((len==0));then
          continue
        else
          unset outp[$((len-1))]
        fi
        ;;
      *)
        len=${#outp[@]}
        outp[$len]="$i"
        ;;
      esac
    done
    echo /"${outp[*]}"
  )
}

_shibboleth_ln() {
  if [[ $platform != 'windows' ]]; then
    command ln "$@"
  else
    # 1. Enable symlinks for all 'Users':
    # Start -> Run -> "secpol.msc"
    # Add 'Users' to Security Settings -> Local Policies -> User Rights Assignment -> "Create symbolic links"

    # HACK: Since users in the 'Administrator' group cannot run 'mklink'
    # 2. Enable guest account:
    # Start -> Run -> "secpol.msc"
    # Enable 'Guest' account at Security Settings -> Local Policies -> Security Options -> "Accounts: Guest account status"
    # Add 'Everyone' to Security Settings -> Local Policies -> User Rights Assignment -> "Access this computer from the network"
    # Remove 'Guest' from Security Settings -> Local Policies -> User Rights Assignment -> "Deny access to this computer from the network"
    # Remove 'Guest' from Security Settings -> Local Policies -> User Rights Assignemnt -> "Deny log on locally"

    # 3. Grant access to source/target files/directories:
    # Add 'Everyone' to Right click file/directory -> Properties -> Security -> Edit -> Add…
    # Set 'Full Control' permissions for 'Everyone'

    IFS=-
    set "$@"
    SOURCE="$(abspath "$1" | sed 's|^/\([a-z]\)/|\1:/|' | sed 's|/|\\|g')"
    TARGET="$(abspath "$2" | sed 's|^/\([a-z]\)/|\1:/|' | sed 's|/|\\|g')"
    runas /user:guest "cmd /c \"mklink \"$TARGET\" \"$SOURCE\"\""
  fi
}
alias ln='_shibboleth_ln'

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
  if [[ $platform == 'osx' ]]; then
    _update_monkeydo
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
  _update_hosts
  _update_keys
}

# Remove all Docker images, containers and/or volumes.
docker-clean() {
  eval "$(docker-machine env)"
  command=$1
  case $command in
  "images")
    echo "${green}Removing Docker images.${reset}"
    if [[ ! -z $(docker images -q) ]]; then
      docker rmi $(docker images -q)
    fi
  ;;
  "containers")
    echo "${green}Removing Docker containers.${reset}"
    if [[ ! -z "$(docker ps -a -q)" ]]; then
      docker rm $(docker ps -a -q)
    fi
  ;;
  "volumes")
    echo "${green}Removing Docker volumes.${reset}"
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes
  ;;
  *)
    echo "${green}Removing Docker volumes.${reset}"
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes

    echo ""
    echo "${green}Removing Docker images.${reset}"
    if [[ ! -z $(docker images -q) ]]; then
      docker rmi $(docker images -q)
    fi

    echo ""
    echo "${green}Removing Docker containers.${reset}"
    if [[ ! -z "$(docker ps -a -q)" ]]; then
      docker rm $(docker ps -a -q)
    fi
  ;;
  esac
  return $?
}
