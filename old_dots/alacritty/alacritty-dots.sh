#! /bin/bash

source ./components/print.sh
source ./components/theme-name.sh

ALACRITTY_DIR=$(dirname "$(realpath "$0")")
print_info "$ALACRITTY_DIR"

ALACRITTY_CONF_PATH="${ALACRITTY_DIR}/alacritty.toml"
# Check if the config entered exists
if [[ ! -f "$ALACRITTY_CONF_PATH" ]]; then
  print_error "Conf '$' does not exist in"
  exit 1
fi

mkdir -p "$HOME/.config/alacritty"

# Update config symlinks
ln -nsf "$ALACRITTY_CONF_PATH" "$HOME/.config/alacritty/alacritty.toml"
print_success "Alacritty: Conf setup completed!"

ALACRITTY_THEME_PATH="${ALACRITTY_DIR}/theme/${THEME_NAME}.toml"
# Check if the theme entered exists
if [[ ! -f "$ALACRITTY_THEME_PATH" ]]; then
  print_error "Theme '$ALACRITTY_THEME_PATH' does not exist"
  exit 1
fi

# Update theme symlinks
ln -nsf "$ALACRITTY_THEME_PATH" "$HOME/.config/alacritty/theme.toml"
print_success "Alacritty: Theme setup completed!"
