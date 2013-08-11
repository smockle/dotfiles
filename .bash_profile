# Add rvm to $PATH
export PATH="$PATH:/opt/local/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# Add Heroku to $PATH
export PATH="/usr/local/heroku/bin:$PATH"

# Forget repeated and spaced commands.
export HISTCONTROL=ignoreboth

# Set wget download location
alias wget='wget -P ~/Downloads'

# Add tab completion for rvm
source ~/.rvm/scripts/rvm

# Add tab completion for brew
source `brew --repository`/Library/Contributions/brew_bash_completion.sh
