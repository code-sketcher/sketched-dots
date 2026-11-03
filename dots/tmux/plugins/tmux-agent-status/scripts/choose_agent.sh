#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/bin:$PATH"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/agent_status.sh"

main() {
  local current_session_only
  current_session_only="$(get_tmux_option "@agent-status-current-session-only" "false")"

  local current_session=""
  if [ "$current_session_only" = "true" ]; then
    current_session="$(tmux display-message -p '#{session_name}' 2>/dev/null)"
  fi

  local panes
  panes="$(tmux list-panes -a -F "#{session_name}	#{window_index}	#{pane_index}	#{pane_id}	#{pane_active}	#{window_active}	#{session_attached}	#{pane_current_command}	#{pane_title}	#{@agent_status}	#{@agent_name}" 2>/dev/null)"

  if [ -z "$panes" ]; then
    echo "No tmux panes found."
    exit 0
  fi

  local attention_entries=()
  local working_entries=()
  local done_entries=()
  local other_entries=()

  while IFS=$'\t' read -r session win pane_idx pane_id pane_act win_act sess_att cmd title agent_status agent_name; do
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

    local agent_icon
    agent_icon="$(get_agent_icon "$current_name")"

    local location="${session}:${win}.${pane_idx}"
    local is_active=""
    if [ "$pane_act" = "1" ] && [ "$win_act" = "1" ] && [ "$sess_att" -ge "1" ] 2>/dev/null; then
      is_active=" (active)"
    fi

    local state_color state_label
    case "$state" in
      attention) state_color="1;31"; state_label="needs attention" ;;
      working)   state_color="1;33"; state_label="working" ;;
      done)      state_color="1;32"; state_label="done" ;;
      *)         state_color="37";   state_label="idle" ;;
    esac

    local session_label="${title#✳ }"
    if [ -z "$session_label" ]; then
      session_label="$current_name"
    fi
    if [ "${#session_label}" -gt 60 ]; then
      session_label="${session_label:0:59}…"
    fi

    local formatted_entry
    formatted_entry="$(printf "\033[%sm%s %-9s\033[0m \033[90m%-17s\033[0m %s\033[36m%s\033[0m\t%s\t%s\t%s" \
      "$state_color" "$agent_icon" "$state_label" "$location" "$session_label" "$is_active" "$pane_id" "$session" "$win")"

    case "$state" in
      attention) attention_entries+=("$formatted_entry") ;;
      working)   working_entries+=("$formatted_entry") ;;
      done)      done_entries+=("$formatted_entry") ;;
      *)         other_entries+=("$formatted_entry") ;;
    esac
  done <<< "$panes"

  local all_entries=()
  [ ${#attention_entries[@]} -gt 0 ] && all_entries+=("${attention_entries[@]}")
  [ ${#working_entries[@]} -gt 0 ]   && all_entries+=("${working_entries[@]}")
  [ ${#done_entries[@]} -gt 0 ]      && all_entries+=("${done_entries[@]}")
  [ ${#other_entries[@]} -gt 0 ]     && all_entries+=("${other_entries[@]}")

  if [ ${#all_entries[@]} -eq 0 ]; then
    echo "No AI agents found running in tmux."
    exit 0
  fi

  local fzf_opts=(
    --ansi
    --delimiter=$'\t'
    --with-nth=1
    --preview="tmux capture-pane -ep -t {2} 2>/dev/null"
    --preview-window="right:50%:wrap:nohidden"
    --prompt="Switch Agent > "
    --layout=reverse
    --border=rounded
    --color="border:#5c6370,prompt:#56b6c2,header:#abb2bf,pointer:#56b6c2"
    --info=inline
  )

  if fzf --help 2>&1 | grep -q -- "--no-input"; then
    fzf_opts+=(
      --no-input
      --bind "j:down,k:up,l:accept,h:abort,q:abort"
      --bind "g:first,G:last,ctrl-d:half-page-down,ctrl-u:half-page-up"
      --bind "ctrl-f:preview-page-down,ctrl-b:preview-page-up"
      --bind "/:show-input+change-prompt(Search > )"
      --bind "esc:transform:[[ \$FZF_INPUT_STATE == hidden ]] && echo abort || echo 'hide-input+clear-query+change-prompt(Switch Agent > )'"
      --header="j/k: Move | /: Search | Enter: Switch | q: Close"
    )
  else
    fzf_opts+=(--header="Enter: Switch to Agent | Esc: Close")
  fi

  local selected
  selected="$(printf "%b\n" "${all_entries[@]}" | fzf "${fzf_opts[@]}")"

  if [ -n "$selected" ]; then
    local target_pane target_session target_win
    target_pane="$(echo "$selected" | awk -F'\t' '{print $2}')"
    target_session="$(echo "$selected" | awk -F'\t' '{print $3}')"
    target_win="$(echo "$selected" | awk -F'\t' '{print $4}')"

    if [ -n "$target_pane" ]; then
      tmux select-window -t "${target_session}:${target_win}" 2>/dev/null || true
      tmux select-pane -t "${target_pane}" 2>/dev/null || true
      tmux switch-client -t "${target_session}" 2>/dev/null || true
    fi
  fi
}

main "$@"
