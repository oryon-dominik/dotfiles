#!/usr/bin/env fish

alias cfg="cd ~/.dotfiles"

alias ..='cd ..'
# windows-alises - i'm too used to them ;-]
alias cls='clear'
alias cd..='cd ..'

alias l='ls'

# modern unix aliases
alias grep='rg'
alias cat='bat'
alias df='duf'
alias sed='sd'
alias ping='gping'
alias ls='exa'
alias find='fdfind'
alias diff='delta'
alias ps='procs'

# run project specific aliases too
if test -e ~/.project_aliases
    alias aliases="code ~/.project_aliases"
    . ~/.project_aliases
end
