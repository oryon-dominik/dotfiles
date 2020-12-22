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

# windows-alises - i'm too used to them ;-]
alias cls="clear"
alias cd..="cd .."

# custom fish-function
alias !!!="last_command_as_sudo"

# pipx completions
register-python-argcomplete --shell fish pipx | source

set fish_color_cwd yellow

if status is-interactive
  cd $HOME
end
