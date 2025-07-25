#!/bin/bash

# Interactive chooser for inactive sessions
# Simple version focusing on old unnamed sessions

# Find old unnamed sessions (numeric names older than 1 hour)
inactive_sessions=()
current_time=$(date +%s)

while IFS=' ' read -r session created; do
  if echo "$session" | grep -Eq '^[0-9]+$'; then
    session_age=$((current_time - created))
    if [ $session_age -gt 3600 ]; then  # 1 hour
      inactive_sessions+=("$session")
    fi
  fi
done < <(tmux list-sessions -F "#{session_name} #{session_created}")

if [ ${#inactive_sessions[@]} -eq 0 ]; then
  tmux display-message "No inactive sessions found"
  exit 0
fi

# Build menu items
menu_items=""
for session in "${inactive_sessions[@]}"; do
  windows=$(tmux list-windows -t "$session" | wc -l)
  hours=$((( $(date +%s) - $(tmux list-sessions -F "#{session_name} #{session_created}" | grep "^$session " | cut -d' ' -f2) ) / 3600))
  menu_items+="\"$session ($windows windows, ${hours}h old)\" \"\" \"switch-client -t '$session'\" "
  menu_items+="\"  → Kill $session\" \"x\" \"confirm-before 'kill-session -t $session'\" "
  menu_items+="\"\" \"\" \"\" "  # separator
done

# Remove trailing separator
menu_items="${menu_items% \"\" \"\" \"\" }"

# Debug: show what we're trying to execute
echo "Menu items: $menu_items" > /tmp/debug-menu.log
echo "Command: tmux display-menu -T 'Old Unnamed Sessions' $menu_items" >> /tmp/debug-menu.log

# Try choose-tree instead of display-menu
# Build a simple filter for sessions that are numeric and old
current_time=$(date +%s)
old_threshold=$((current_time - 3600))  # 1 hour ago

# Use choose-tree with a format that shows session info
tmux choose-tree -s \
  -f "#{&&:#{m/r:^[0-9]+$,#{session_name}},#{<:#{session_created},$old_threshold}}" \
  -F "#{session_name}: #{session_windows} windows (#{t:session_created})" \
  -O name \
  -K 'x:kill-session -t "%%"' \
  "switch-client -t '%%'"