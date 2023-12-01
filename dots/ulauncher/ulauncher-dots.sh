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

rm -rf ~/.config/ulauncher
mkdir -p ~/.config/ulauncher/user-themes
git clone https://github.com/Surendrajat/SeaOwl-Ulauncher-theme $HOME/.config/ulauncher/user-themes/SeaOwl
git clone https://github.com/NayamAmarshe/ulauncher-zorinBlueDark/ ~/.config/ulauncher/user-themes/zorin-blue-dark
git clone https://github.com/GiorgioReale/Ulauncher-Essential-Dark-Theme.git ~/.config/ulauncher/user-themes/Essential-Dark-Theme

print_success "Ulauncher: Dotfiles setup completed!"
