#!/usr/bin/env fish

alias cfg="cd ~/.dotfiles"

alias ..='cd ..'
# windows-alises - i'm too used to them ;-]
alias cls='clear'
alias cd..='cd ..'

# run project specific aliases too
if test -e ~/.project_aliases
    alias aliases="code ~/.project_aliases"
    . ~/.project_aliases
end
