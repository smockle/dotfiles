#!/usr/bin/env bash

sourceall() {
    declare -a files=(
      $HOME/Developer/dotfiles/shell/sources/paths # Path modifications
      $HOME/Developer/dotfiles/shell/sources/exports # Exports
      $HOME/Developer/dotfiles/shell/sources/options # Options
      $HOME/Developer/dotfiles/shell/sources/aliases # Aliases
      $HOME/Developer/dotfiles/shell/functions/* # Functions
      $HOME/Developer/dotfiles/shell/.bash_prompt # Custom bash prompt
    )

    # if these files are readable, source them
    for index in ${!files[*]}
    do
      if [[ -r ${files[$index]} ]]; then
        source ${files[$index]}
      fi
    done
}
sourceall
unset sourceall

if [[ $OSTYPE == "darwin"* ]]; then
  if [[ -r $(brew --prefix)/etc/bash_completion ]]; then # Bash completion (installed via Homebrew)
    source $(brew --prefix)/etc/bash_completion
  fi
fi