#!/usr/bin/env sh

# Exit early if no screen-sharing session is active
if ! netstat -n | grep -q 5900; then
  rm "${HOME}/.res.tmp"
  exit 0
fi

# Exit early if host resolution has already been matched to client resolution
if [ -f "${HOME}/.res.tmp" ]; then
  exit 0
fi

# Get the IP address of the connected client (e.g. "192.168.1.10")
client_ip=$(netstat -n | grep 5900 | tr -s ' ' | cut -d' ' -f5 | sed -En "s/^(192\.168\.1\.[0-9]+)\.[0-9]+/\1/p")

# Get the hostname of the connected client (e.g. "MacBook-Pro.localdomain")
client_name=$(nslookup $client_ip | sed -En "s/^.*name = (.*).$/\1/p")

if echo $client_name | grep -Fq "Pro"; then
  # Match 15-inch MacBook Pro resolution
  display_manager.py res 1680 1050 60 main
else
  # Match 12-inch MacBook resolution
  display_manager.py res 1280 800 60 main
fi

# Cache resolution
touch "${HOME}/.res.tmp"