#! /bin/bash

source ./components/print.sh

ssh_dots_folder=$(dirname "$(realpath "$0")")
print_info "$ssh_dots_folder"

create_symlink() {
	local target_file="$1"
	local link_file="$2"

	ln -sf "$target_file" "$link_file" || {
		print_error "SSH: Failed to create symlink for $target_file"
		exit 1
	}
}

create_symlink "$ssh_dots_folder/ssh-agent-startup.sh" "$HOME/.config/plasma-workspace/env/ssh-agent-startup.sh"
create_symlink "$ssh_dots_folder/ssh-agent-shutdown.sh" "$HOME/.config/plasma-workspace/shutdown/ssh-agent-shutdown.sh"
create_symlink "$ssh_dots_folder/ssh-autostart-plasma.sh" "$HOME/.local/bin/ssh-autostart"

print_success "SSH: Dotfiles setup completed!"
