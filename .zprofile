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

# COLORS
alias grep='grep --color=auto'
alias ls="command ls -G"

# Use git diff instead of diff
alias diff="command git diff"

# GIT
git() {
  command=$1
  shift 1

  # Make `git push` track an upstream branch, similar to
  # `git config --global push.default current`, with added support
  # for back-to-back `git switch -c new-branch && git push && git pull`
  BRANCH_NAME=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null || \
    command git rev-parse --short HEAD 2>/dev/null)
  if [[ "${command}" == "push" ]] && \
     [ -z "$(command "git" config "branch.${BRANCH_NAME}.merge")" ]
  then
    command "git" push --set-upstream origin "${BRANCH_NAME}"
    unset BRANCH_NAME
    return $?
  fi
  unset BRANCH_NAME

  # Remove merged & squash-merged branches
  if [[ "${command}" == "branch" ]] && [[ "${1}" == "prune" ]]; then
    command "git" branch --merged | grep -E -v "(^\*|main|default|master|develop)" | xargs command "git" branch -D
    command "git" fetch -a && command "git" branch -v | grep '\[gone\]' | cut -f3 -d' ' | xargs command "git" branch -D
    return $?
  fi
  
  # Stash with untracked changes by default
  if [[ "${command}" == "stash" ]] && [[ "$@" == "" ]]; then
    command "git" stash --include-untracked
    return $?
  fi

  command "git" "${command}" "$@"
}

gitp() {
  command=$1
  shift 1
  if [[ "${command}" == "ush" ]]; then
    git push "$@"
  fi
  if [[ "${command}" == "ull" ]]; then
    git pull "$@"
  fi
}

alias gti="git"

# KILLPORT
killport() {
  port=$1
  if [ -z "${port}" ]; then
    echo "usage: killport port_number"
    return
  fi
  kill -9 $(lsof -i ":${port}" 2>/dev/null | tail -n +2 | tr -s ' ' | cut -f2 -d' ')
}

# NPM
# Use npm@6 when `package-lock.json` uses `"lockfileVersion": 1` (or earlier),
# Otherwise, use npm@7
npshim() {
  if [ ! -f "package-lock.json" ] || grep -q '"lockfileVersion": 2' "package-lock.json"; then
    npx --prefer-offline -p npm@7 -- npm "$@" </dev/null
  else
    npx --prefer-offline -p npm@6 -- npm "$@" </dev/null
  fi
}

npm() {
  # Upgrade all packages to the latest available versions,
  # and update version numbers in 'package.json' and 'package-lock.json'.
  if [[ "$1" == "upgrade" ]]; then
    command "npm" outdated --depth=0 | grep -v "Package" | awk '{print $1"@"$4}' | xargs command "npm" i
    return $?
  fi
  npshim "$@"
}

# RANDOM
random() {
  if [[ "$1" == "mac" ]]; then
    # https://superuser.com/a/218650/257969
    printf '02:%02X:%02X:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256]
  fi
  if [[ "$1" == "pin" ]]; then
    printf '%03d-%02d-%03d\n' $[RANDOM%1000] $[RANDOM%100] $[RANDOM%1000]
  fi
  if [[ "$1" == "uuid" ]]; then
    printf '%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] \
    $[RANDOM%256] $[RANDOM%256] \
    $[RANDOM%256] $[RANDOM%256] \
    $[RANDOM%256] $[RANDOM%256] \
    $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256]
  fi
}
