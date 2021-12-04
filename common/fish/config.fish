# ~/.config/fish/config.fish

function fish_greeting
    echo ''
    echo 'Commander on deck' | lolcat
    fortune /etc/nixos/anarchy | lolcat
    echo ''
end

source aliases.fish

zoxide init fish | source
mcfly init fish | source
starship init fish | source

# pyenv
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

# pipx completions, only run once after a fresh pipx install..
# register-python-argcomplete --shell fish pipx | source

set fish_color_cwd yellow

# # ssh-agent
# if not pgrep --full ssh-agent | string collect > /dev/null
#   eval (ssh-agent -c) > /dev/null
#   set -Ux SSH_AGENT_PID $SSH_AGENT_PID
#   set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
# end

# if status is-interactive
#   cd $HOME
# end
