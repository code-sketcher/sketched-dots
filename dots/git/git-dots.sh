#! /bin/bash

source ./components/print.sh

git_dots_folder=$(dirname "$(realpath "$0")")
gitconfig_symlink="$HOME/.gitconfig"

print_info "$git_dots_folder"

if ! command -v git &> /dev/null; then
    print_warning "Git is not installed! Skipping..." 
    exit 1
fi

ln -sf "$git_dots_folder/.gitconfig" "$gitconfig_symlink" || {
    print_error "Git: failed to create symlink for gitconfig"
    exit 1
}

print_success "Git: Dotfiles setup completed!"
