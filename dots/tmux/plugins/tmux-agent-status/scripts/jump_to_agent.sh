#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/bin:$PATH"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/agent_status.sh"

jump() {
  local current_session_only
  current_session_only="$(get_tmux_option "@agent-status-current-session-only" "false")"

  local current_session=""
  if [ "$current_session_only" = "true" ]; then
    current_session="$(tmux display-message -p '#{session_name}' 2>/dev/null)"
  fi

  local panes
  panes="$(tmux list-panes -a -F "#{session_name}	#{window_index}	#{pane_index}	#{pane_id}	#{pane_active}	#{window_active}	#{session_attached}	#{pane_current_command}	#{pane_title}	#{@agent_status}	#{@agent_name}" 2>/dev/null)"

  if [ -z "$panes" ]; then
    tmux display-message "No tmux panes found" 2>/dev/null || true
    return
  fi

  local agent_count=0
  local single_pane_id=""
  local single_session=""
  local single_win=""
  local single_name=""
  local single_is_focused=0

  while IFS=$'\t' read -r session win pane_idx pane_id pane_act win_act sess_att cmd title agent_status agent_name; do
    if [ "$current_session_only" = "true" ] && [ -n "$current_session" ] && [ "$session" != "$current_session" ]; then
      continue
    fi

    local current_name
    current_name="$(get_agent_name "$cmd" "$title" "$agent_name")"

    if [ -z "$current_name" ]; then
      continue
    fi

    agent_count=$((agent_count + 1))
    single_pane_id="$pane_id"
    single_session="$session"
    single_win="$win"
    single_name="$current_name"

    if [ "$pane_act" = "1" ] && [ "$win_act" = "1" ] && [ "$sess_att" -ge "1" ] 2>/dev/null; then
      single_is_focused=1
    fi
  done <<< "$panes"

  if [ "$agent_count" -eq 0 ]; then
    tmux display-message "No AI agents found running" 2>/dev/null || true
    return
  fi

  # If there is only 1 agent and we're not currently focused on it, jump directly
  if [ "$agent_count" -eq 1 ] && [ "$single_is_focused" -eq 0 ]; then
    tmux select-window -t "${single_session}:${single_win}" 2>/dev/null || true
    tmux select-pane -t "${single_pane_id}" 2>/dev/null || true
    tmux switch-client -t "${single_session}" 2>/dev/null || true
    tmux display-message "Jumped to ${single_name} (${single_session}:${single_win})" 2>/dev/null || true
    return 0
  fi

  # Otherwise (multiple agents or already focused on the only agent), open the live preview modal
  tmux display-popup -E -w 92% -h 80% -T " 󰚩 AI Agent Switcher " "$CURRENT_DIR/choose_agent.sh"
}

jump "$@"
