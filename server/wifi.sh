#!/usr/bin/env sh

# https://superuser.com/a/1016798/257969

# Turn on Wi-Fi if it's turned 'Off'
if networksetup -getairportpower en1 | grep -q 'Off'; then
    echo "$(date) Wi-Fi is off. Turning on Wi-Fi."
    networksetup -setairportpower en1 on
fi

# Cycle Wi-Fi power if missing 'IP address'
if [ $(networksetup -getinfo Wi-Fi | grep -c 'IP address:') = '1' ]; then
    echo "$(date) Missing IP address. Cycling Wi-Fi power."
    networksetup -setairportpower en1 off
    networksetup -setairportpower en1 on
fi

# Initiate connection if not connected to the correct network
if ! networksetup -getairportnetwork en1 | grep -q 'Internet'; then
    echo "$(date) Not connected to correct network. Connecting to “Internet”."
    networksetup -setairportnetwork en1 'Internet'
fi