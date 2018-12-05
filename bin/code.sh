#!/usr/bin/env bash

# Determine whether to install personal or work extensions
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

declare -a extensions=(
  EditorConfig.EditorConfig
  smockle.xcode-default-theme
  muuvmuuv.vscode-sundial
)
declare -a personal_extensions=(
  esbenp.prettier-vscode
)
declare -a work_extensions=(
  msjsdiag.debugger-for-chrome
  ms-vscode.vscode-typescript-tslint-plugin
  ms-vsliveshare.vsliveshare
)

install_code_extensions() {
  local extensions=("$@")
  for extension in "${extensions[@]}"; do
    if code --list-extensions | grep -q "${extension}"; then
      code --uninstall-extension "${extension}" 
    fi
    code --install-extension "${extension}"
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
