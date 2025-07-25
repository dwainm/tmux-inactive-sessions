
# tmux-inactive-sessions

A tmux plugin to list inactive sessions (created but never used or with no active processes).

## Installation

1. Add to `~/.tmux.conf`:
   ```tmux
   set -g @plugin 'tmux-plugins/tpm'
   set -g @plugin 'dwainm/tmux-inactive-sessions'
   run '~/.tmux/plugins/tpm/tpm'
   ```
2. Press `prefix + I` (e.g., `Ctrl+b I`) to install via TPM.

## Usage

Run the subcommand:
```bash
tmux list-inactive-sessions
```
This requires a shell alias (see below).

### Setting Up the Subcommand

To use `tmux list-inactive-sessions`, add this alias to your shell configuration (`~/.bashrc` or `~/.zshrc`):
```bash
alias tmux="tmux -f ~/.tmux.conf"
tmux() {
  if [ "$1" = "list-inactive-sessions" ]; then
    $TMUX_PROGRAM ${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}/tmux-inactive-sessions/scripts/list-inactive-sessions.sh
  else
    command tmux "$@"
  fi
}
```
Then reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### Optional Keybinding

To bind the subcommand to a key (e.g., `prefix + x`), add this to your `~/.tmux.conf`:
```tmux
bind-key x run-shell "$TMUX_PROGRAM ${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}/tmux-inactive-sessions/scripts/list-inactive-sessions.sh"
```
Reload tmux with `tmux source ~/.tmux.conf`. Then press `prefix + x` (e.g., `Ctrl+b x`) to list inactive sessions.

## Output

Lists sessions with no activity since creation and no child processes:
```
work3: 1 windows (created Fri Jul 25 10:28:00 2025 SAST) (idle)
temp1: 1 windows (created Fri Jul 25 10:29:00 2025 SAST) (idle)
```

## Notes

- **Keybinding**: No default keybinding is set to avoid conflicts (e.g., with TPM’s `prefix + I`). Use the suggested `prefix + x` or choose another key in `~/.tmux.conf` (e.g., `prefix + y`).
- **Dependencies**: Requires `tmux`, `ps`, and `date` (standard on Unix-like systems).
