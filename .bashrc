# Source shared shell environment
if [ -r "${HOME}/.profile" ]; then
  . "${HOME}/.profile"
fi

# Use Node.js version in .nvmrc
if command -v load_nvmrc >/dev/null 2>&1; then
  load_nvmrc_on_chpwd() {
    local exit_status=$? oldpwd="${load_nvmrc_pwd-}"

    if [[ "${PWD}" != "${oldpwd}" ]]; then
      load_nvmrc_pwd="${PWD}"
      load_nvmrc "${oldpwd}"
    fi

    return "${exit_status}"
  }

  if [[ ";${PROMPT_COMMAND-};" != *';load_nvmrc_on_chpwd;'* ]]; then
    PROMPT_COMMAND="load_nvmrc_on_chpwd${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}"
  fi
  load_nvmrc_pwd="${PWD}"
  load_nvmrc
fi