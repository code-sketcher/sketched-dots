# tmux-agent-status

A modular tmux plugin to display AI coding agent status in your status bar, with an **interactive live-preview switcher modal**.

## Features

- **Real-Time Status Bar**:
  - `needs attention` in **bold red** when an agent asks for tool permission or input.
  - `working` in **yellow** when an agent is thinking or executing.
  - `done` in **green** when an agent completed its task.
- **Agent-Specific Icons**:
  - `✳` Claude Code
  - `󰘚` Antigravity (`agy`)
  - `✦` Gemini
  - `󰡄` OpenAI / Codex
  - `` GitHub Copilot
  - `󰛄` Aider
  - `󰆍` Cursor
- **Interactive Switcher Modal with Live Preview (`prefix + A`)**:
  - When multiple agents exist, pressing `prefix + A` opens an interactive popup modal.
  - Features an **instant live ANSI-colored preview** of the highlighted agent's pane on the right side.
  - Navigate with <kbd>↑</kbd>/<kbd>↓</kbd> or <kbd>j</kbd>/<kbd>k</kbd>, press <kbd>Enter</kbd> to jump to that agent, or <kbd>Esc</kbd> to close.
  - When only 1 background agent exists, jumps directly without opening the modal.

## Configuration in `tmux.conf`

```tmux
# Status refresh interval
set -g status-interval 2

# Status-right configuration
set -g status-right '#(~/.config/tmux/plugins/tmux-agent-status/scripts/agent_status.sh)#[fg=#{@user_icon_fg}]  #(~/.config/tmux/scripts/user_host.sh)'

# Optional customizations:
# set -g @agent-status-attention-color "#[fg=#bf616a,bold]"
# set -g @agent-status-working-color "#[fg=#ebcb8b]"
# set -g @agent-status-done-color "#[fg=#a3be8c]"
# set -g @agent-status-current-session-only "false"
# set -g @agent-status-jump-key "A"

# Load plugin
run-shell ~/.config/tmux/plugins/tmux-agent-status/tmux-agent-status.tmux
```
