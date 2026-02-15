#freshly new zshrc for void
#export
# export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/node/bin
# export PATH="/usr/local/bin/zen:$PATH"
export ZSH="$HOME/.oh-my-zsh"

export PATH="$HOME/flutter/bin:$PATH"
export PATH="/opt/zig-x86_64-linux-0.15.2:$PATH"
# export PATH="/opt/zig-x86_64-linux-0.16.0-dev.1484+d0ba6642b:$PATH"
export ANDROID_SDK_ROOT=$HOME/Android
export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH

# run emulator
alias emu='$ANDROID_SDK_ROOT/emulator/emulator -avd my_emulator1 -gpu host -no-snapshot'

# for flutter emulator
export ANDROID_SDK_ROOT=$HOME/Android
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

export PATH="$HOME/.local/bin:$PATH"

ZSH_THEME="robbyrussell"
# alias php='/usr/bin/php8.3'


# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )


plugins=(git)

source $ZSH/oh-my-zsh.sh

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

export ARCHFLAGS="-arch $(uname -m)"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/void/.zshrc'

# autoload -Uz compinit
compinit


autoload -Uz colors && colors
PS1="%{$fg[green]%}[%n@%m %~] %{$reset_color%}"
# PS1="%{$fg_bold[yellow]%}[%n@%m %~] %{$reset_color%}"

export PATH="/opt/zig:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nvim'

# alternative nvim config
alias a="NVIM_APPNAME=my-nvim nvim"
alias l=ll

# for python tmp
# export TMPDIR=~/project/flask-ai/tmp
# export MANPATH="/usr/local/man:$MANPATH"

# ZSH_THEME="robbyrussell"
# ZSH_THEME="bira" # this is good

# PROMPT='[%n] %~ '

plugins=(git)
# source $ZSH/oh-my-zsh.sh

# Aliases
# alias vim='nvim'
alias vi='nvim'
alias ..='cd ..'
alias so='source /home/void/.zshrc'
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
alias tmux-sessionizer='/home/void/script/tmux_sessionaizer.sh'

run() {
    g++ "$1" -o a.out && ./a.out
}
# for emacs
export XDG_CONFIG_HOME="$HOME/.config"
export EMACSDIR="$HOME/.config/emacs"

# vim keybinding
bindkey -v

# bindkey -s ^f "/home/void/script/tmux_sessionaizer.sh\n"
# bindkey -s ^b "/home/void/script/python.py\n"
# bindkey -s ^b "/home/void/script/rofi-web-serach.sh\n"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . "/home/void/.deno/env"

# bun completions
[ -s "/home/void/.bun/_bun" ] && source "/home/void/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#dotnet
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$PATH

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

setopt NO_HIST_EXPAND
export PATH="$HOME/dotfiles/bin:$PATH"
