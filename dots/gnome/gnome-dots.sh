#! /bin/bash

source ./components/print.sh

gnome_dots_folder=$(dirname "$(realpath "$0")")

print_info "$gnome_dots_folder"

if ! command -v gnome-shell &> /dev/null; then
    print_warning "Gnome-shell is not installed! Skipping..." 
    exit 1
fi

gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4','<Super>q']" || {
    print_error "Gnome: failed to set close window shortcut"
}


gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h','<Super>w']" || {
    print_error "Gnome: failed to set minimize window shortcut"
}

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Page_Up', '<Super><Alt>Left']" || {
    print_error "Gnome: failed to set switch-to-workspace-left shortcut"
}


gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Page_Down', '<Super><Alt>Right']" || {
    print_error "Gnome: failed to set switch-to-workspace-right shortcut"
}

gsettings set org.gnome.desktop.wm.preferences button-layout : || {
    print_error "Gnome: failed to disable button layout "
}

gsettings set org.gnome.shell.extensions.ding show-home false {
    print_error "Gnome: failed to disable desktop home icon"
}

print_success "Gnome: Setup completed!"
