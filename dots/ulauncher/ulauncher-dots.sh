#! /bin/bash

source ./components/print.sh

ulauncher_dots_folder=$(dirname "$(realpath "$0")")
ulauncher_kitty_symlink="$HOME/.local/bin/ulauncher_kitty_ssh"
ulauncher_path="/usr/bin/ulauncher"

print_info "$ulauncher_dots_folder"

if [ ! -e "$ulauncher_path" ]; then
    print_warning "Ulauncher is not installed! Skipping..."
    exit 1
fi

rm -rf "$ulauncher_kitty_symlink"

ln -sf "$ulauncher_dots_folder/ulauncher_kitty_ssh" "$ulauncher_kitty_symlink" || {
    print_error "Ulauncher: failed to create $ulauncher_kitty_symlink symlink"
    exit 1
}

print_success "Ulauncher: Dotfiles setup completed!"
