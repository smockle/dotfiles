#!/usr/bin/env bash

# Update
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Install
sudo apt-get install -y git make libavahi-compat-libdnssd-dev mosh vim

# Node.js
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs