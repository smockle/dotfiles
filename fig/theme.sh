#!/usr/bin/env sh

if [ "${DARKMODE}" -eq "1" ]; then
  fig settings autocomplete.theme dark
else
  fig settings autocomplete.theme light
fi