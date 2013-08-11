# Add rvm to $PATH
export PATH="$PATH:/opt/local/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# Add Heroku to $PATH
export PATH="/usr/local/heroku/bin:$PATH"

# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
export HISTCONTROL=ignoreboth

# Make specific commands not show up in history.
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Set wget download location
alias wget='wget -P ~/Downloads'

# Add tab completion for rvm
source ~/.rvm/scripts/rvm

# Add tab completion for brew
source `brew --repository`/Library/Contributions/brew_bash_completion.sh
