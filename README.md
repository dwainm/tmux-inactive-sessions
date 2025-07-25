
# tmux-inactive-sessions

A tmux plugin to list inactive sessions (created but never used or with no active processes).

## Installation

1. Add to `~/.tmux.conf`:
   ```tmux
   set -g @plugin 'tmux-plugins/tpm'
   set -g @plugin 'dwainm/tmux-inactive-sessions'
   run '~/.tmux/plugins/tpm/tpm'
   ```

2. Reload tmux config and install:
   - Press `prefix + I` to install plugins
   - Or reload manually: `tmux source-file ~/.tmux.conf`

## Usage

The plugin provides three ways to list inactive sessions:

1. **Terminal command**: `tmux list-inactive-sessions`
2. **Within tmux**: `:list-inactive-sessions` (press `:` then type the command)
3. **Key binding**: `prefix + i`

## Output Format

The plugin shows sessions that haven't been used since creation:

```
13:        1 windows (no process running)
14:        1 windows (no process running)
27:        1 windows (no process running)
```

Each line shows:
- **Session name**: The tmux session identifier
- **Window count**: Number of windows in the session
- **Inactivity reason**: Why the session is considered inactive
  - `no process running` - Session has no active processes
  - `last updated [date time]` - Session hasn't been used since creation

## What Makes a Session "Inactive"

A session is considered inactive when:
- It hasn't been used since creation (no window activity after the creation time)
- AND it has no active child processes running

This helps identify sessions that were created but abandoned, making it easier to clean up your tmux environment.
