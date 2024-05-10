#! /bin/bash

source ./components/print.sh

rofi_dots_folder=$(dirname "$(realpath "$0")")
print_info "$rofi_dots_folder"

create_symlink() {
	local target_file="$1"
	local link_file="$2"

	ln -sf "$target_file" "$link_file" || {
		print_error "Rofi: Failed to create symlink for $target_file"
		exit 1
	}
}

create_symlink "$rofi_dots_folder/config.rasi" "$HOME/.config/rofi/config.rasi"
create_symlink "$rofi_dots_folder/colors" "$HOME/.config/rofi/colors"
create_symlink "$rofi_dots_folder/themes" "$HOME/.config/rofi/themes"

print_success "Rofi: Dotfiles setup completed!"
