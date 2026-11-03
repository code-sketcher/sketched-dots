#!/usr/bin/env bash

# Helper CLI tool to report agent status from shell / hooks / aliases
# Usage:
#   notify_agent.sh waiting [agent_name] [pane_id]
#   notify_agent.sh working [agent_name] [pane_id]
#   notify_agent.sh done    [agent_name] [pane_id]
#   notify_agent.sh clear   [pane_id]
#   notify_agent.sh hook            (reads a Claude Code hook payload on stdin)

action="${1:-waiting}"
agent_name="$2"
target_pane="${3:-$TMUX_PANE}"

if ! command -v tmux >/dev/null 2>&1 || [ -z "${TMUX:-}$target_pane" ]; then
  exit 0
fi

if [ "$action" = "hook" ]; then
  payload="$(cat)"

  case "$payload" in
    *'"agent_id"'*) exit 0 ;;
  esac

  event="$(printf '%s' "$payload" | tr -d '\n' | sed -n 's/.*"hook_event_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"

  case "$event" in
    Notification)
      case "$payload" in
        *"needs your permission"*|*"permission to use"*) action="waiting" ;;
        *) action="done" ;;
      esac
      ;;
    Stop) action="done" ;;
    UserPromptSubmit|PreToolUse|PostToolUse) action="working" ;;
    SessionEnd) action="clear" ;;
    *) exit 0 ;;
  esac

  agent_name="claude"
fi

pane_target_flag=()
if [ -n "$target_pane" ]; then
  pane_target_flag=(-t "$target_pane")
fi

set_status() {
  tmux set-option -p "${pane_target_flag[@]}" @agent_status "$1"
  if [ -n "$agent_name" ]; then
    tmux set-option -p "${pane_target_flag[@]}" @agent_name "$agent_name"
  fi
}

case "$action" in
  waiting|blocked|needs_input|attention|permission)
    set_status "waiting"
    ;;
  working|busy|thinking|running)
    set_status "working"
    ;;
  done|finished)
    set_status "done"
    ;;
  clear|reset|idle)
    tmux set-option -pu "${pane_target_flag[@]}" @agent_status 2>/dev/null || true
    tmux set-option -pu "${pane_target_flag[@]}" @agent_name 2>/dev/null || true
    ;;
esac

# Trigger status bar refresh
tmux refresh-client -S 2>/dev/null || true

exit 0
