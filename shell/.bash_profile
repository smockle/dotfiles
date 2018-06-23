#!/usr/bin/env bash

sourceall() {
    declare -a files=(
      $HOME/Projects/dotfiles/shell/sources/paths # Path modifications
      $HOME/Projects/dotfiles/shell/sources/exports # Exports
      $HOME/Projects/dotfiles/shell/sources/options # Options
      $HOME/Projects/dotfiles/shell/sources/aliases # Aliases
      $HOME/Projects/dotfiles/shell/functions/* # Functions
      $HOME/Projects/dotfiles/shell/.bash_prompt # Custom bash prompt
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
