#!/usr/bin/env fish
# custom fish-config-file
function fish_greeting
    echo ''
    echo 'Commander on deck' | lolcat
    fortune | lolcat
    echo ''
end

if grep --quiet microsoft /proc/version
    #--WSL----
    wsl_config
else
    # "native linux"
    :
end

set -U EDITOR vi

# setup aliases
if test -e ~/.config/fish/aliases.fish
    . ~/.config/fish/aliases.fish
end


# pipx completions
register-python-argcomplete --shell fish pipx | source

set fish_color_cwd yellow

# ssh-agent
if not pgrep -f ssh-agent > /dev/null
  eval (ssh-agent -c) > /dev/null
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

if status is-interactive
  cd $HOME
end

