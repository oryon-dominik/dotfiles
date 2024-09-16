# $HOME/.config/fish/config.fish

function fish_greeting
    echo ''
    echo $USER ' on ' $hostname | figlet -f smslant | lolcat
    echo ''
    echo 'Commander on deck' | lolcat
    fortune anarchism | lolcat
    echo ''
end

if grep --quiet microsoft /proc/version
    # WSL
    wsl_config
else
    # Native posix
    :
end

if test -e $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/aliases.fish
end

zoxide init fish | source
mcfly init fish | source
starship init fish | source

# set -U EDITOR vi

echo "Warning, need to install UV for python packaging."
fish_add_path -g /usr/local/bin /usr/local/sbin
fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$HOME/.cargo/bin"
# fish_add_path -g (yarn global bin)


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
