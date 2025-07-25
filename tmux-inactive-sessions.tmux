# tmux-inactive-sessions plugin entry point
# Defines a custom tmux command to list inactive sessions

# Native tmux interactive chooser for inactive sessions
# Filter sessions where session_activity equals session_created (no activity since creation)
bind-key -T prefix i choose-tree -s -f '#{==:#{session_activity},#{session_created}}' -F "#{session_name}: #{session_windows} windows (inactive)" -O name -K 'x:kill-session -t "%%"' "switch-client -t '%%'"

# Command alias for the same functionality
set-option -g command-alias[0] "list-inactive-sessions=choose-tree -s -f '#{==:#{session_activity},#{session_created}}' -F '#{session_name}: #{session_windows} windows (inactive)' -O name -K 'x:kill-session -t \"%%\"' 'switch-client -t \"%%\"'"

# Set the plugin root path
set-option -g @plugin_root "~/.tmux/plugins/tmux-inactive-sessions"
