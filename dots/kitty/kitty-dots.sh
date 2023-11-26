#! /bin/bash

source ./components/print.sh

kitty_dots_folder=$(dirname "$(realpath "$0")")
kitty_path="$HOME/.local/bin/kitty"
kitty_symlink="$HOME/.config/kitty"

print_info "$kitty_dots_folder"

if [ ! -e "$kitty_path" ]; then
    print_warning "Kitty is not installed! Skipping..."
    exit 1
fi

rm -rf "$kitty_symlink"

ln -sf "$kitty_dots_folder" "$kitty_symlink" || {
    print_error "Kitty: failed to create symlink"
    exit 1
}

cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/ || {
    print_error "Kitty: failed to copy kitty.desktop"
    exit 1
}

cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/ || {
    print_error "Kitty: failed to copy kitty-open.desktop"
    exit 1
}

sed -i "s|Icon=kitty|Icon=$kitty_dots_folder/icons/kitty-dark.png|g" ~/.local/share/applications/kitty*.desktop || {
    print_error "Kitty: failed to set icon"
    exit 1
}

sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop || {
    print_error "Kitty: failed to set executable"
    exit 1
}

print_success "Kitty: Dotfiles setup completed!"
