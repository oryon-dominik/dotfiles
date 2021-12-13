#!/usr/bin/env fish

# aliases

alias ..='cd ..'
alias cd..='cd ..'

alias cls='clear'

alias ls='exa --group-directories-first --git-ignore'
alias ll='exa --color-scale --long --header --group-directories-first'
alias la='exa --all --color-scale --long --header --group-directories-first'
alias lt='exa --tree --color-scale --group-directories-first'
alias l='exa --all --color-scale --long --header --git --group-directories-first'

alias ports='netstat -tulpen'

alias poetry="$HOME/.local/bin/poetry"
