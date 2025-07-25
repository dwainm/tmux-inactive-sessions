
# tmux-inactive-sessions

A tmux plugin to list inactive sessions (created but never used or with no active processes).

## Installation

1. Add to `~/.tmux.conf`:
   ```tmux
   set -g @plugin 'tmux-plugins/tpm'
   set -g @plugin 'dwainm/tmux-inactive-sessions'
   run '~/.tmux/plugins/tpm/tpm'
