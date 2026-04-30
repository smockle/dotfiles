# Shared POSIX shell environment

# Skip duplicate setup on re-source
[ -n "${PROFILE_LOADED-}" ] && [ -z "${VSCODE_PROFILE_INITIALIZED-}" ] && return
export PROFILE_LOADED=1

if [ "$(uname -s)" = "Darwin" ]; then
  # Load Homebrew environment
  [ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

  # Set up Ruby
  GEM_HOME=$([ -x "${HOMEBREW_PREFIX}/opt/ruby/bin/ruby" ] && "${HOMEBREW_PREFIX}/opt/ruby/bin/ruby" -e 'print Gem.user_dir' || { command -v ruby >/dev/null 2>&1 && ruby -e 'print Gem.user_dir'; })
  # Add brew-installed ruby
  PATH="${HOMEBREW_PREFIX}/opt/ruby/bin${PATH+:$PATH}"
  # Add 'gem install --user-install'-installed package bin
  PATH="${GEM_HOME:+${GEM_HOME}/bin:}${PATH}"
  export GEM_HOME

  # Set up Node.js
  # Add brew-installed node, but let npm-installed npm take precedence
  PATH="${PATH:+$PATH:}${HOMEBREW_PREFIX}/opt/node@24/bin"
  # Add brew-installed nvm, but let brew-installed node take precedence (via --no-use)
  export NVM_DIR="$HOME/.nvm"
  [ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ] && \. "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" --no-use

  export PATH
fi

export EDITOR="vi"

# Don't clear screen when using 'less' or 'man'
export LESS="-RXE"
export MANPAGER="less"
