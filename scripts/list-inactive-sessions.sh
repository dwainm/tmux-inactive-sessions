#!/bin/bash

# Script to list inactive tmux sessions (no activity since creation, no child processes)

# Ensure tmux is running and sessions exist
if ! tmux list-sessions >/dev/null 2>&1; then
  echo "No tmux sessions found" >&2
  exit 1
fi

# Function to format timestamp (simple format without timezone)
format_timestamp() {
  local timestamp=$1
  if command -v date >/dev/null 2>&1; then
    date -d "@$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null || date -r "$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null
  else
    echo "$timestamp"
  fi
}

# Iterate over all sessions
tmux list-sessions -F "#{session_name} #{session_created}" | while read -r session created; do
  # Handle unnamed sessions
  if [ -z "$session" ] || [ "$session" = "" ]; then
    session="[unnamed-session]"
  fi
  # Check if latest window activity matches creation time
  latest_activity=$(tmux list-windows -t "$session" -F "#{window_activity}" | sort -n | tail -1)
  
  # Only proceed if session hasn't been used since creation
  if [ "$latest_activity" = "$created" ]; then
    # Check if all panes have no child processes
    has_processes=false
    while read -r pane pid; do
      if ps -o pid= --ppid "$pid" 2>/dev/null | grep -q .; then
        has_processes=true
        break
      fi
    done < <(tmux list-panes -t "$session" -F "#{pane_index} #{pane_pid}")
    
    # Session is inactive - determine reason
    windows=$(tmux list-windows -t "$session" | wc -l)
    if [ "$has_processes" = false ]; then
      echo "$session: $windows windows (no process running)"
    else
      echo "$session: $windows windows (last updated $(format_timestamp "$created"))"
    fi
  fi
done
