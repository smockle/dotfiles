#!/usr/bin/env bash

# Determine whether to install personal or work extensions
PERSONAL=$(! grep -Fq "AppCenter" "${HOME}/.npmrc"; echo $?)

code --install-extension EditorConfig.EditorConfig \
     --install-extension LinusU.auto-dark-mode \
     --install-extension peterjausovec.vscode-docker \
     --install-extension smockle.xcode-default-theme \
     --install-extension VisualStudioExptTeam.vscodeintellicode
if [ $PERSONAL -eq 0 ]; then
  code --install-extension esbenp.prettier-vscode
else
  code --install-extension msjsdiag.debugger-for-chrome \
       --install-extension ms-vscode.csharp \
       --install-extension ms-vscode.vscode-typescript-tslint-plugin \
       --install-extension ms-vsliveshare.vsliveshare
fi
