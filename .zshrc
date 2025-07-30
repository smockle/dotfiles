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

# HOMEBREW
# Hardcoding the output of the following, for performance:
# [ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# PATH
declare -a PATH_PREPENDA=(
  "${HOMEBREW_PREFIX}/var/homebrew/linked/git/share/git-core/contrib/diff-highlight" # Add 'git'’s 'diff-highlight' script (macOS)
  "/usr/share/doc/git/contrib/diff-highlight" # Add 'git'’s 'diff-highlight' script (Debian)
  "${HOME}/Library/Python/2.7/bin" # Add 'pip --user'-installed package bin
  "${HOMEBREW_PREFIX}/opt/ruby/bin" # Add brew-installed ruby
  $([ -x "${HOMEBREW_PREFIX}/opt/ruby/bin/ruby" ] && echo "$(${HOMEBREW_PREFIX}/opt/ruby/bin/ruby -e 'puts Gem.user_dir')/bin" || echo "$(ruby -e 'puts Gem.user_dir')/bin") # Add 'gem install --user-install'-installed package bin

  # Add tools for Chromium development
  "${HOME}/Developer/depot_tools"
  "${HOME}/Developer/chromium/src/buildtools/mac" # 'clang-format'
  "${HOME}/Developer/chromium/src/third_party/llvm-build/Release+Asserts/bin" # 'clang'
  "${HOME}/Developer/chromium/src/third_party/ninja" # 'ninja'
  "${HOME}/Developer/chromium/src/out/Default/tools/clang/third_party/llvm/build/bin" # 'clangd'

  # Add Edge’s tools for Chromium development
  "${HOME}/Developer/chromium/chromium.depot_tools.cr-contrib"
  "${HOME}/Developer/chromium/chromium.depot_tools.cr-contrib/scripts"
)
declare -a PATH_ADDENDA=(
  "${HOMEBREW_PREFIX}/opt/node/bin" # Add brew-installed node, but let npm-installed npm take precedence
  "${HOMEBREW_PREFIX}/opt/node@22/bin" # Add brew-installed node, but let npm-installed npm take precedence
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
autoload -Uz add-zsh-hook
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "${INSIDE_EMACS-}" ]]; then
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

# Use Visual Studio Code Insiders
alias code="code-insiders"

# Configure Edge’s tools for Chromium development
export FORCE_MAC_TOOLCHAIN=1

# COMPLETIONS
# Init zsh completions
autoload -Uz compinit
# https://gist.github.com/ctechols/ca1035271ad134841284
if [ ! -f "$HOME/.zcompdump" ] || [ "$(find $HOME/.zcompdump -mtime +1)" ] ; then
  echo "Updating zsh completions"
  rm -f "$HOME/.zcompdump"
  compinit -i
else
  compinit -C
fi 

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

# Case-insensitive globbing (used in pathname expansion)
unsetopt CASE_GLOB

# PROMPT
# Add git branch and status to prompt
git_branch() {
  if command git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(command git symbolic-ref --short HEAD 2>/dev/null || command git describe --tags --always 2>/dev/null)
    echo "%8F on %5F${branch}%f"
  fi
}
git_status() {
  [ -f "/tmp/zsh_prompt_git_status" ] && grep -F "$(pwd):" "/tmp/zsh_prompt_git_status" | cut -d':' -f2-
}
git_status_async() {
  (command git rev-parse --is-inside-work-tree &>/dev/null && {
    local git_status=""
    [[ -n $(command git ls-files --others --exclude-standard 2>/dev/null) ]] && git_status+="%8F?%f" # untracked
    command git diff --no-ext-diff --quiet --exit-code || git_status+="%8F!%f" # unstaged
    command git diff --no-ext-diff --cached --quiet --exit-code || git_status+="%8F+%f" # staged
    command git rev-parse --verify refs/stash &>/dev/null && git_status+="%8F$%f" # stashed
    grep -v "^$(pwd):" "/tmp/zsh_prompt_git_status" 2>/dev/null > "/tmp/zsh_prompt_git_status"
    [ -n "$git_status" ] && echo "$(pwd): %8F[%f${git_status}%8F]%f" >> "/tmp/zsh_prompt_git_status"
    kill -USR1 $$ 2>/dev/null
  }) &!
}
add-zsh-hook precmd git_status_async
TRAPUSR1() { zle && zle reset-prompt; }

# Add newlines between prompts
interpolate_newlines() {
  if [ -z "${PROMPT_CTR}" ]; then
    PROMPT_CTR=1
  elif [ "${PROMPT_CTR}" -eq 1 ]; then
    echo ""
  fi
}
add-zsh-hook precmd interpolate_newlines

# Enable parameter expansion, command substitution and arithmetic expansion in prompt string
setopt PROMPT_SUBST

# Set PROMPT
PROMPT=""
if [[ -n "${SSH_CLIENT-}" ]]; then
  PROMPT+="%4F%n%8F on %2F%m"
else
  PROMPT+="%4F%n"
fi
PROMPT+="%8F in %2F%(5~|%-1~/.../%3~|%4~)" # working directory
PROMPT+="\$(git_branch)"
PROMPT+="\$(git_status)"
PROMPT+=$'\n'
PROMPT+="%f\$ " # prompt character and reset color