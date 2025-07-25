
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

### Interactive Mode (Inside tmux)

When used inside tmux, the plugin automatically launches an interactive chooser:

1. **Key binding**: `prefix + i`
2. **Command mode**: `:list-inactive-sessions`

**Interactive Features:**
- Navigate with ↑/↓ arrow keys
- Press **Enter** to switch to selected session
- Press **x** to kill selected session
- Press **q** to quit chooser

### Non-Interactive Mode (Terminal)

When used outside tmux or with specific flags:

- **List sessions**: `./scripts/list-inactive-sessions.sh`
- **Kill all inactive sessions**: `./scripts/list-inactive-sessions.sh -k`

## Output Format

### Non-Interactive List Output

When listing sessions (outside tmux), the output shows:

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

### Interactive Chooser Display

When using interactive mode, sessions appear as:
```
test1: 1 windows (inactive)
test2: 1 windows (inactive)
```

## What Makes a Session "Inactive"

A session is considered inactive when:
- It hasn't been used since creation (no window activity after the creation time)
- AND it has no active child processes running

This helps identify sessions that were created but abandoned, making it easier to clean up your tmux environment.
