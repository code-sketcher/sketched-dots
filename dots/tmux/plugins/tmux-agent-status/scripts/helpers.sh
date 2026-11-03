#!/usr/bin/env bash

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value="$(tmux show-option -gqv "$option" 2>/dev/null)"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

get_agent_name() {
  local cmd="$1"
  local title="$2"
  local declared="$3"

  if [ -n "$declared" ]; then
    echo "$declared"
    return
  fi

  case "$cmd" in
    claude*)
      echo "claude"
      return
      ;;
    agy*|antigravity*)
      echo "agy"
      return
      ;;
    codex*|copilot*|aider*|gemini*|cursor*|devin*|cline*|opencode*|qwen*|droid*|amp*|grok*|hermes*|kilo*|kiro*|maki*)
      echo "$cmd"
      return
      ;;
  esac

  case "$title" in
    *Claude*|*✳*|*✻*) echo "claude" ;;
    *Antigravity*|*agy*) echo "agy" ;;
    *Aider*) echo "aider" ;;
    *Codex*) echo "codex" ;;
    *Gemini*) echo "gemini" ;;
  esac
}
