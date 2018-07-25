#!/usr/bin/env bash

# Determine whether to install personal or work extensions
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

declare -a extensions=(
  EditorConfig.EditorConfig
  msjsdiag.debugger-for-chrome
  PeterJausovec.vscode-docker
  smockle.xcode-default-theme
)
declare -a personal_extensions=(
  esbenp.prettier-vscode
)
declare -a work_extensions=(
  eg2.tslint
  ms-vsliveshare.vsliveshare
  ms-vsts.team
  romanresh.testcafe-test-runner
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
