#!/usr/bin/env bash

# Determine whether to install personal or work extensions
PERSONAL=$(! grep -Fq "xamarin" "${HOME}/.npmrc"; echo $?)

declare -a extensions=(
  EditorConfig.EditorConfig
  ms-vsliveshare.vsliveshare
  dbaeumer.vscode-eslint
  eg2.tslint
  mikestead.dotenv
  msjsdiag.debugger-for-chrome
  shinnn.stylelint
)
declare -a personal_extensions=(
  esbenp.prettier-vscode
  flowtype.flow-for-vscode
)
declare -a work_extensions=(
  mrmlnc.vscode-scss
  ms-vsts.team
  romanresh.testcafe-test-runner
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
