#!/usr/bin/env zsh
# shellcheck shell=sh

# .ZSHRC is:
# - sourced by all interactive shells
# - not sourced by scripts

# ENV
if [ -f "${HOME}/.env" ]; then
  # https://stackoverflow.com/a/45971167/1923134
  set -a; source "${HOME}/.env"; set +a
fi

# GEMPATH
if whence -p gem &>/dev/null; then
  GEM_USER_INSTALLATION_DIRECTORY=$(cat "${HOME}/.gem/user_installation_directory" 2>/dev/null)
  if [ ! -d "${GEM_USER_INSTALLATION_DIRECTORY}" ]; then
    mkdir -p "${HOME}/.gem"
    GEM_USER_INSTALLATION_DIRECTORY=$(gem environment | grep "USER INSTALLATION DIRECTORY" | cut -d: -f2 | sed -e 's/^ //' | tee "${HOME}/.gem/user_installation_directory")
    mkdir -p "${GEM_USER_INSTALLATION_DIRECTORY}"
  fi
fi

# HOMEBREW
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_AUTOREMOVE=1

# PATH
whence -p go &>/dev/null && export GOPATH=$(go env GOPATH)
declare -a PATH_PREPENDA=(
  "${HOMEBREW_PREFIX}/var/homebrew/linked/git/share/git-core/contrib/diff-highlight" # Add 'git'’s 'diff-highlight' script (macOS)
  "/usr/share/doc/git/contrib/diff-highlight" # Add 'git'’s 'diff-highlight' script (Debian)
  "${HOME}/Library/Python/2.7/bin" # Add 'pip --user'-installed package bin
  "${GEM_USER_INSTALLATION_DIRECTORY}/bin" # Add 'gem install --user-install'-installed package bin
)
declare -a PATH_ADDENDA=(
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

# COLORS
alias grep='grep --color=auto'
alias ls="command ls -G"

# Use git diff instead of diff
alias diff="command git diff"

# Use Visual Studio Code Insiders instead of Visual Studio Code
alias code="code-insiders"

# COMPLETIONS
# Init zsh completions
autoload -U compinit
compinit

# Case-insensitive completion
# https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Menu selection
zstyle ':completion:*' menu yes select
zmodload zsh/complist
# Finish completion and execute with (return)
bindkey -M menuselect '^M' .accept-line
# Cancel selection with (esc)
bindkey -M menuselect '\e' send-break

# INPUT
# Use the string that has already been typed as the prefix for searching
# through commands (i.e. more intelligent Up/Down-arrow behavior)
bindkey "^[[A" history-beginning-search-backward
bindkey "^[OA" history-beginning-search-backward # SSH
bindkey "^[[B" history-beginning-search-forward
bindkey "^[OB" history-beginning-search-forward # SSH

# Reverse through the completions menu using shift-tab
bindkey "^[[Z" reverse-menu-complete

# Move cursor forward/backward by word (⌥→/⌥←)
backward-word-dir () {
  local WORDCHARS=${WORDCHARS//[\/\-]}
  zle backward-word
}
zle -N backward-word-dir
bindkey "^[b" backward-word-dir
forward-word-dir () {
  local WORDCHARS=${WORDCHARS//[\/\-]}
  zle forward-word
}
zle -N forward-word-dir
bindkey "^[f" forward-word-dir

# Move cursor to beginning/end of line (⌘←/⌘→)
bindkey "^[[1~" beginning-of-line
bindkey "^A" beginning-of-line # VS Code
bindkey "^[[4~" end-of-line
bindkey "^E" end-of-line # VS Code

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

# Case-insensitive globbing (used in pathname expansion)
unsetopt CASE_GLOB

# Enable parameter expansion, command substitution and arithmetic expansion in prompt string
setopt PROMPT_SUBST

# PROMPT
# Inspired by https://github.com/necolas/dotfiles/blob/master/shell/bash_prompt
prompt_git_branch_name() {
  ! command git rev-parse --is-inside-work-tree &>/dev/null && return

  local branchName
  branchName="$(command git symbolic-ref --quiet --short HEAD 2> /dev/null || \
    command git rev-parse --short HEAD 2> /dev/null || \
    echo '(unknown)')"

  echo -e "${1}${branchName}"
}

# https://www.anishathalye.com/2015/02/07/an-asynchronous-shell-prompt/
# Print this shell process’ git status
prompt_git_status() {
  if [ -f "/tmp/zsh_prompt_git_status_$$" ]; then
    local s=$(cat "/tmp/zsh_prompt_git_status_$$")
    [ -n "${s}" ] && s=" [${s}]"
    echo -e "${1}${s}"
  fi
}
# Update this shell process’ git status
prompt_git_status_async() {
  ! command git rev-parse --is-inside-work-tree &>/dev/null && return

  local s='';

  if [[ "$(command git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]]; then
    command git update-index --really-refresh -q &>/dev/null;
    # [+] staged, uncommitted
    ! command git diff --quiet --ignore-submodules --cached && s+='+'
    # [!] unstaged
    ! command git diff-files --quiet --ignore-submodules -- && s+='!'
    # [?] untracked - this is the most expensive
    [ -n "$(command git ls-files --others --exclude-standard)" ] && s+='?'
    # [$] stashed
    command git rev-parse --verify refs/stash &>/dev/null && s+='$'
  fi
  
  echo "${s}" > "/tmp/zsh_prompt_git_status_$$"
  kill -s USR1 $$
}
# Re-draw the prompt when git status updates are available
TRAPUSR1() {
  PROMPT_GIT_STATUS_ASYNC_PROC=0
  zle && zle reset-prompt
}

set_prompts() {
  if [[ -n "${SSH_CLIENT}" ]]; then
    PROMPT="%4F%n%8F on %2F%m"
  else
    PROMPT="%4F%n"
  fi
  PROMPT+="%8F in ";
  PROMPT+="%2F%(5~|%-1~/.../%3~|%4~)"; # working directory, https://unix.stackexchange.com/a/273567
  PROMPT+='$(prompt_git_branch_name "%8F on %5F")'; # git branch name
  PROMPT+='$(prompt_git_status "%8F")'; # git status
  PROMPT+=$'\n';
  PROMPT+="%f\$ "; # `$` (and reset color)
  export PROMPT;
}
set_prompts
unset set_prompts

PPWD="$PWD" # Remember previous working directory
PSHELL_SESSION_FILE="$SHELL_SESSION_FILE" # Remember previous shell session file
precmd() {
  if [ -z "${PROMPT_CTR}" ]; then
    PROMPT_CTR=1
  elif [ "${PROMPT_CTR}" -eq 1 ]; then
    echo ""
    # osascript -e 'if app "Terminal" is frontmost then tell app "System Events" to keystroke "u" using command down'
  fi

  # Clear shell process’ git status when working directory changes
  if [[ "${PPWD}" != "${PWD}" ]]; then
    rm -f "/tmp/zsh_prompt_git_status_$$"
  fi
  # Clear shell session file so disowned background process
  # doesn’t output “Saving session...completed.”
  SHELL_SESSION_FILE=""
  # Kill unfinished git status update requests
  if [[ "${PROMPT_GIT_STATUS_ASYNC_PROC}" != 0 ]]; then
    kill -s HUP $PROMPT_GIT_STATUS_ASYNC_PROC &>/dev/null || :
  fi
  # Request updated git status in the background
  prompt_git_status_async &!
  PROMPT_GIT_STATUS_ASYNC_PROC=$!
  PPWD="$PWD" # Update previous working directory
  SHELL_SESSION_FILE="$PSHELL_SESSION_FILE" # Update previous shell session file
}
