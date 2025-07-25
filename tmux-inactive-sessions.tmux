# tmux-inactive-sessions plugin entry point
# Defines a custom tmux command to list inactive sessions

# Command alias for listing inactive sessions
set-option -g command-alias[0] "list-inactive-sessions=run-shell '#{@plugin_root}/scripts/interactive-inactive-sessions.sh'"

# Set the plugin root path
set-option -g @plugin_root "~/.tmux/plugins/tmux-inactive-sessions"
