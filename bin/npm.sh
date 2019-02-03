#!/usr/bin/env bash

# Install global npm modules
npm i -g diff-so-fancy svgo

# When running `npm init`, suggest the MIT license (default: ISC license)
npm config set init-license "MIT"

# When running `npm init`, suggest me as the author
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"
