#! /bin/bash

source ./components/print.sh

tmux_dots_folder=$(dirname "$(realpath "$0")")
print_info "$tmux_dots_folder"

folder="$HOME/.config/tmux/plugins/tpm"
if ! git clone "${url}" "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then
    print_info "!!!! TMUX TMP !!!! Clone failed because the folder ${folder} exists!"
fi

create_symlink() {
	local target_file="$1"
	local link_file="$2"

	ln -sf "$target_file" "$link_file" || {
		print_error "Tmux: Failed to create symlink for $target_file"
		exit 1
	}
}

create_symlink "$ssh_dots_folder/tmux.conf" "$HOME/.config/tmux/tmux.conf"

print_success "TMUX: Dotfiles setup completed!"
