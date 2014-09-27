##
## PLATFORM-INDEPENDENT
##

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
export HISTCONTROL=ignoreboth

# Make specific commands not show up in history.
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less -X"

# Always enable colored grep output.
export GREP_OPTIONS="--color=auto"

# Detect which ls flavor is in use.
if ls --color > /dev/null 2>&1; then # GNU ls
	colorflag="--color"
else # OS X ls
	colorflag="-G"
fi

# Always use color output for ls.
alias ls="command ls ${colorflag}"
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
}

if [[ $platform == 'windows' ]]; then
    # Add hub alias
    alias git='hub'
else
    # Add hub alias
    eval "$(hub alias -s)"
fi

# Use git diff instead of diff.
alias diff='git diff'

# Enable tab completion for gulp
eval "$(gulp --completion=bash)"
_gulp_completions() {
  # The currently-being-completed word.
  local cur="${COMP_WORDS[COMP_CWORD]}"
  #Grab tasks
  local compls=$(gulp --tasks-simple)
  # Tell complete what stuff to show.
  COMPREPLY=($(compgen -W "$compls" -- "$cur"))
}
complete -o default -F _gulp_completions gulp

##
## WINDOWS-SPECIFIC
##


if [[ $platform == 'windows' ]]; then
    cd ~

    # ifconfig does not exist in Git Bash (Windows).
    alias ifconfig='ipconfig'

    # more does not exist in Git Bash (Windows).
    alias more='less'

    # open does not exist in Git Bash (Windows).
    alias open='start'

    # Open files from the command line in Brackets.
    brackets() {
      ifile = ''
      if [[ "$1" == */c/* || "$1" == *c:* ]]; then
        ifile += "$1"
      else
        ifile += $(echo -n $(pwd))
        ifile += /"$1"
      fi
      /c/Program\ Files\ \(x86\)/Brackets/Brackets.exe "$ifile"
    }

    # Open Visual Studio from the command line.
    alias vs='/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 12.0/Common7/IDE/devenv.exe'
fi


##
## OSX-SPECIFIC
##


if [[ $platform == 'osx' ]]; then
    # Enable brew's bash completion
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
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

    # Flush DNS cache.
    alias flush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

    # Show/hide hidden files in Finder
    alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

    # Open Brackets from the command line.
    alias brackets="open /Applications/Brackets.app"
fi


##
## NON-WINDOWS
##


if [[ $platform != 'windows' ]]; then
    # Set default editor to nano
    export EDITOR=nano

    # Add ~/bin to $PATH
    export PATH="$PATH:$HOME/bin"

    # Add $(brew --prefix)/bin to $PATH.
    export PATH="$(brew --prefix)/bin:$PATH"

    # Add heroku to $PATH.
    # export PATH="/usr/local/heroku/bin:$PATH"

    # Add travis to $PATH.
    [ -f /Users/clay/.travis/travis.sh ] && source /Users/clay/.travis/travis.sh

    # Add stapler to $PATH.
    export PATH="$HOME/Projects/stapler:$PATH"

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

    # Set wget download location.
    alias wget='wget -P ~/Downloads'

    # Add tab completion for sudo.
    complete -cf sudo

    # Start fasd
    eval "$(fasd --init auto)"
    _shibboleth_cd() {
      if [[ -d $1 ]]; then
          cd "$1"
      elif [[ -f $1 ]]; then
          cd $(dirname "$1")
      else
          fasd_cd -d "$1"
      fi
    }
    alias cd="_shibboleth_cd"
fi


##
## CROSS-PLATFORM
##


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
  fi
}
