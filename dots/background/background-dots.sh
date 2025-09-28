#! /bin/bash

source ./components/print.sh

background_dots_folder=$(dirname "$(realpath "$0")")
background_symlink="$HOME/.config/background"

print_info "$background_dots_folder"

ln -nsf "$background_dots_folder" "$background_symlink" || {
  print_error "background: failed to create symlink"
  exit 1
}

print_success "background: Dotfiles setup completed!"
