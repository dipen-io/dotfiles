#!/usr/bin/env python3
import subprocess
import os
import sys
import re

SESSION_FILE = os.path.expanduser("~/script/session_name")

def ensure_session_file():
    os.makedirs(os.path.dirname(SESSION_FILE), exist_ok=True)
    if not os.path.exists(SESSION_FILE):
        open(SESSION_FILE, 'w').close()

def sanitize_name(name):
    """Tmux sessions cannot contain dots or colons."""
    return name.replace(".", "_").replace(":", "_").strip()

def list_sessions():
    """Returns a list of stored tmux session names without duplicates."""
    ensure_session_file()
    try:
        with open(SESSION_FILE, 'r') as f:
            return sorted(list(set(line.strip() for line in f if line.strip())))
    except FileNotFoundError:
        return []

def running_sessions():
    """Returns a set of currently running tmux sessions."""
    result = subprocess.run(["tmux", "list-sessions"], capture_output=True, text=True)
    if result.returncode != 0:
        return set()
    return {line.split(":")[0] for line in result.stdout.splitlines()}

def create_session(name):
    """Creates a new tmux session if it doesn't already exist."""
    name = sanitize_name(name)
    if not name:
        return

    active_sessions = running_sessions()
    if name in active_sessions:
        attach_session(name)
        return
    
    # Create detached
    subprocess.run(["tmux", "new-session", "-d", "-s", name])
    
    # Save to file if not already there
    stored = list_sessions()
    if name not in stored:
        with open(SESSION_FILE, 'a') as f:
            f.write(name + "\n")
    
    attach_session(name)

def attach_session(name):
    """Attaches or switches to a tmux session and cleans up."""
    if "TMUX" in os.environ:
        # 1. Switch the client to the new session
        subprocess.run(["tmux", "switch-client", "-t", name])
        
        # 2. Kill the 'picker' window we created in main()
        # This keeps your original window exactly as it was
        subprocess.run(["tmux", "kill-window", "-t", "picker"])
        sys.exit(0)
    else:
        # If running from a raw TTY/Terminal, just replace process
        os.execvp("tmux", ["tmux", "attach", "-t", name])

# def attach_session(name):
#     """
#     Attaches or switches to a tmux session.
#     Uses os.execvp to replace the script process, 
#     ensuring the script closes after switching.
#     """
#     if "TMUX" in os.environ:
#         # We are inside tmux, switch the client and exit script
#         os.execvp("tmux", ["tmux", "switch-client", "-t", name])
#     else:
#         # We are in a standard terminal, attach and exit script
#         os.execvp("tmux", ["tmux", "attach", "-t", name])

def kill_session(name):
    """Kills a tmux session and cleans up fzf artifacts."""
    name = name.strip()
    subprocess.run(["tmux", "kill-session", "-t", name])

def remove_session_name(name):
    """Removes a session name from the list."""
    stored_sessions = list_sessions()
    if name in stored_sessions:
        stored_sessions.remove(name)
        with open(SESSION_FILE, 'w') as f:
            f.write("\n".join(stored_sessions) + ("\n" if stored_sessions else ""))
        print(f"🗑 Removed '{name}' from history.")

def rename_session_name(old_name, new_name):
    """Renames a session in the file."""
    new_name = sanitize_name(new_name)
    stored_sessions = list_sessions()
    if old_name in stored_sessions:
        if new_name in stored_sessions:
            print(f"⚠️ '{new_name}' already exists.")
            return
        stored_sessions = [new_name if s == old_name else s for s in stored_sessions]
        with open(SESSION_FILE, 'w') as f:
            f.write("\n".join(stored_sessions) + "\n")

def get_input(prompt):
    """Safe input helper to handle Ctrl+C."""
    try:
        return input(prompt).strip()
    except (EOFError, KeyboardInterrupt):
        return None

def main():
    ensure_session_file()

    # --- AUTO-WINDOW LOGIC ---
    if "TMUX" in os.environ:
        # Check current window name to avoid infinite loops
        current_window = subprocess.run(
            ["tmux", "display-message", "-p", "#W"], 
            capture_output=True, text=True
        ).stdout.strip()

        if current_window != "picker":
            # Spawn the script in a new window and exit this instance
            subprocess.run(["tmux", "new-window", "-n", "picker", f"python3 {__file__}"])
            sys.exit(0)
    # -------------------------
    
    while True:
        all_sessions = list_sessions()
        active = running_sessions()

        # Build Menu
        session_list = []
        for s in sorted(active):
            session_list.append(f" ➢  {s} (running)")
        for s in sorted(set(all_sessions) - active):
            session_list.append(f" ⤷  {s}")

        options = [
            "───────────",
            " ✚  new session",
            " ☠  kill session",
            " ⤬  remove session name",
            " ⟳  rename session name",
            " ⤫  exit"
        ]

        menu_items = session_list + options

        proc = subprocess.run(
            ["fzf", "--height=40%", "--reverse", "--prompt=TMUX: ", "--ansi"],
            input="\n".join(menu_items), text=True, capture_output=True
        )
        selected = proc.stdout.strip()

        if not selected or "exit" in selected:
            break

        # Handle Menu Actions
        if "new session" in selected:
            name = get_input("New session name: ")
            if name: create_session(name)
            
        elif "kill session" in selected:
            current_active = sorted(running_sessions())
            if not current_active: continue
            sel = subprocess.run(["fzf", "--reverse", "--prompt=Kill: "], 
                                input="\n".join(current_active), text=True, capture_output=True).stdout.strip()
            if sel: kill_session(sel)

        elif "remove session name" in selected:
            current_stored = sorted(list_sessions())
            sel = subprocess.run(["fzf", "--reverse", "--prompt=Remove: "], 
                                input="\n".join(current_stored), text=True, capture_output=True).stdout.strip()
            if sel: remove_session_name(sel)

        elif "rename session name" in selected:
            current_stored = sorted(list_sessions())
            old = subprocess.run(["fzf", "--reverse", "--prompt=Rename: "], 
                                input="\n".join(current_stored), text=True, capture_output=True).stdout.strip()
            if old:
                new = get_input(f"New name for '{old}': ")
                if new: rename_session_name(old, new)

        elif "───────────" in selected:
            continue
            
        else:
            # Logic to extract name from " ➢  name (running)" or " ⤷  name"
            clean_name = re.sub(r'^[ ➢⤷]+', '', selected).replace("(running)", "").strip()
            create_session(clean_name)

if __name__ == "__main__":
    main()
