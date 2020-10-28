# custom fish-config-file
function fish_greeting
    echo ''
    echo 'Commander on deck' | lolcat
    fortune | lolcat
    echo ''
end

if grep --quiet microsoft /proc/version
    #--WSL----

    # X-server to Windows
    set wsl_ip (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
    set -U DISPLAY "$wsl_ip":10.0
    # openGL for the X-server 
    set -U LIBGL_ALWAYS_INDIRECT 1
    
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
