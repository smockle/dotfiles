#!/usr/bin/env sh

# Exit early if no screen-sharing session is active
if ! netstat -n | grep -q 5900; then
  rm "${HOME}/.res.tmp"
  exit 0
fi

# Exit early if host resolution has already been set
if [ -f "${HOME}/.res.tmp" ]; then
  exit 0
fi

# Get the IP address of the client (e.g. "192.168.1.10")
client_ip=$(netstat -n | grep 5900 | tr -s ' ' | cut -d' ' -f5 | sed -En "s/^(192\.168\.1\.[0-9]+)\.[0-9]+/\1/p")

# Get the resolution of the client (e.g. "1280 800")
client_res=$(ssh $client_ip 'export PATH=/usr/local/bin:$PATH; display_manager.py show main' | grep resolution | sed -En "s/^resolution\: +([0-9]+)x([0-9]+)$/\1 \2/p")

# Set the host resolution
display_manager.py res $client_res 60 only-hidpi main

# Cache to avoid repeatedly setting host resolution
touch "${HOME}/.res.tmp"