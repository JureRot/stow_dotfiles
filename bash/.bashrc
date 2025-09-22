#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# some more aliases
alias la='ls -la'
alias mv='mv -i'
alias rm='rm -i'

# neumnoteles home server ssh alias
alias nths='ssh -i "~/.ssh/id_ed25519" nt@192.168.1.7'
