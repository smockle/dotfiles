#!/usr/bin/env bash

# Determine whether to install personal or work extensions
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

declare -a extensions=(
  EditorConfig.EditorConfig
  smockle.xcode-default-theme
)
declare -a personal_extensions=(
  esbenp.prettier-vscode
)
declare -a work_extensions=(
  msjsdiag.debugger-for-chrome
  ms-vsliveshare.vsliveshare
)

install_code_extensions() {
  local extensions=("$@")
  for extension in "${extensions[@]}"; do
    if code-insiders --list-extensions | grep -q "${extension}"; then
      code-insiders --uninstall-extension "${extension}" 
    fi
    code-insiders --install-extension "${extension}"
  done
}

install_code_extensions "${extensions[@]}"
if [ $PERSONAL -eq 0 ]; then
  install_code_extensions "${personal_extensions[@]}"
else
  install_code_extensions "${work_extensions[@]}"
fi

unset extensions
unset personal_extensions
unset work_extensions
unset install_code_extensions
