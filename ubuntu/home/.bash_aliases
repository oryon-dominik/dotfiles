alias cls='clear'
alias cd..='cd ..'
alias ..='cd ..'

alias cfg="cd ~/.dotfiles"

if [ -f ~/.project_aliases ]; then
    alias aliases="code ~/.project_aliases"
    . ~/.project_aliases
fi
