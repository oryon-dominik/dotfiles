function wsl_config
    # X-server to Windows
    set wsl_ip (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
    set -U DISPLAY "$wsl_ip":0
    # openGL for the X-server
    set -U LIBGL_ALWAYS_INDIRECT 1
    # remove windows pyenv and poetry from path
    set -U PATH '(echo "$PATH" | sd "/mnt/c/Users/oryon/.poetry/bin" "")'
    set -U PATH '(echo "$PATH" | sd ":/mnt/c/Users/oryon/.pyenv/pyenv-win/bin" "")'
    set -U PATH '(echo "$PATH" | sd ":/mnt/c/Users/oryon/.pyenv/pyenv-win/shims" "")'
    set -U PATH '(echo "$PATH" | sd ":/mnt/c/Users/oryon/AppData/Roaming/Python/Python39/Scripts/" "")'
    set -U PATH '(echo "$PATH" | sd ":/mnt/c/Program Files/Git/cmd/git.exe/$" "")'
end
