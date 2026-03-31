# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------- Powerlevel10k --------------------
source ~/.powerlevel10k/powerlevel10k.zsh-theme

# -------------------- Completion System --------------------
autoload -Uz compinit
# Only regenerate .zcompdump once a day for faster startup
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# -------------------- History --------------------
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000
export HISTFILESIZE=1000000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

# -------------------- Shell Options --------------------
setopt noautomenu
setopt nomenucomplete

# -------------------- Key Bindings --------------------
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# -------------------- Functions --------------------

command_exists () {
    type "$1" &> /dev/null ;
}

# -------------------- Aliases --------------------
alias ls='ls -G '
alias n='open .'
alias k='cd .. && ls'
alias kk='cd ../.. && ls'
alias kkk='cd ../../.. && ls'
alias kkkk='cd ../../../.. && ls'
alias la='ls -la'
alias f="find ./ -name "
alias grep="grep --color=auto"
alias g="grep --color=auto -ri"
alias hg="history | grep -P"
alias ds="cd ~/git/ds"
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias y="yaourt --noconfirm"

# ------------------- Git Aliases -------------------
alias gs="git status "
alias ga="git add "
alias gc="git checkout "
alias gcm="git commit "
alias gp="git pull"
alias gpo='git pull origin $(git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/)'
alias gd="git diff "
alias gg="git grep "
alias gdc="git diff --cached "
alias gla="git log --decorate --graph --all"

# --------------------- Exports ---------------------
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias tf="terraform"

export EDITOR=vim
export PROMPT_DIRTRIM=2
export JHBUILD="/mnt/data/jhbuild"
export LIBGDATA="/mnt/data/jhbuild/checkout/libgdata"
export GVFS="/mnt/data/jhbuild/checkout/gvfs"
export GOPATH="$HOME/go"

export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS=" -R "

# --------------------- Notify Long Running Commands in ZSH on Mac ---------------------
notify () {
	eval "$@"
	result=$?
	ping $result
	cmd_notification $result "$@"
}

ping () {
	result=$1
	if [ "$result" != 0 ]
	then
		sound=/System/Library/Sounds/Basso.aiff
	else
		sound=/System/Library/Sounds/Ping.aiff
	fi
	afplay "$sound" -v 4
}

cmd_notification () {
	if [[ "$#" -lt 2 ]]
	then
		echo "Usage: cmd_notification result command"
		return
	fi
	result=$1
	shift
	cmd=$@
	notify_text="Command completed: "
	if [[ "$result" != 0 ]]
	then
		notify_text+="FAILURE - $result"
	else
		notify_text+=SUCCESS
	fi
	osascript -e "display notification \"$notify_text\" with title \"$cmd\""
}

# --------------------- Plugins & Tools ---------------------
# sledge binary path
if [[ -f "$HOME/.sledge/bin/sledge" ]]; then
    export SLEDGE_BIN="$HOME/.sledge/bin"
    export PATH="${PATH}:${SLEDGE_BIN}"
fi

# sdkman
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# kubectl completion
if command_exists kubectl; then
    echo "Kubectl found, sourcing completion files."
    source <(kubectl completion zsh)
fi

export PATH=$HOME/go/bin:$PATH

function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i

    if [ -z "$1" ]
    then
        kubectl get --ignore-not-found ${i}
    else
        kubectl -n ${1} get --ignore-not-found ${i}
    fi
  done
}

# BEGIN env Setup -- Managed by Ansible DO NOT EDIT.

# Setup INDEED_ENV_DIR earlier.
if [ -z "${INDEED_ENV_DIR}" ]; then
    export INDEED_ENV_DIR="/Users/masharma/env"
fi

# Single-brace syntax because this is required in bash and sh alike
if [ -e "${INDEED_ENV_DIR}/etc/indeedrc" ]; then
    . "${INDEED_ENV_DIR}/etc/indeedrc"
fi
# END env Setup -- Managed by Ansible DO NOT EDIT.

# pipx
export PATH="$PATH:$USER/.local/bin"

# cvm
if [ -f "$HOME/.cvm.sh" ]; then
    source "$HOME/.cvm.sh"
fi

# Added by ToolHive UI - do not modify this block
export PATH="$HOME/.toolhive/bin:$PATH"
# End ToolHive UI

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Silence the "Console output during zsh initialization detected" warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
