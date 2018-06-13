#!/usr/bin/env bash

# Determine whether to install personal or work modules
PERSONAL=$(! grep -Fq "xamarin" "${HOME}/.npmrc"; echo $?)

# Install global npm modules
npm i -g @smockle/contrast diff-so-fancy
if [ ! $PERSONAL -eq 0 ]; then
  npm i -g @mobile-center/clusterficks
fi

# When running `npm init`, suggest the MIT license (default: ISC license)
npm config set init-license "MIT"

# When running `npm init`, suggest me as the author
npm config set init-author-email "clay@smockle.com"
npm config set init-author-name "Clay Miller"
npm config set init-author-url "https://www.smockle.com"

# When running `npm version`, sign the git tag
npm config set sign-git-tag true