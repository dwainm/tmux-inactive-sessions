#!/bin/bash

# tmux-inactive-sessions plugin entry point
# Integrates with tmux to list inactive sessions

# Define a tmux command alias to run the list-inactive-sessions script
tmux set -g @inactive-sessions-script "$TMUX_PROGRAM ${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}/tmux-inactive-sessions/scripts/list-inactive-sessions.sh"

# Optional: Users can bind a key in ~/.tmux.conf to run the script, e.g.:
# bind-key x run-shell "$TMUX_PROGRAM ${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}/tmux-inactive-sessions/scripts/list-inactive-sessions.sh"
