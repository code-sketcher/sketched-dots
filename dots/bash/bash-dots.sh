#! /bin/bash

source ./components/print.sh

bash_dots_folder=$(dirname "$(realpath "$0")")
print_info "$bash_dots_folder"

create_symlink() {
    local target_file="$1"
    local link_file="$2"

    ln -sf "$target_file" "$link_file" || {                                                              
        print_error "Bash: Failed to create symlink for $target_file"                                           
        exit 1                                                                                           
    } 
}

files=(".bashrc" ".bash_aliases" ".inputrc" ".bash_ssh.sh")

for file in "${files[@]}"; do
    target_file="$bash_dots_folder/$file"
    link_file="$HOME/$file"
    create_symlink "$target_file" "$link_file"
done

create_symlink "$bash_dots_folder/.bash_prompt_first.sh" "$HOME/.bash_prompt.sh" 

print_success "Bash: Dotfiles setup completed!"
