#!/bin/bash

# tmux-inactive-sessions plugin entry point
# Defines a custom tmux command to list inactive sessions

# Store the script path in a tmux option
tmux set-option -g @tmux-inactive-sessions-script "$TMUX_PROGRAM ${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}/tmux-inactive-sessions/scripts/list-inactive-sessions.sh"

# Define a custom tmux command: list-inactive-sessions
tmux run-shell -b "tmux set-option -g @tmux-inactive-sessions-command 'run-shell #{@tmux-inactive-sessions-script}'"
tmux command-alias list-inactive-sessions="run-shell #{@tmux-inactive-sessions-script}"
