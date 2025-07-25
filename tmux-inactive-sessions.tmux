# tmux-inactive-sessions plugin entry point
# Defines a custom tmux command to list inactive sessions

# Create the custom command using bind-key
bind-key -T prefix i run-shell "#{@plugin_root}/scripts/list-inactive-sessions.sh"

# Also create it as a command that can be called directly
set-option -g command-alias[0] "list-inactive-sessions=run-shell '#{@plugin_root}/scripts/list-inactive-sessions.sh'"

# Set the plugin root path
set-option -g @plugin_root "~/.tmux/plugins/tmux-inactive-sessions"
