#!/usr/bin/env bash

sourceall() {
    declare -a files=(
      $HOME/Developer/dotfiles/shell/sources/paths # Path modifications
      $HOME/Developer/dotfiles/shell/sources/exports # Exports
      $HOME/Developer/dotfiles/shell/sources/options # Options
      $HOME/Developer/dotfiles/shell/sources/aliases # Aliases
      $HOME/Developer/dotfiles/shell/functions/* # Functions
      $HOME/Developer/dotfiles/shell/.bash_prompt # Custom bash prompt
      $(brew --prefix)/etc/bash_completion # Bash completion (installed via Homebrew)
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
