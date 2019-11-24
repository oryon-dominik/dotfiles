# git-bash
source ~/.git-prompt.sh
# export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true
# export GIT_PS1_SHOWDIRTYSTATE=true
# export GIT_PS1_SHOWUPSTRAM='verbose'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
	PS1="${debian_chroot:+($debian_chroot)}\[\033[35m\]xubuntu \[\033[01;37m\]\u\[\033[31m\]@\[\033[37m\]\h \[\033[34m\][\[\033[37m\]\t\[\033[34m\]] \[\033[01;33m\]\w \[\033[37m\]$(__git_ps1 '\[\033[34m\][\[\033[37m\]%s\[\033[34m\]]') \[\033[35m\]> \[\033[37m\]"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias cd..='cd ..'
alias ..='cd ..'
alias cls="clear"

# Virtualenvwrapper
export WORKON_HOME=~/.Envs 
source /usr/local/bin/virtualenvwrapper.sh


# x-server
export DISPLAY=pythia:0.0
export LIBGL_ALWAYS_INDIRECT=1

# docker
export DOCKER_HOST=tcp://localhost:2375

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# run oryons custom-scripts
. ~/bin/scripts.sh
