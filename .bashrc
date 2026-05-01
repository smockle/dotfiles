# Source shared shell environment
if [ -r "${HOME}/.profile" ]; then
  . "${HOME}/.profile"
fi

# Use Node.js version in .nvmrc
# https://github.com/nvm-sh/nvm#bash
load_nvmrc() {
  command -v nvm >/dev/null 2>&1 || return

  local oldpwd="${1-}"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [[ -n "${nvmrc_path}" ]]; then
    local nvmrc_node_version="$(nvm version "$(<"${nvmrc_path}")")"

    if [[ "${nvmrc_node_version}" == "N/A" ]]; then
      nvm install && hash -r
    elif [[ "${nvmrc_node_version}" != "$(nvm version)" ]]; then
      nvm use && hash -r
    fi
  elif [[ -n "${oldpwd}" && -n "$(PWD="${oldpwd}" nvm_find_nvmrc)" && -n "${NVM_BIN-}" ]]; then
    nvm deactivate && hash -r
  fi
}

load_nvmrc_on_chpwd() {
  local exit_status=$?

  if [[ "${PWD}" != "${LOAD_NVMRC_PWD-}" ]]; then
    local oldpwd="${LOAD_NVMRC_PWD-}"
    LOAD_NVMRC_PWD="${PWD}"
    load_nvmrc "${oldpwd}"
  fi

  return "${exit_status}"
}

load_nvmrc
LOAD_NVMRC_PWD="${PWD}"
case ";${PROMPT_COMMAND-};" in
  *';load_nvmrc_on_chpwd;'*) ;;
  *) PROMPT_COMMAND="load_nvmrc_on_chpwd${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}" ;;
esac