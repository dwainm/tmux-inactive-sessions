#!/bin/bash

# Script to list inactive tmux sessions (no activity since creation, no child processes)
# Usage: list-inactive-sessions.sh [-k] [-i]
# -k: Kill all inactive sessions instead of listing them
# -i: Interactive mode (only works inside tmux)

# Parse command line arguments
KILL_MODE=false
INTERACTIVE_MODE=false

# Auto-enable interactive mode when inside tmux (unless -k is specified)
# Check both TMUX and TMUX_PANE to handle run-shell context
if [ -n "$TMUX" ] || [ -n "$TMUX_PANE" ]; then
  INTERACTIVE_MODE=true
fi

while getopts "ki" opt; do
  case $opt in
    k)
      KILL_MODE=true
      INTERACTIVE_MODE=false  # -k overrides interactive mode
      ;;
    i)
      INTERACTIVE_MODE=true
      ;;
    \?)
      echo "Usage: $0 [-k] [-i]" >&2
      echo "  -k: Kill all inactive sessions instead of listing them" >&2
      echo "  -i: Force interactive mode (auto-enabled inside tmux)" >&2
      exit 1
      ;;
  esac
done

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

# Collect inactive sessions
inactive_sessions=()

# Process each session and collect inactive ones
while IFS=' ' read -r session created; do
  # Handle unnamed sessions
  original_session="$session"
  if [ -z "$session" ] || [ "$session" = "" ]; then
    session="[unnamed-session]"
  fi
  
  # Check if session is inactive based on different criteria
  is_inactive=false
  reason=""
  
  # Criterion 1: Unnamed sessions (numeric names) older than 1 hour
  if echo "$original_session" | grep -Eq '^[0-9]+$'; then
    current_time=$(date +%s)
    session_age=$((current_time - created))
    if [ $session_age -gt 3600 ]; then  # 3600 seconds = 1 hour
      is_inactive=true
      reason="unnamed session older than 1 hour"
    fi
  fi
  
  # Criterion 2: Sessions with no activity since creation and no processes
  if [ "$is_inactive" = false ]; then
    latest_activity=$(tmux list-windows -t "$original_session" -F "#{window_activity}" | sort -n | tail -1)
    
    if [ "$latest_activity" = "$created" ]; then
      # Check if all panes have no child processes
      has_processes=false
      while IFS=' ' read -r pane pid; do
        if ps -o pid= --ppid "$pid" 2>/dev/null | grep -q .; then
          has_processes=true
          break
        fi
      done < <(tmux list-panes -t "$original_session" -F "#{pane_index} #{pane_pid}")
      
      if [ "$has_processes" = false ]; then
        is_inactive=true
        reason="no process running"
      else
        is_inactive=true
        reason="last updated $(format_timestamp "$created")"
      fi
    fi
  fi
  
  # Add to inactive sessions if it meets any criteria
  if [ "$is_inactive" = true ]; then
    inactive_sessions+=("$original_session")
    
    # Display info if not in kill mode and not in interactive mode
    if [ "$KILL_MODE" = false ] && [ "$INTERACTIVE_MODE" = false ]; then
      windows=$(tmux list-windows -t "$original_session" | wc -l)
      display_name="$original_session"
      if [ -z "$original_session" ] || [ "$original_session" = "" ]; then
        display_name="[unnamed-session]"
      fi
      echo "$display_name: $windows windows ($reason)"
    fi
  fi
done < <(tmux list-sessions -F "#{session_name} #{session_created}")

# Interactive mode: call separate interactive script (only inside tmux)
if [ "$INTERACTIVE_MODE" = true ]; then
  # Check if we're inside tmux - but also check if we're being run from tmux via run-shell
  if [ -z "$TMUX" ] && [ -z "$TMUX_PANE" ]; then
    echo "Interactive mode only works inside tmux" >&2
    exit 1
  fi
  
  # Call the interactive script which can launch choose-tree
  exec "$(dirname "$0")/interactive-inactive-sessions.sh"
fi

# Kill mode: remove all inactive sessions
if [ "$KILL_MODE" = true ]; then
  if [ ${#inactive_sessions[@]} -eq 0 ]; then
    echo "No inactive sessions to kill"
    exit 0
  fi
  
  echo "Killing ${#inactive_sessions[@]} inactive sessions..."
  for session in "${inactive_sessions[@]}"; do
    echo "  Killing session: $session"
    tmux kill-session -t "$session" 2>/dev/null || echo "    Warning: Failed to kill session $session"
  done
  echo "Done."
fi
