# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Silence the "Console output during zsh initialization detected" warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

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
#alias pac="pacman -S"
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
alias gpo="git pull origin $(git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/)"
alias gd="git diff "
alias gg="git grep "
alias gdc="git diff --cached "
alias gla="git log --decorate --graph"
alias gla="git log --decorate --graph --all"

# --------------------- Exports ---------------------
#
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias tf="terraform"
SAVEHIST=10000000
HISTFILE=~/.zsh_history

export HISTFILESIZE=1000000
export HISTSIZE=10000000
export EDITOR=vim

# Set the depth to which PS1 shows the relative path
export PROMPT_DIRTRIM=2
export JHBUILD="/mnt/data/jhbuild"
export LIBGDATA="/mnt/data/jhbuild/checkout/libgdata"
export GVFS="/mnt/data/jhbuild/checkout/gvfs"
export GOPATH="$HOME/go"

export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS=" -R "

# NVM related setup

# --------------------- Plugins Config ---------------------
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

setopt noautomenu
setopt nomenucomplete
#sledge:binary path
if [ -d "${SLEDGE_BIN}" ]; then
    export SLEDGE_BIN=/Users/m0s04cr/.sledge/bin
    export PATH="${PATH}:${SLEDGE_BIN}"
fi

# sdkman related sources for configuring right java class paths
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if command_exists kubectl; then
    echo "Kubectl found, sourcing completion files."
    source <(kubectl completion zsh)
fi

if [[ -f "$HOME/.sledge/bin/sledge" ]]; then
      export SLEDGE_BIN="$HOME/.sledge/bin"
      export PATH="${PATH}:${SLEDGE_BIN}"
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
