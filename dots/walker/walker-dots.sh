#! /bin/bash

source ./components/print.sh
source ./components/theme-name.sh

WALKER_DIR=$(dirname "$(realpath "$0")")
print_info "$WALKER_DIR"

WALKER_CONF_PATH="${WALKER_DIR}/config.toml"
# Check if the config entered exists
if [[ ! -f "$WALKER_CONF_PATH" ]]; then
  print_error "Conf '$WALKER_CONF_PATH' does not exist in"
  exit 1
fi

mkdir -p "$HOME/.config/walker"
mkdir -p "$HOME/.config/walker/themes"
mkdir -p "$HOME/.config/walker/themes/current"

# Update config symlinks
ln -nsf "$WALKER_CONF_PATH" "$HOME/.config/walker/config.toml"
print_success "Walker: Conf setup completed!"

WALKER_THEME_PATH="${WALKER_DIR}/theme/${THEME_NAME}.css"
# Check if the theme entered exists
if [[ ! -f "$WALKER_THEME_PATH" ]]; then
  print_error "Theme '$WALKER_THEME_PATH' does not exist"
  exit 1
fi

# Update theme symlinks
ln -nsf "$WALKER_THEME_PATH" "$HOME/.config/walker/themes/current/style.css"
print_success "Walker: Theme setup completed!"
