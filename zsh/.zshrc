#export
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ---- Editor ----
export EDITOR=nvim
export VISUAL=nvim

export PATH=$PATH:/usr/local/node/bin
export PATH="$HOME/.local/bin:$PATH"

# User configuration

export MANPATH="/usr/local/man:$MANPATH"
export PATH="$HOME/.local/bin/zen:$PATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch NO_HIST_EXPAND

autoload -Uz colors && colors
PS1="%{$fg[green]%}[%n@%m %~] %{$reset_color%}"
# PS1="%{$fg_bold[yellow]%}[%n@%m %~] %{$reset_color%}"

# alternative nvim config
alias a="NVIM_APPNAME=my-nvim nvim"
alias l=ll
# Aliases
# alias vim='nvim'
alias vi='nvim'
alias ..='cd ..'
alias so='source /home/dinesh/.zshrc'
# alias tls='tmux ls'
alias la='ls -a'
alias ll='ls -la'
alias e='exit'
alias home='cd ~'
alias c='cd'
alias cl='clear'
alias h='home'
alias gs='git status'
alias ga='git add .'
alias gj='git commit'
alias dps='sudo docker ps -a'
alias dim='sudo docker images'
# alias s='$HOME/script/pick_session.sh'
# alias s='$HOME/script/python.py'
alias todo='$HOME/script/todo'
alias tmux-sessionizer='/home/dinesh/script/tmux_sessionaizer.sh'

run() {
    g++ "$1" -o a.out && ./a.out
}
# for emacs
export XDG_CONFIG_HOME="$HOME/.config"

# vim keybinding
bindkey -v

# bindkey -s ^f "/home/void/script/tmux_sessionaizer.sh\n"
# bindkey -s ^b "/home/void/script/python.py\n"
# bindkey -s ^b "/home/void/script/rofi-web-serach.sh\n"


# tmux
tmux() {
  # if no arguments: behave normally
  if [ $# -eq 0 ]; then
    command tmux
    return
  fi

  # if the first argument matches a tmux subcommand, pass through directly
  case "$1" in
    attach|a|ls|list-*|new|kill-*|switch-*|rename-*|display-*|source-*|save-*|show-*|start-*|set-*|detach|has-*|run-*)
      command tmux "$@"
      return
      ;;
  esac

  # otherwise, treat argument as a session name
  session="$1"
  if command tmux has-session -t "$session" 2>/dev/null; then
    command tmux attach -t "$session"
  else
    command tmux new -s "$session"
  fi
}

# Pick and attach to a tmux session
tmux-pick() {
  # List sessions and let user pick with fzf
  session=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --prompt="tmux session> " --height=40% --reverse)
  if [ -n "$session" ]; then
    tmux attach -t "$session"
  else
    echo "No session selected."
  fi
}

export PATH="$HOME/dotfiles/bin:$PATH"
export PATH="$PATH:$HOME/mob_dev/flutter/bin"
export PATH="$PATH:$HOME/mob_dev/flutter/bin/cache/dart-sdk/bin"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
