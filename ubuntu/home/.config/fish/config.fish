# custom fish-config-file
function fish_greeting
    echo ''
    echo 'Commander on deck' | lolcat
    fortune | lolcat
    echo ''
end

set -U EDITOR vi

# windows-alises - i'm too used to them ;-]
alias cls="clear"
alias cd..="cd .."

# custom fish-function
alias !!!="last_command_as_sudo"

set fish_color_cwd yellow
