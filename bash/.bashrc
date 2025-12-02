#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# add git-prompt script
source ~/scripts/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCONFLICTSTATE="yes"
export GIT_PS1_SHOWCOLORHINTS=1

#PS1='[\u@\h \W]\$ '
PS1='[\u@\h \W]$(__git_ps1 "(%s) ")\$ '

# some more aliases
alias la='ls -lA'
alias mv='mv -i'
alias rm='rm -i'

# neumnoteles home server ssh alias
#alias nths='ssh -i "~/.ssh/id_ed25519" nt@192.168.1.7'

# latest advent of code
alias aoc='cd $HOME/Documents/git/adventofcode/2025/'
