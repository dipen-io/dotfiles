#!/usr/bin/env python3
import subprocess
import os

SESSION_FILE = os.path.expanduser("~/script/session_name")

def ensure_session_file():
    os.makedirs(os.path.dirname(SESSION_FILE), exist_ok=True)
    open(SESSION_FILE, 'a').close()

def list_sessions():
    """Returns a list of stored tmux session names without duplicates."""
    ensure_session_file()
    with open(SESSION_FILE, 'r') as f:
        return sorted(set(line.strip() for line in f if line.strip()))

def running_sessions():
    """Returns a set of currently running tmux sessions."""
    result = subprocess.run(["tmux", "list-sessions"], capture_output=True, text=True)
    if result.returncode != 0:
        return set()
    return {line.split(":")[0] for line in result.stdout.splitlines()}

def create_session(name):
    """Creates a new tmux session if it doesn't already exist."""
    active_sessions = running_sessions()
    if name in active_sessions:
        print(f"⚠️ Session '{name}' is already running. Attaching...")
        attach_session(name)
        return
    
    subprocess.run(["tmux", "new-session", "-d", "-s", name])
    
    stored_sessions = list_sessions()
    if name not in stored_sessions:
        with open(SESSION_FILE, 'a') as f:
            f.write(name + "\n")
    
    attach_session(name)

def attach_session(name):
    """Attaches to an existing tmux session."""
    if "TMUX" in os.environ:
        subprocess.run(["tmux", "switch-client", "-t", name])
    else:
        subprocess.run(["tmux", "attach", "-t", name])

def kill_session(name):
    """Kills a tmux session."""
    subprocess.run(["tmux", "kill-session", "-t", name])

def remove_session_name(name):
    """Removes a session name from the session file without affecting running sessions."""
    stored_sessions = list_sessions()
    if name in stored_sessions:
        stored_sessions.remove(name)
        with open(SESSION_FILE, 'w') as f:
            f.write("\n".join(stored_sessions) + "\n")
        print(f"🗑 Removed session name '{name}' from the session list.")
    else:
        print(f"⚠️ Session name '{name}' not found in saved sessions.")

def rename_session_name(old_name, new_name):
    """Renames a session name in the session file without affecting running sessions."""
    stored_sessions = list_sessions()
    if old_name in stored_sessions:
        if new_name in stored_sessions:
            print(f"⚠️ The name '{new_name}' already exists. Choose a different name.")
            return
        stored_sessions.remove(old_name)
        stored_sessions.append(new_name)
        with open(SESSION_FILE, 'w') as f:
            f.write("\n".join(stored_sessions) + "\n")
        print(f"✏ Renamed session '{old_name}' to '{new_name}' in the session list.")
    else:
        print(f"⚠️ Session name '{old_name}' not found in saved sessions.")

def main():
    ensure_session_file()
    
    while True:
        all_sessions = list_sessions()
        active_sessions = running_sessions()

        # Running sessions appear first
        session_list = [f" ➢  {s} (running)" if s in active_sessions else f" ⤷  {s}" for s in sorted(active_sessions) + sorted(set(all_sessions) - active_sessions)]

        # Hidden options (appear when scrolling or searching)
        hidden_options = [ "───────────", " ✚  new session", " ☠  kill session", " ⤬  remove session name", " ⟳  rename session name", " ⤫  exit"]

        # Combine session list with a line separator before options
        menu_items = session_list + hidden_options

        selected = subprocess.run(
            ["fzf", "--height=40%", "--reverse", "--prompt=TMUX session: "],
            input="\n".join(menu_items), text=True, capture_output=True
        ).stdout.strip()

        if not selected or "exit" in selected.lower():
            break
        elif "new session" in selected.lower():
            new_name = input("New session name: ").strip()
            if new_name:
                create_session(new_name)
        elif "kill session" in selected.lower():
            while True:
                active_sessions = running_sessions()
                if not active_sessions:
                    print("🚫 No running sessions available to kill")
                    break
                kill_choice = subprocess.run(
                    ["fzf", "--height=40%", "--reverse", "--prompt=Kill session: "],
                    input="\n".join(sorted(active_sessions) + ["⬅ Back"]), text=True, capture_output=True
                ).stdout.strip()
                if not kill_choice or kill_choice == "⬅ Back":
                    break
                kill_session(kill_choice)
        elif "remove session name" in selected.lower():
            while True:
                stored_sessions = list_sessions()
                if not stored_sessions:
                    print("🚫 No stored session names to remove.")
                    break
                remove_choice = subprocess.run(
                    ["fzf", "--height=40%", "--reverse", "--prompt=Remove session name: "],
                    input="\n".join(sorted(stored_sessions) + ["⬅ Back"]), text=True, capture_output=True
                ).stdout.strip()
                if not remove_choice or remove_choice == "⬅ Back":
                    break
                remove_session_name(remove_choice)
        elif "rename session name" in selected.lower():
            while True:
                stored_sessions = list_sessions()
                if not stored_sessions:
                    print("🚫 No stored session names to rename.")
                    break
                rename_choice = subprocess.run(
                    ["fzf", "--height=40%", "--reverse", "--prompt=Rename session name: "],
                    input="\n".join(sorted(stored_sessions) + ["⬅ Back"]), text=True, capture_output=True
                ).stdout.strip()
                if not rename_choice or rename_choice == "⬅ Back":
                    break
                new_name = input(f"Enter new name for '{rename_choice}': ").strip()
                if new_name:
                    rename_session_name(rename_choice, new_name)
        else:
            session_name = selected.replace("➢", "").replace("⤷", "").replace("(running)", "").strip()  
            create_session(session_name)

if __name__ == "__main__":
    main()

