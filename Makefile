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

all: tmux alacritty ghostty bash inputrc nerdfont

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

nerdfont:
	@${CURDIR}/dots/nerdfont/nerdfont-dots.sh

