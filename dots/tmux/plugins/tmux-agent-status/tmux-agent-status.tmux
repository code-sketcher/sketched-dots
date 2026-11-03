#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

agent_status_interpolation="#{agent_status}"
agent_status_cmd="#($CURRENT_DIR/scripts/agent_status.sh)"

set_jump_binding() {
  local key
  key="$(get_tmux_option "@agent-status-jump-key" "A")"
  if [ -n "$key" ]; then
    tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/jump_to_agent.sh" 2>/dev/null || true
  fi
}

update_status_option() {
  local option="$1"
  local option_value
  option_value="$(get_tmux_option "$option" "")"
  if [[ "$option_value" == *"$agent_status_interpolation"* ]]; then
    local new_option_value="${option_value//$agent_status_interpolation/$agent_status_cmd}"
    tmux set-option -gq "$option" "$new_option_value" 2>/dev/null || true
  fi
}

main() {
  set_jump_binding
  update_status_option "status-right"
  update_status_option "status-left"
}

main
