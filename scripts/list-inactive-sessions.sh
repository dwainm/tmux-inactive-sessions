#!/bin/bash

# Script to list inactive tmux sessions (no activity since creation, no child processes)

# Ensure tmux is running and sessions exist
if ! tmux list-sessions >/dev/null 2>&1; then
  echo "No tmux sessions found" >&2
  exit 1
fi

# Function to format timestamp
format_timestamp() {
  local timestamp=$1
  if command -v date >/dev/null 2>&1; then
    date -d "@$timestamp" 2>/dev/null || date -r "$timestamp" 2>/dev/null
  else
    echo "$timestamp"
  fi
}

# Iterate over all sessions
tmux list-sessions -F "#{session_name} #{session_created}" | while read -r session created; do
  # Check if latest window activity matches creation time
  latest_activity=$(tmux list-windows -t "$session" -F "#{window_activity}" | sort -n | tail -1)
  if [ "$latest_activity" = "$created" ]; then
    # Check if all panes have no child processes
    idle=true
    while read -r pane pid; do
      if ps -o pid= --ppid "$pid" | grep -q .; then
        idle=false
        break
      fi
    done < <(tmux list-panes -t "$session" -F "#{pane_index} #{pane_pid}")
    
    # If session is idle, output in tmux-like format
    if [ "$idle" = true ]; then
      windows=$(tmux list-windows -t "$session" | wc -l)
      created_formatted=$(format_timestamp "$created")
      echo "$session: $windows windows (created $created_formatted) (idle)"
    fi
  fi
done
