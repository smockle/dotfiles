#!/usr/bin/env zsh

# ENV
if [ -f "${HOME}/.env" ]; then
  # https://stackoverflow.com/a/45971167/1923134
  set -a; source "${HOME}/.env"; set +a
fi

# GEMPATH
if whence -p gem &>/dev/null; then
  GEM_USER_INSTALLATION_DIRECTORY=$(cat "${HOME}/.gem/user_installation_directory" 2>/dev/null)
  if [ ! -d "${GEM_USER_INSTALLATION_DIRECTORY}" ]; then
    GEM_USER_INSTALLATION_DIRECTORY=$(gem environment | grep "USER INSTALLATION DIRECTORY" | cut -d: -f2 | sed -e 's/^ //' | tee "${HOME}/.gem/user_installation_directory")
    mkdir -p "${GEM_USER_INSTALLATION_DIRECTORY}"
  fi
fi

# PATH
HOMEBREW_PREFIX=$(dirname "$(dirname "$(whence -p brew)")")
whence -p go &>/dev/null && export GOPATH=$(go env GOPATH)
export HOMEBREW_PREFIX
declare -a PATH_PREPENDA=(
  "${HOMEBREW_PREFIX}/sbin"
  "${HOMEBREW_PREFIX}/bin"
  "${HOME}/Library/Python/2.7/bin" # Add 'pip --user'-installed package bin
  "${GOPATH}/bin" # Add Go package bin
  "${GEM_USER_INSTALLATION_DIRECTORY}/bin" # Add 'gem install --user-install'-installed package bin
)
declare -a PATH_ADDENDA=(
  "${HOMEBREW_PREFIX}/opt/node@14/bin" # Add brew-installed node@14, but let npm-installed npm take precedence
  "${HOMEBREW_PREFIX}/opt/node/bin" # Add brew-installed node, but let npm-installed npm take precedence
)
for p in $PATH_PREPENDA; do
  if [ -d "${p}" ] && [[ "${PATH}" != *${p}* ]]; then
    PATH="${p}:$PATH"
  fi
done
for p in $PATH_ADDENDA; do
  if [ -d "${p}" ] && [[ "${PATH}" != *${p}* ]]; then
    PATH="$PATH:${p}"
  fi
done
unset p
unset GEM_USER_INSTALLATION_DIRECTORY
unset PATH_PREPENDA
unset PATH_ADDENDA
export PATH

# HISTORY
# Increase the maximum number of lines contained in the history file
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zhistory

# Skip repeated commands in history.
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Write history immediately and share it between sessions.
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Share working directory between sessions.
# https://superuser.com/a/328148
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL, including
        # the host name to disambiguate local vs. remote paths.
        # Percent-encode the pathname.
        local url_path=''
        {
            # Use LC_CTYPE=C to process text byte-by-byte. Ensure that
            # LC_ALL isn't set, so it doesn't interfere.
            local i ch hexch LC_CTYPE=C LC_ALL=
            for ((i = 1; i <= ${#PWD}; ++i)); do
                ch="$PWD[i]"
                if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                    url_path+="$ch"
                else
                    printf -v hexch "%02X" "'$ch"
                    url_path+="%$hexch"
                fi
            done
        }
        printf '\e]7;%s\a' "file://$HOST$url_path"
    }
    # Register the function so it is called at each prompt.
    autoload add-zsh-hook
    add-zsh-hook precmd update_terminal_cwd
fi

# Set default editor to Vi
export EDITOR=vi

# PAGING
# Don’t clear screen when using 'less' or 'man'
export LESS=-RXE
export MANPAGER="less"

# DOCKER
# Enable experimental Docker CLI features
export DOCKER_CLI_EXPERIMENTAL="enabled"

# RUBY
# http://mattgreensmith.net/2014/12/25/speed-up-rbenv-init-via-background-rehashing/
whence -p rbenv &>/dev/null && eval "$(rbenv init - --no-rehash)"

# FUNCTIONS
source "${HOME}/Developer/dotfiles/shell/aliases"
