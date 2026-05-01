# Shared POSIX shell environment

# HOMEBREW

if [ -f /opt/homebrew/bin/brew ]; then
  case ":${PATH}:" in
    *:/opt/homebrew/*) ;;
    *) eval "$(/opt/homebrew/bin/brew shellenv)" ;;
  esac
fi
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# RUBY

# Add brew-installed ruby
if [ -d "${HOMEBREW_PREFIX}/opt/ruby/bin" ]; then
  case ":${PATH}:" in
    *:"${HOMEBREW_PREFIX}/opt/ruby/bin":*) ;;
    *) PATH="${HOMEBREW_PREFIX}/opt/ruby/bin${PATH+:$PATH}" ;;
  esac
fi

# Add 'gem install --user-install'-installed package bin
GEM_HOME=$([ -x "${HOMEBREW_PREFIX}/opt/ruby/bin/ruby" ] && "${HOMEBREW_PREFIX}/opt/ruby/bin/ruby" -e 'print Gem.user_dir' || { command -v ruby >/dev/null 2>&1 && ruby -e 'print Gem.user_dir'; })
if [ -n "${GEM_HOME}" ] && [ -d "${GEM_HOME}/bin" ]; then
  case ":${PATH}:" in
    *:"${GEM_HOME}/bin":*) ;;
    *) PATH="${GEM_HOME}/bin${PATH+:$PATH}" ;;
  esac
fi
export GEM_HOME

# NODE.JS

# Add brew-installed node, but let npm-installed npm take precedence
if [ -d "${HOMEBREW_PREFIX}/opt/node@24/bin" ]; then
  case ":${PATH}:" in
    *:"${HOMEBREW_PREFIX}/opt/node@24/bin":*) ;;
    *) PATH="${PATH:+$PATH:}${HOMEBREW_PREFIX}/opt/node@24/bin" ;;
  esac
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
command -v nvm >/dev/null 2>&1 || { [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use; }

# Load .nvmrc file in current directory
# https://github.com/nvm-sh/nvm#calling-nvm-use-automatically-in-a-directory-with-a-nvmrc-file
load_nvmrc() {
  command -v nvm >/dev/null 2>&1 || return

  load_nvmrc_oldpwd="${1-}"
  load_nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "${load_nvmrc_path}" ]; then
    load_nvmrc_node_version="$(nvm version "$(cat "${load_nvmrc_path}")")"

    if [ "${load_nvmrc_node_version}" = "N/A" ]; then
      nvm install && hash -r
    elif [ "${load_nvmrc_node_version}" != "$(nvm version)" ]; then
      nvm use && hash -r
    fi
  elif [ -n "${load_nvmrc_oldpwd}" ] && [ -n "$(PWD="${load_nvmrc_oldpwd}" nvm_find_nvmrc)" ] && [ -n "${NVM_BIN-}" ]; then
    nvm deactivate && hash -r
  fi

  unset load_nvmrc_oldpwd load_nvmrc_path load_nvmrc_node_version
}

# SHELL

# Don't clear screen when using 'less' or 'man'
export LESS="-RXE"
export MANPAGER="less"

export EDITOR="vi"

export PATH
