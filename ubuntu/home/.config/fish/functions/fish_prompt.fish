function fish_prompt
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end

    if test -z (sudo -nv 2>&1)
        set bracket_color purple
        set reversed_bracket_color blue
    else
        set bracket_color blue
        set reversed_bracket_color purple
    end

    set_color $bracket_color
    echo -n "┌["
    set_color white
    echo -n (whoami)
    set_color red
    echo -n "@"
    set_color white
    echo -n $hostname
    set_color $bracket_color
    echo -n "] "

    echo -n "["
    set_color white
    echo -n "fish"
    set_color $bracket_color
    echo -n "] "

    set_color $bracket_color
    echo -n "["
    set_color white
    echo -n (date +"%T")
    set_color $bracket_color
    echo -n "] "
    echo -n (fish_git_prompt)
    echo ""

    set_color $bracket_color
    echo -n "└["
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color $bracket_color
    echo -n "]"
    set_color $reversed_bracket_color
    echo -n "> "
    set_color normal

    set -l func fish_prompt
    eval 'echo -n $__async_prompt_'$func'_text'
end
