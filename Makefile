all: kitty-dots vim-dots git-dots bash-dots gnome-dots ulauncher-dots

kitty-dots: 
	./dots/kitty/kitty-dots.sh || true

vim-dots: 
	./dots/vim/vim-dots.sh || true

git-dots: 
	./dots/git/git-dots.sh || true

bash-dots: 
	./dots/bash/bash-dots.sh || true

gnome-dots:
	./dots/gnome/gnome-dots.sh || true

ulauncher-dots:
	./dots/ulauncher/ulauncher-dots.sh || true

ssh-dots:
	./dots/ssh/ssh-dots.sh || true

rofi-dots:
	./dots/rofi/rofi-dots.sh || true

tmux-dots: 
	./dots/tmux/tmux-dots.sh || true

lazyvim-dots:
	./dots/lazyvim/lazyvim-dots.sh || true

nerdfont-dots:
	./dots/nerdfont/nerdfont-dots.sh || true

pop-launcher-dots:
	./dots/pop-launcher/pop-launcher-dots.sh || true
