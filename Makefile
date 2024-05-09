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
