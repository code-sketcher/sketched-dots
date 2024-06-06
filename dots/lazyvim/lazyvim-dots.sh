#! /bin/bash

source ./components/print.sh

lazyvim_dots_folder=$(dirname "$(realpath "$0")")

print_info "$lazyvim_dots_folder"

if ! command -v nvim &> /dev/null; then
    print_warning "Nvim is not installed! Skipping..." 
    exit 1
fi

print_info $HOME/.config/nvim

if [ -d "$HOME/.config/nvim" ]; then
  print_warning "Looks like there is a config for Nvim, please remove it and retry!"
  exit 1
fi

git clone https://github.com/LazyVim/starter ~/.config/nvim

if [ ! -d "$HOME/.config/nvim" ]; then
  print_warning "LazyVim not installed!"
  exit 1
fi

print_success "LazyVim installed!"
