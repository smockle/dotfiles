# .ZSHRC is:
# - sourced by all interactive shells
# - not sourced by scripts

# ENVIRONMENT

# Source shared shell environment
if [ -r "${HOME}/.profile" ]; then
  . "${HOME}/.profile"
fi

# Load zsh hook helpers
autoload -Uz add-zsh-hook

# APPS

# Fix PATH in Visual Studio Code’s integrated terminal
if [[ "${TERM_PROGRAM-}" == "vscode" ]]; then
  [ -z "${RPROMPT}" ] && export RPROMPT=""
  . "$(code --locate-shell-integration-path zsh)"
fi

# Share working directory between sessions.
if [[ "${TERM_PROGRAM-}" == "Apple_Terminal" ]] && [[ -z "${INSIDE_EMACS-}" ]]; then
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

# INTERACTIVE SHELL

# Treat # as a comment delimiter at the prompt
setopt INTERACTIVE_COMMENTS

# Correct misspelled command names
unsetopt CORRECT
command_not_found_handler() {
  emulate -L zsh -o extendedglob

  local -a matches=( ${^path}/(#a1)$1(N:t) )
  local correction=${matches[1]} reply

  if [[ -z $correction ]]; then
    print -u2 "zsh: command not found: $1"
    return 127
  fi

  # Uncomment to require confirmation before running the corrected command
  # read "reply?zsh: correct '$1' to '${correction}' [Y/n]? "
  # [[ $reply = [Nn]* ]] && return 127

  print -u2 "zsh: correcting '$1' to '${correction}'"
  "${correction}" "${@:2}"
}

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

# Case-insensitive globbing (used in pathname expansion)
unsetopt CASE_GLOB

alias grep='grep --color=auto'

ls() {
  local a
  for a; do
    [[ $a == -* ]] && continue
    # -L lists symlinked dirs, but breaks symlink coloring, so use it only for symlinked dirs.
    [[ -L $a && -d $a ]] && set -- -L "$@"
    break
  done
  if command ls --color -d . >/dev/null 2>&1; then
    command ls --color=auto "$@"
  else
    command ls -G "$@"
  fi
}

git() {
  if [[ $# -eq 0 ]]; then
    command git
    return $?
  fi

  local git_command=$1
  shift 1

  # Remove merged & squash-merged branches
  if [[ "${git_command}" == "branch" ]] && [[ "${1-}" == "prune" ]]; then
    command "git" branch --merged | grep -E -v "(^\*|main|default|master|develop)" | xargs command "git" branch -D
    command "git" fetch -a && command "git" branch -v | grep '\[gone\]' | cut -f3 -d' ' | xargs command "git" branch -D
    return $?
  fi
  
  # Stash with untracked changes by default
  if [[ "${git_command}" == "stash" ]] && [[ $# -eq 0 ]]; then
    command "git" stash --include-untracked
    return $?
  fi

  command "git" "${git_command}" "$@"
}

upgrade() {
  emulate -L zsh -o err_return
  [[ "$(command uname -s)" != "Darwin" ]] && return

  local brewfile="${HOME}/Developer/smockle/dotfiles/Brewfile"

  [[ -f "${brewfile}" ]] && command brew bundle upgrade --file "${brewfile}"
  command brew upgrade
  command npm update -g
  command gh extensions upgrade --all
  command softwareupdate -ia

  rm -f "${HOME}/.zcompdump" "${HOME}/.zcompdump.zwc"
  autoload -Uz compinit
  compinit -i
}

# Use Node.js version in .nvmrc
# https://github.com/nvm-sh/nvm#zsh
load_nvmrc() {
  command -v nvm >/dev/null 2>&1 || return

  local nvmrc_path="$(nvm_find_nvmrc)"

  if [[ -n "${nvmrc_path}" ]]; then
    local nvmrc_node_version="$(nvm version "$(<"${nvmrc_path}")")"

    if [[ "${nvmrc_node_version}" == "N/A" ]]; then
      nvm install && rehash
    elif [[ "${nvmrc_node_version}" != "$(nvm version)" ]]; then
      nvm use && rehash
    fi
  elif [[ -n "$(PWD="${OLDPWD}" nvm_find_nvmrc)" && -n "${NVM_BIN-}" ]]; then
    nvm deactivate && rehash
  fi
}
add-zsh-hook chpwd load_nvmrc
load_nvmrc

# Load cached completions
autoload -Uz compinit
[[ -f "${HOME}/.zcompdump" ]] && compinit -C || compinit -i

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

# Use the string that has already been typed as the prefix for searching
# through commands (i.e. more intelligent Up/Down-arrow behavior)
bindkey "^[[A" history-beginning-search-backward
bindkey "^[OA" history-beginning-search-backward # SSH
bindkey "^[[B" history-beginning-search-forward
bindkey "^[OB" history-beginning-search-forward # SSH

# Reverse through the completions menu using shift-tab
bindkey "^[[Z" reverse-menu-complete

# Move cursor forward/backward by word (⌥→/⌥←)
backward-word-dir() {
  local WORDCHARS=${WORDCHARS//[\/\-]}
  zle backward-word
}
zle -N backward-word-dir
bindkey "^[b" backward-word-dir

forward-word-dir() {
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
PROMPT+="%f\$ " # prompt character
