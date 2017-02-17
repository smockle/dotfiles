##
## PATH
##

# Add ~/bin to $PATH
set -x PATH $PATH $HOME/bin

# BREW
# Add $(brew --prefix)/bin to $PATH.
if command -v brew >/dev/null
  set -l brew_prefix (brew --prefix)
  set -x PATH $brew_prefix/bin $PATH
end

# NODE
# Add node, npm, nvm to $PATH
bass source ~/.nvm/nvm.sh --no-use ';' nvm >/dev/null

##
## SETTINGS
##

# ATOM
# Set $ATOM_PATH
if test -d "$HOME/Applications/Atom.app" -o -d "$HOME/Applications/Atom Beta.app"
  set -x ATOM_PATH "$HOME/Applications"
else if test -d '/Applications/Atom.app' -o -d '/Applications/Atom Beta.app'
  set -x ATOM_PATH '/Applications'
end

# FISH
# Set default editor to nano
set -x EDITOR nano
# Make repeated commands not show up in history.
# Make commands preceeded by a space not show up in history.
set -x HISTCONTROL ignoreboth
# Make specific commands not show up in history.
set -x HISTIGNORE 'ls:cd:cd -:pwd:exit:date:* --help'

# GREP
# Always enable colored grep output.
set -x GREP_OPTIONS '--color=auto'

# LESS
# Use color output for less.
set hilite (which highlight)
set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
set -x LESS '-RXE'

# LS
# Always use color output for ls.
set -x LS_COLORS 'no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# MAN
# Don’t clear the screen after quitting a manual page.
set -x MANPAGER 'less'
