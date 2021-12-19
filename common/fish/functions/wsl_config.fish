function wsl_config
  # X-server to Windows
  set wsl_ip (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
  set -U DISPLAY "$wsl_ip":0
  # openGL for the X-server
  set -U LIBGL_ALWAYS_INDIRECT 1
  # TODO: add 'git' 'pyenv' and 'poetry' to the beginning of path to avoid name mangling
  # TODO: remove the sed replacements..
  # set -U PATH '(echo "$PATH" | sed -e "s|:/mnt/c/Users/$USER/.pyenv/pyenv-win/bin$||g")'
  # set -U PATH '(echo "$PATH" | sed -e "s|:/mnt/c/Users/$USER/.pyenv/pyenv-win/shims$||g")'
  # set -U PATH '(echo "$PATH" | sed -e "s|:/mnt/c/Users/$USER/AppData/Roaming/Python/Python310/Scripts/$||g")'
  # set -U PATH '(echo "$PATH" | sed -e "s|:/mnt/c/Program Files/Git/cmd/git.exe/$||g")'
end
