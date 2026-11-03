#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

detect_agent_state() {
  local pane_id="$1"
  local cmd="$2"
  local title="$3"
  local agent_name="$4"
  local explicit_status="$5"

  # 1. Explicit pane variable override
  if [ -n "$explicit_status" ]; then
    case "$explicit_status" in
    attention | blocked | needs_input | permission | waiting)
      echo "attention"
      return
      ;;
    working | busy | thinking | running)
      echo "working"
      return
      ;;
    done | idle | finished)
      echo "done"
      return
      ;;
    esac
  fi

  # Capture non-empty tail of screen
  local screen_tail
  screen_tail="$(tmux capture-pane -t "$pane_id" -p 2>/dev/null | sed -e 's/[[:space:]]*$//' | grep -v '^[[:space:]]*$' | tail -n 14)"

  case "$agent_name" in
  claude)
    if echo "$screen_tail" | grep -qE "(esc to interrupt|↓[[:space:]]*[0-9.]+[kKmM]?[[:space:]]*tokens)"; then
      echo "working"
      return
    fi
    if echo "$screen_tail" | grep -qE "(Enter to select|Do you want to|Do you trust|Would you like to|❯[[:space:]]+[0-9]+\.|\[y/N\]|\[Y/n\]|\[y/n\])"; then
      echo "attention"
      return
    fi
    echo "done"
    return
    ;;

  agy | antigravity)
    if echo "$screen_tail" | grep -qE "(Requesting permission|Do you want to proceed\?|\> 1\.|Allow[[:space:]]+/|Deny|Are you sure)"; then
      echo "attention"
      return
    fi
    if echo "$screen_tail" | grep -qE "(Running command|Running\.\.\.|Thinking\.\.\.|Waiting\.\.\.|⣯|⡿|⣾|⣽|⣻|⢿|⣟|⣷)"; then
      echo "working"
      return
    fi
    if echo "$screen_tail" | grep -qE "(esc to cancel|Gemini|Claude|Opus|GPT)"; then
      echo "done"
      return
    fi
    ;;

  aider | codex | copilot | gemini | cursor | *)
    if echo "$screen_tail" | grep -qE "(Thinking\.\.\.|Running\.\.\.|Generating\.\.\.)"; then
      echo "working"
      return
    fi
    if echo "$screen_tail" | grep -qE "(\[y/n\]|\[Y/n\]|Allow\?|Do you want to|Are you sure)"; then
      echo "attention"
      return
    fi
    if echo "$screen_tail" | grep -qE "(>|aider>)"; then
      echo "done"
      return
    fi
    ;;
  esac
}

get_agent_icon() {
  local agent="$1"
  local custom_icon
  custom_icon="$(get_tmux_option "@agent-status-icon-${agent}" "")"
  if [ -n "$custom_icon" ]; then
    echo "$custom_icon"
    return
  fi

  case "$agent" in
  claude*)
    echo "✳"
    ;;
  agy* | antigravity*)
    echo "󰘚"
    ;;
  gemini*)
    echo "✦"
    ;;
  copilot*)
    echo ""
    ;;
  codex* | openai* | chatgpt*)
    echo "󰡄"
    ;;
  aider*)
    echo "󰛄"
    ;;
  cursor*)
    echo "󰆍"
    ;;
  *)
    echo "󰚩"
    ;;
  esac
}

main() {
  local attention_color
  local working_color
  local done_color
  local default_color="#[default]"
  local current_session_only

  attention_color="$(get_tmux_option "@agent-status-attention-color" "#[fg=#bf616a,bold]")"
  working_color="$(get_tmux_option "@agent-status-working-color" "#[fg=#ebcb8b]")"
  done_color="$(get_tmux_option "@agent-status-done-color" "#[fg=#a3be8c]")"
  current_session_only="$(get_tmux_option "@agent-status-current-session-only" "true")"

  local attention_icon working_icon done_icon
  attention_icon="$(get_tmux_option "@agent-status-attention-icon" "✳")"
  working_icon="$(get_tmux_option "@agent-status-working-icon" "◐ ")"
  done_icon="$(get_tmux_option "@agent-status-done-icon" "✓")"

  local current_session=""
  if [ "$current_session_only" = "true" ]; then
    current_session="$(tmux display-message -p '#{session_name}' 2>/dev/null)"
  fi

  local panes
  panes="$(tmux list-panes -a -F "#{session_name}	#{window_index}	#{pane_index}	#{pane_id}	#{pane_active}	#{window_active}	#{session_attached}	#{pane_current_command}	#{pane_title}	#{@agent_status}	#{@agent_name}" 2>/dev/null)"

  if [ -z "$panes" ]; then
    return
  fi

  local attention_count=0
  local working_count=0
  local done_count=0

  while IFS=$'\t' read -r session win pane_idx pane_id pane_act win_act sess_att cmd title agent_status agent_name; do
    # Optionally filter to current session
    if [ "$current_session_only" = "true" ] && [ -n "$current_session" ] && [ "$session" != "$current_session" ]; then
      continue
    fi

    local current_name
    current_name="$(get_agent_name "$cmd" "$title" "$agent_name")"

    if [ -z "$current_name" ]; then
      continue
    fi

    local state
    state="$(detect_agent_state "$pane_id" "$cmd" "$title" "$current_name" "$agent_status")"

    if [ -z "$state" ]; then
      continue
    fi

    case "$state" in
    attention) attention_count=$((attention_count + 1)) ;;
    working) working_count=$((working_count + 1)) ;;
    done) done_count=$((done_count + 1)) ;;
    esac
  done <<<"$panes"

  local output=""

  if [ "$attention_count" -gt 0 ]; then
    output="${attention_color}${attention_icon}${attention_count}${default_color}"
  fi
  if [ "$working_count" -gt 0 ]; then
    output="${output:+${output}  }${working_color}${working_icon}${working_count}${default_color}"
  fi
  if [ "$done_count" -gt 0 ]; then
    output="${output:+${output}  }${done_color}${done_icon}${done_count}${default_color}"
  fi

  if [ -n "$output" ]; then
    printf "%s  | " "$output"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
