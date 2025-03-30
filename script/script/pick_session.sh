#!/usr/bin/zsh

# Configuration
SESSION_FILE="$HOME/script/session_name"
PROTECTED_SESSIONS=("backend" "frontend" "client" "server")  # Sessions that cannot be deleted
TERMINAL="alacritty"  # Your terminal emulator

# Ensure session file exists
mkdir -p "$(dirname "$SESSION_FILE")"
touch "$SESSION_FILE" || { echo "Error: Cannot create $SESSION_FILE" >&2; exit 1 }

while true; do
  # Load sessions
  all_sessions=(${(f)"$(sort -u "$SESSION_FILE" | grep -v '^$')"})
  running_sessions=(${(f)"$(tmux list-sessions 2>/dev/null | awk -F: '{print $1}')"})

  # Build menu
  menu_items=()
  for session in $all_sessions; do
    if (( $running_sessions[(Ie)$session] )); then
      menu_items+=(" $session (running)")
    else
      menu_items+=("$session")  # No indicator for stopped sessions
    fi
  done
  menu_items+=(" New session" " Kill session" "❌ Exit")

  # Selection
  selected=$(printf "%s\n" "${menu_items[@]}" | fzf --height=40% --reverse --prompt='TMUX session: ') || continue

  # Extract action/session
  selection_type=${selected[(w)2]}  # New/Kill/Exit or session name
  session_name=${selected[(w)2]}

  if [[ "$selection_type" == "Exit" ]]; then
    exit 0

  elif [[ "$selection_type" == "Kill" ]]; then
    # Loop for Kill Session (stay in this menu if any sessions are running)
    while true; do
      running_sessions=(${(f)"$(tmux list-sessions 2>/dev/null | awk -F: '{print $1}')"})

      # Only show running (killable) sessions
      killable_sessions=(${running_sessions:|PROTECTED_SESSIONS})

      if (( ${#killable_sessions[@]} == 0 )); then
        echo "No running sessions available to kill"
        break  # Go back to the main menu
      fi

      # Select session to kill
      to_kill=$(printf "%s\n" "${killable_sessions[@]}" | \
        fzf --height=40% --reverse --prompt='Select session to kill: ')

      [[ -z "$to_kill" ]] && break  # Exit back to main menu if nothing selected

      # Kill session
      tmux kill-session -t "$to_kill" 2>/dev/null && \
      sed -i "/^${to_kill}$/d" "$SESSION_FILE"
      echo "Killed session: $to_kill"

      # Refresh session list
      running_sessions=(${(f)"$(tmux list-sessions 2>/dev/null | awk -F: '{print $1}')"})

      if (( ${#running_sessions[@]} == 0 )); then
        break  # Return to main menu if no sessions are left
      fi

      # Stay in Kill menu if there are still running sessions
    done

  elif [[ "$selection_type" == "New" ]]; then
    # New session creation
    while true; do
      vared -p 'New session name: ' -c new_session
      [[ -z $new_session ]] && continue
      [[ $new_session =~ ^[a-zA-Z0-9_-]+$ ]] || { echo "Only alnum, -, _ allowed"; continue }
      (( ${all_sessions[(Ie)$new_session]} )) && { echo "Exists!"; continue }
      break
    done
    tmux new-session -s "$new_session" ${TMUX:+-d}
    echo "$new_session" >> "$SESSION_FILE"
    [[ -n $TMUX ]] && tmux switch-client -t "$new_session"

  else
    # Regular session attachment
    if tmux has-session -t "$session_name" 2>/dev/null; then
      [[ -n $TMUX ]] && tmux switch-client -t "$session_name" || tmux attach -t "$session_name"
    else
      tmux new-session -s "$session_name" ${TMUX:+-d}
      [[ -n $TMUX ]] && tmux switch-client -t "$session_name"
    fi
  fi
done

