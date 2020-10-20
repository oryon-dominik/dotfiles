function fish_prompt
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end

    if test -z (sudo -nv 2>&1)
        set admin_color purple
    else
        set admin_color blue
    end

    set_color $admin_color
    echo -n "fish "

    set_color white
    echo -n (whoami)
    set_color red
    echo -n "@"
    set_color white
    echo -n $hostname

    set_color blue
    echo -n " ["
    set_color white
    echo -n (date +"%T")
    set_color blue
    echo -n "] "
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color $admin_color
    echo -n " > "
    set_color normal

    set -l func fish_prompt
                eval 'echo -n $__async_prompt_'$func'_text'
end
