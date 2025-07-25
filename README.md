
# tmux-inactive-sessions

A tmux plugin to list and manage inactive tmux sessions with interactive capabilities.

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

3. **Optional**: Add key binding to your `~/.tmux.conf`:
   ```tmux
   bind-key i run-shell '~/.tmux/plugins/tmux-inactive-sessions/scripts/interactive-inactive-sessions.sh'
   ```

## Usage

### Interactive Mode (Inside tmux)

When used inside tmux, the plugin launches an interactive chooser using tmux's built-in `choose-tree`:

**Command**: `:list-inactive-sessions`

**Interactive Features:**
- Navigate with ↑/↓ arrow keys
- Press **Enter** to switch to selected session
- Press **x** to kill selected session (with confirmation)
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

A session is considered inactive when it meets **either** of these criteria:

### Criterion 1: Old Unnamed Sessions
- Session has a numeric name (0, 1, 2, etc. - tmux's default unnamed sessions)
- AND session is older than 1 hour

### Criterion 2: Never-Used Sessions  
- Session hasn't been used since creation (no window activity after the creation time)
- AND it has no active child processes running

This helps identify both abandoned sessions and old unnamed sessions that clutter your tmux environment.
