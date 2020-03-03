#!/usr/bin/env zsh

# PATH
HOMEBREW_PREFIX=$(dirname "$(dirname "$(whence -p brew)")")
whence -p go &>/dev/null && export GOPATH=$(go env GOPATH)
whence -p gem &>/dev/null && GEM_USER_INSTALLATION_DIRECTORY=$(gem environment | grep "USER INSTALLATION DIRECTORY" | cut -d: -f2 | sed -e 's/^ //')
export HOMEBREW_PREFIX
declare -a PATH_PREPENDA=(
  "${HOMEBREW_PREFIX}/sbin"
  "${HOMEBREW_PREFIX}/bin"
  "${HOME}/Library/Python/2.7/bin" # Add 'pip --user'-installed package bin
  "${GOPATH}/bin" # Add Go package bin
  "${GEM_USER_INSTALLATION_DIRECTORY}/bin" # Add 'gem install --user-install'-installed package bin
)
declare -a PATH_ADDENDA=(
  "${HOMEBREW_PREFIX}/opt/node@12/bin" # Add brew-installed node@12, but let npm-installed npm take precedence
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

# COMPLETIONS
# Init zsh completions
autoload -U compinit
compinit

# Case-insensitive completion
# https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Menu selection
zstyle ':completion:*' menu selection

# Use zsh’s 'git' completions
# https://github.com/Homebrew/homebrew-core/issues/33275#issuecomment-432528793
if [ -f "${HOMEBREW_PREFIX}/share/zsh/site-functions/_git" ]; then
  rm "${HOMEBREW_PREFIX}/share/zsh/site-functions/_git"
fi

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
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# Set default editor to Vi
export EDITOR=vi

# Edit commands in vi
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "v" edit-command-line

# Fix backspace when existing vi mode
bindkey -v "^?" backward-delete-char

# Case-insensitive globbing (used in pathname expansion)
unsetopt CASE_GLOB

# PAGING
# Highlight section titles in manual pages.
[ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null && LESS_TERMCAP_md=$(tput setaf 3)
export LESS_TERMCAP_md

# Don’t clear screen when using 'less' or 'man'
export LESS=-RXE
export MANPAGER="less"

# COLORS
alias grep='grep --color=auto'
alias ls="command ls -G"

# GIT
# Use custom git subfunctions
source "${HOME}/Developer/dotfiles/git/git"

# Use git diff instead of diff
alias diff="git diff"

# DOCKER
# Enable experimental Docker CLI features
export DOCKER_CLI_EXPERIMENTAL="enabled"

# PROMPT
source "${HOME}/.zprompt"
