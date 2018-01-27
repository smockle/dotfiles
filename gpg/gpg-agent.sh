#!/usr/bin/env bash

# https://gist.github.com/sindresorhus/98add7be608fad6b5376a895e5a59972

# In order for gpg to find gpg-agent, gpg-agent must be running, and there must be an env
# variable pointing GPG to the gpg-agent socket. This little script, which must be sourced
# in your shell's init script (ie, .bash_profile, .zshrc, whatever), will either start
# gpg-agent or set up the GPG_AGENT_INFO variable if it's already running.

if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
    export GPG_AGENT_INFO=~/.gnupg/S.gpg-agent:1489:1
else
    gpg-agent --daemon
    export GPG_TTY=$(tty)
fi