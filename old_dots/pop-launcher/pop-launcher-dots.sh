#! /bin/bash

source ./components/print.sh

pop_launcher_dots_folder=$(dirname "$(realpath "$0")")
pop_launcher_path="/usr/bin/pop-launcher"
pop_launcher_symlink="$HOME/.local/share/pop-launcher/scripts"

print_info "$pop_launcher_dots_folder"

mkdir -p "$pop_launcher_symlink"

if [ ! -e "$pop_launcher_path" ]; then
	print_warning "Pop launcher is not installed! Skipping..."
	exit 1
fi

ln -sf "$pop_launcher_dots_folder/scripts/spotify-next" "$pop_launcher_symlink/spotify-next" || {
	print_error "Pop launcher: failed to create spotify-next symlink"
	exit 1
}

ln -sf "$pop_launcher_dots_folder/scripts/spotify-previous" "$pop_launcher_symlink/spotify-previous" || {
	print_error "Pop launcher: failed to create spotify-previous symlink"
	exit 1
}

ln -sf "$pop_launcher_dots_folder/scripts/spotify-play-pause" "$pop_launcher_symlink/spotify-play-pause" || {
	print_error "Pop launcher: failed to create spotify-previous symlink"
	exit 1
}

print_success "Pop launcher: Dotfiles setup completed!"
