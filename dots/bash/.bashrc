# Only run for interactive shells
[[ $- != *i* ]] && return

# ------------------------------------------------------------
# PATH CONFIGURATION
# ------------------------------------------------------------
# Add local bin, Composer, and user bin directories
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# ------------------------------------------------------------
# SHELL OPTIONS
# ------------------------------------------------------------
shopt -s histappend   # Append to history, don't overwrite
shopt -s cmdhist      # Multi-line commands stored as single history entries
shopt -s checkwinsize # Update terminal size automatically
shopt -s autocd       # Change directory by typing its name
shopt -s globstar     # Enable recursive ** globbing

# ------------------------------------------------------------
# HISTORY SETTINGS
# ------------------------------------------------------------
# ignoredups    : ignore consecutive duplicate commands
# erasedups     : remove previous duplicates anywhere in history
# ignorespace   : ignore commands starting with a space
# ignoreboth    : ignoredups + ignorespace
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=5000           # Number of commands to remember in memory
export HISTFILESIZE=10000      # Max number of lines in ~/.bash_history
export HISTTIMEFORMAT='%F %T ' # Timestamps in history

# Keep history synced across multiple terminal sessions
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ------------------------------------------------------------
# SET TERMINAL TITLE
# ------------------------------------------------------------
case "$TERM" in
xterm* | rxvt* | tmux*)
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"; '"$PROMPT_COMMAND"
  ;;
esac

# ------------------------------------------------------------
# EDITOR / ENVIRONMENT VARIABLES
# ------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS='-RFX'

# PHP / Composer environment
export PHP_CLI_SERVER_WORKERS=4
export COMPOSER_ALLOW_SUPERUSER=1

# ------------------------------------------------------------
# COLORS & PROMPT
# ------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Git branch parser for prompt
parse_git_branch() {
  git branch 2>/dev/null | sed -n '/\* /s///p'
}

# Colored prompt with Git branch if inside a repo
export PS1="\[\e[0;32m\]\u@\h \[\e[0;33m\]\w\[\e[0;36m\]\$(if git rev-parse --git-dir > /dev/null 2>&1; then echo ' ‹'$(parse_git_branch)'›'; fi)\[\e[0m\]\n$ "

# ------------------------------------------------------------
# SSH AGENT AUTOLOAD
# ------------------------------------------------------------
# Starts ssh-agent if not running and adds available keys
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" >/dev/null
  [[ -f ~/.ssh/id_rsa ]] && ssh-add ~/.ssh/id_rsa 2>/dev/null
  [[ -f ~/.ssh/id_ed25519 ]] && ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# ------------------------------------------------------------
# PLATFORM-SPECIFIC SETTINGS
# ------------------------------------------------------------
# Suppress deprecation warnings on macOS
case "$OSTYPE" in
darwin*) export BASH_SILENCE_DEPRECATION_WARNING=1 ;;
esac

# ------------------------------------------------------------
# CUSTOM FUNCTIONS
# ------------------------------------------------------------
# Open files or URLs in default app (portable)
open() {
  if command -v xdg-open &>/dev/null; then
    command xdg-open "$@" >/dev/null 2>&1 &
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    command open "$@" >/dev/null 2>&1 &
  else
    echo "No compatible 'open' command found" >&2
    return 1
  fi
}

# ------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Warn before running rm, mv, cp with wildcards
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

if [[ -f "$HOME/.bash_aliases" ]]; then
  source "$HOME/.bash_aliases"
fi

# ------------------------------------------------------------
# BASH COMPLETION
# ------------------------------------------------------------
# Load bash completion scripts for Linux and macOS
if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  # Linux
  [[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

  # macOS Apple Silicon
  [[ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]] && source /opt/homebrew/etc/profile.d/bash_completion.sh

  # macOS Intel
  [[ -f /usr/local/etc/profile.d/bash_completion.sh ]] && source /usr/local/etc/profile.d/bash_completion.sh
fi

# ------------------------------------------------------------
# RIPGREP
# ------------------------------------------------------------
if command -v rg &>/dev/null; then
  alias grep='rg --color=auto'
fi

# ------------------------------------------------------------
# BAT
# ------------------------------------------------------------
if command -v bat &>/dev/null; then
  alias cat='bat'
fi

# ------------------------------------------------------------
# MISE
# ------------------------------------------------------------
# PHP virtual environment manager
if command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
fi

# ------------------------------------------------------------
# EZA — Modern ls replacement
# ------------------------------------------------------------
if command -v eza &>/dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# ------------------------------------------------------------
# STARSHIP PROMPT
# ------------------------------------------------------------
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

# ------------------------------------------------------------
# ZOXIDE — Directory jumper
# ------------------------------------------------------------
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"

  # Optional override: cd -> zd
  alias cd="zd"

  # zd() function: smart directory jump
  zd() {
    if [ $# -eq 0 ]; then
      builtin cd ~ && return
    elif [ -d "$1" ]; then
      builtin cd "$1"
    else
      z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
    fi
  }
fi

# ------------------------------------------------------------
# FZF — Fuzzy finder & completions
# ------------------------------------------------------------
if command -v fzf &>/dev/null; then
  # Optional preview command using bat if installed
  if command -v bat &>/dev/null; then
    alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  else
    alias ff="fzf --preview 'cat {}'"
  fi

  # Load fzf completions for Linux/macOS
  for file in \
    /usr/share/fzf/completion.bash \
    /usr/share/fzf/key-bindings.bash \
    /opt/homebrew/share/fzf/completion.bash \
    /opt/homebrew/share/fzf/key-bindings.bash \
    /usr/local/share/fzf/completion.bash \
    /usr/local/share/fzf/key-bindings.bash; do
    [[ -f $file ]] && source "$file"
  done
fi
