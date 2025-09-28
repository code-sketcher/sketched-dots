#! /bin/bash

source ./components/print.sh

hypr_dots_folder=$(dirname "$(realpath "$0")")
hypr_path="$HOME/.local/bin/hyprland"
hypr_symlink="$HOME/.config/hypr"

print_info "$hypr_dots_folder"

if [ ! -e "$hypr_path" ] && [ ! -e "/usr/bin/hyprland" ]; then
  print_warning "Hyprland is not installed! Skipping..."
  exit 1
fi

rm -rf "$hypr_symlink"

ln -sf "$hypr_dots_folder" "$hypr_symlink" || {
  print_error "Hyprland: failed to create symlink"
  exit 1
}

print_success "Hyprland: Dotfiles setup completed!"
