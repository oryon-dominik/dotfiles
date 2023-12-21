#!/usr/bin/env fish

# Aliases.

alias ..='cd ..'
alias cd..='cd ..'

alias cls='clear'

alias ls='eza --group-directories-first --git'
alias ll='eza --color-scale --long --header --group-directories-first'
alias la='eza --all --color-scale --long --header --group-directories-first'
alias lt='eza --tree --color-scale --group-directories-first'
alias l='eza --all --color-scale --long --header --git --group-directories-first'

alias ports='netstat -tulpen'

alias poetry="$HOME/.local/bin/poetry"

alias cfg="z $HOME/.dotfiles"
