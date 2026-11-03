#!/usr/bin/env bash

set -u

get_foreground_command() {
  local pane_tty="$1"
  ps -t "$pane_tty" -o tpgid=,pgid=,command= |
    awk '$1 == $2 { $1 = ""; $2 = ""; sub(/^ +/, ""); print; exit }'
}

get_ssh_host() {
  local pane_tty="$1"
  local pane_command
  pane_command="$(get_foreground_command "$pane_tty")"
  if [ "${pane_command%% *}" != 'ssh' ]; then
    return
  fi
  printf '%s\n' "$pane_command" | awk 'NF { print $NF; exit }'
}

get_username() {
  local ssh_host="$1"
  local resolved
  if [ -z "$ssh_host" ]; then
    whoami
    return
  fi
  resolved="$(ssh -G "$ssh_host" 2>/dev/null | awk '/^user / { print $2; exit }')"
  printf '%s\n' "${resolved:-$(whoami)}"
}

get_hostname() {
  local ssh_host="$1"
  local resolved
  if [ -z "$ssh_host" ]; then
    resolved="$(hostname)"
  else
    resolved="$(ssh -G "$ssh_host" 2>/dev/null | awk '/^hostname / { print $2; exit }')"
    resolved="${resolved:-$ssh_host}"
  fi
  printf '%s\n' "${resolved%%.*}"
}

main() {
  local pane_tty ssh_host
  pane_tty="${1:-$(tmux display-message -p '#{pane_tty}')}"
  ssh_host="$(get_ssh_host "$pane_tty")"
  printf '%s | %s\n' "$(get_username "$ssh_host")" "$(get_hostname "$ssh_host")"
}

main "$@"
