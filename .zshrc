#!/usr/bin/env zsh

#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

[ -n "$PS1" ] && source ~/.zprompt

#### FIG ENV VARIABLES ####
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####