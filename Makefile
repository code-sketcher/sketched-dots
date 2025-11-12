# Colors
BLUE := \033[94m
GREEN := \033[92m
RED := \033[91m
RESET := \033[0m

MAKEFLAGS += -k

# OS detection for portable commands
UNAME_S := $(shell uname -s)
LN_OPTS := -sf

ifeq ($(UNAME_S),Darwin)
	LN_OPTS := $(LN_OPTS)h
else
	LN_OPTS := $(LN_OPTS)n
endif

THEME ?= tokyo-night

# Reusable function to create a symlink with colored output
# $(1): Name of the link (for display)
# $(2): Source path
# $(3): Destination path
define create_symlink
	@printf "$(BLUE)Creating symlink for $(1)...$(RESET)\n"
	@mkdir -p $(dir $(3))
	@ln $(LN_OPTS) $(2) $(3) || (printf "$(RED)Error: Failed to create $(1) symlink.$(RESET)\n" && exit 1)
	@printf "$(GREEN)$(1) symlink created successfully.$(RESET)\n"
endef

dots: tmux alacritty ghostty bash inputrc

tmux:
	$(call create_symlink,tmux,${CURDIR}/dots/tmux/tmux.conf,${HOME}/.config/tmux/tmux.conf)

alacritty:
	$(call create_symlink,alacritty,${CURDIR}/dots/alacritty,${HOME}/.config/alacritty)

ghostty:
	$(call create_symlink,ghostty,${CURDIR}/dots/ghostty,${HOME}/.config/ghostty)

bash:
	$(call create_symlink,bash,${CURDIR}/dots/bash/.bashrc,${HOME}/.bashrc)

inputrc:
	$(call create_symlink,inputrc,${CURDIR}/dots/bash/.inputrc,${HOME}/.inputrc)

install-nerdfont:
	@${CURDIR}/dots/nerdfont/nerdfont-dots.sh

install-macos-apps:
	@printf "$(BLUE)Checking OS for macOS application installation...$(RESET)\n"
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
	  printf "$(BLUE)Checking for Homebrew...$(RESET)\n"; \
	  if ! command -v brew &>/dev/null; then \
	    printf "$(RED)Homebrew is not installed. Please install Homebrew first: /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"$(RESET)\n"; \
	    exit 1; \
	  fi; \
	  printf "$(GREEN)Homebrew is installed. Installing macOS applications: fzf, fd, ripgrep, eza, zoxide, bat, yazi...$(RESET)\n"; \
	  brew install fzf fd ripgrep eza zoxide bat yazi || (printf "$(RED)Error: Failed to install some macOS applications. Check output above for details.$(RESET)\n" && exit 1); \
	  brew install --cask ghostty|| (printf "$(RED)Error: Failed to install some macOS applications. Check output above for details.$(RESET)\n" && exit 1); \
	  printf "$(GREEN)macOS applications installed successfully (or already present).$(RESET)\n"; \
	else \
	  printf "$(YELLOW)Skipping macOS application installation: Not on macOS ($(UNAME_S)).$(RESET)\n"; \
	fi

