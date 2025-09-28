THEME ?= tokyo-night

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

alacritty-dots:
	./dots/alacritty/alacritty-dots.sh ${THEME} || true

walker-dots:
	./dots/walker/walker-dots.sh ${THEME} || true

background-dots:
	./dots/background/background-dots.sh || true

hypr-dots:
	./dots/hypr/hypr-dots.sh || true	

#Usage: THEME=dracula make nvim-set-theme
nvim-set-theme:
	./dots/nvim/set-theme.sh $(THEME) || true

fedora-install-all: fedora-install-gui-apps fedora-install-tui-apps fedora-install-shell-tools fedora-install-dev-apps fedora-install-hyprland

fedora-install-hyprland:
	#Install mako(notification system)
	sudo dnf install mako -y || true
	#Install hyprland, waybar
	sudo dnf copr enable solopasha/hyprland -y || true
	sudo dnf install hyprland xdg-desktop-portal-hyprland waybar-git hyprshot hyprpaper satty -y || true
	mkdir ~/Pictures/Screenshot || true
	#Install apps
	sudo dnf install pavucontrol -y | true
	#Walker install
	sudo dnf install elephant elephant-desktopapplications elephant-runner elephant-calc elephant-clipboard elephant-menus elephant-providerlist elephant-files elephant-todo -y || true
	sudo dnf install qalculate -y || true
	sudo dnf copr enable errornointernet/walker -y || true
	sudo dnf install walker -y || true

fedora-install-tui-apps:
	sudo dnf copr enable dejan/lazygit -y || true
	sudo dnf copr enable atim/lazydocker -y || true
	sudo dnf copr enable varlad/yazi
	sudo dnf -y install alacritty lazygit lazydocker wiremix yazi || true

fedora-install-gui-apps:
	sudo dnf -y install google-chrome-stable flatseal || true

fedora-install-shell-tools:
	#eza is not in the repo right now
	sudo dnf install fzf zoxide ripgrep fd-find -y || true

fedora-install-dev-apps:
	sudo dnf install neovim openfortivpn -y || true
	flatpak install app.freelens.Freelens -y | true
	#install beekeeper
	sudo curl -o /etc/yum.repos.d/beekeeper-studio.repo https://rpm.beekeeperstudio.io/beekeeper-studio.repo || true
	sudo rpm --import https://rpm.beekeeperstudio.io/beekeeper.key || true
	sudo dnf install beekeeper-studio || true
	#Install docker
	sudo dnf -y install dnf-plugins-core || true
	sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || true
	sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
	sudo systemctl enable --now docker || true
	sudo usermod -aG docker $(USER) || true


