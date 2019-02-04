#!/usr/bin/env bash

DOCKER_CONFIG="${HOME}/.docker/config.json"

node > "${DOCKER_CONFIG}.tmp" << EOF
const fs = require("fs");
const configuration = JSON.parse(fs.readFileSync("$DOCKER_CONFIG", "utf8"));
delete configuration.credSstore;
configuration.experimental = "true";
console.log(JSON.stringify(configuration, null, 2));
EOF

if [ -s "${DOCKER_CONFIG}.tmp" ]; then
  mv -f "${DOCKER_CONFIG}.tmp" "${DOCKER_CONFIG}"
fi