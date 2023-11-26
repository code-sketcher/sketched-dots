#! /bin/bash

source ./components/print.sh

vim_dots_folder=$(dirname "$(realpath "$0")")
vim_symlink="$HOME/.vim"

print_info "$vim_dots_folder"

if ! command -v vim &> /dev/null; then
    print_warning "Vim is not installed! Skipping..." 
    exit 1
fi

rm -rf "$vim_symlink"

ln -sf "$vim_dots_folder" "$vim_symlink" || {
    print_error "Vim: failed to create symlink for gitconfig"
    exit 1
}

print_success "Vim: Dotfiles setup completed!"
