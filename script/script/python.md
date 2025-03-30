
# TMUX Session Manager

## Overview
This script provides a convenient interface for managing TMUX sessions using `fzf` for interactive selection. It allows you to:

- View all saved and running TMUX sessions.
- Create a new TMUX session.
- Attach to an existing TMUX session.
- Kill a running TMUX session.

## Prerequisites
Ensure you have the following installed on your system:

- [tmux](https://github.com/tmux/tmux) - Terminal multiplexer.
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder for interactive selection.

## Installation
1. Clone or copy the script to a directory of your choice.
2. Ensure `tmux` and `fzf` are installed on your system.
3. Save the script as `tmux_session_manager.py`.
4. Make sure the script is executable:
   ```sh
   chmod +x tmux_session_manager.py
   ```

## Usage
Run the script using:
```sh
python tmux_session_manager.py
```

### Main Menu Options:
- **Select a session**: Attach to a running or saved session.
- **New session**: Create a new TMUX session.
- **Kill session**: Terminate an active session.
- **Exit**: Quit the script.

### Creating a New Session
1. Select `Ⓝ New session` from the menu.
2. Enter a valid session name.
3. The session will be created and switched to automatically.

### Attaching to an Existing Session
- If a session is running, selecting it from the menu will attach to it.
- If the session is not running, a new session will be created with that name.

### Killing a Session
1. Select `Ⓚ Kill session` from the menu.
2. Choose a running session to terminate.
3. The session is killed but remains in the saved session list.
4. You will stay in the kill session menu until manually exiting or no sessions remain.

## Session File
- The script maintains a session list in `~/script/session_name`.
- This file ensures that even if a session is not running, it remains available for future selection.

## Notes
- If executed inside a running TMUX session, the script will automatically switch to the selected session instead of attaching.
- Running sessions are displayed at the top of the session list.

## License
This script is provided under the MIT License.

