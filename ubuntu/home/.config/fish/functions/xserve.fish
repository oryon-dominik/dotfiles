function xserve
    if test -z $argv
        echo "No programm to run via xserver provided"
    else
        DISPLAY=$DISPLAY $argv &
    end
end
