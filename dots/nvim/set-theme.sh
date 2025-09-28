#! /bin/bash

source ./components/print.sh
source ./components/theme-name.sh

NVIM_DIR=$(dirname "$(realpath "$0")")
print_info "$NVIM_DIR"

THEME_PATH="${NVIM_DIR}/themes/${THEME_NAME}.lua"
# Check if the theme entered exists
if [[ ! -f "$THEME_PATH" ]]; then
  print_error "Theme '$THEME_PATH' does not exist in"
  exit 1
fi

# Update theme symlinks
ln -nsf "$THEME_PATH" "$HOME/.config/nvim/lua/plugins/theme.lua"
print_success "nvim: Theme setup completed!"
