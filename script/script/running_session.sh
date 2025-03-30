#!/usr/bin/env python3
import subprocess
import os

WINDOW_TITLE = "tmux_session_selector"
TMUX_CMD = "/usr/bin/tmux"  # Change this if `which tmux` gives a different path

def get_window_id():
    """Gets the sway window ID of the running Alacritty instance with the given title."""
    try:
        result = subprocess.run(
            ["swaymsg", "-t", "get_tree"], capture_output=True, text=True
        )
        windows = result.stdout
        return WINDOW_TITLE in windows
    except Exception:
        return False

def get_running_sessions():
    """Returns a list of currently running tmux session names."""
    result = subprocess.run([TMUX_CMD, "list-sessions", "-F", "#{session_name}"], capture_output=True, text=True)
    if result.returncode != 0:
        print("Error: Unable to fetch TMUX sessions. Is TMUX running?")
        return []
    
    sessions = result.stdout.strip().split("\n")
    return [s for s in sessions if s]  # Remove empty lines

def show_menu(sessions):
    """Displays fzf menu with running sessions only."""
    result = subprocess.run(
        ["fzf", "--height=40%", "--reverse", "--prompt=TMUX Session: ", "--preview", f"{TMUX_CMD} capture-pane -pt {{}}"],
        input="\n".join(sessions), text=True, capture_output=True
    )
    return result.stdout.strip()

def attach_to_session(session):
    """Attaches to a TMUX session or switches client if inside TMUX."""
    if "TMUX" in os.environ:
        subprocess.run([TMUX_CMD, "switch-client", "-t", session])
    else:
        subprocess.run([TMUX_CMD, "attach", "-t", session])

def main():
    if get_window_id():
        subprocess.run(["swaymsg", "[title={}] focus".format(WINDOW_TITLE)])
        return  # Focus existing window instead of opening a new one

    sessions = get_running_sessions()
    if not sessions:
        print("No running TMUX sessions found. Start a session with:")
        print("  tmux new -s my_session")
        return

    selected = show_menu(sessions)
    if selected:
        attach_to_session(selected)

if __name__ == "__main__":
    main()

