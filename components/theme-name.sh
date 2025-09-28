#! /bin/bash

if [[ -z $1 ]]; then
  echo "THEME:  <theme-name>"
  exit 1
fi

THEME_NAME=$(echo "$1" | sed -E 's/<[^>]+>//g' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
