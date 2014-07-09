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
_update_npm() {
  npm update npm -g
  npm update -g
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


##
## WINDOWS-SPECIFIC
##


if [[ $platform == 'windows' ]]; then
    cd ~
    
    # more does not exist in Git Bash (Windows).
    alias more='less'

    # ifconfig does not exist in Git Bash (Windows).
    alias ifconfig='ipconfig'

    # Open files from the command line in Brackets.
    brackets() {
      ifile=''
      if [ $1 == */c/* ] || [ $1 == *c:* ]
      then
        ifile+=$1
      else
        ifile+=`echo -n $(pwd)`
        ifile+=/$1
      fi
      /c/Program\ Files\ \(x86\)/Brackets/Brackets.exe "$ifile"
    }
fi


##
## OSX-SPECIFIC
##


if [[ $platform == 'osx' ]]; then
    # Add psql to $PATH.
    # export PATH="/Applications/Postgres93.app/Contents/MacOS/bin:$PATH"

    # Update Homebrew and Homebrew packages.
    _update_brew() {
      brew update
      brew upgrade
      brew cleanup
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

    # Add stapler to $PATH.
    export PATH="$HOME/Projects/stapler:$PATH"
    
    # Add rvm to $PATH
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
fi


##
## CROSS-PLATFORM
##


# Update system.
update() {
  _update_monkeydo
  if [[ $platform == 'osx' ]]; then
    _update_brew
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
