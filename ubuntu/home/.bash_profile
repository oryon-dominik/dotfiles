
# Virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
export PYTHON_PATH=$(realpath $(which python))

if grep --quiet microsoft /proc/version; then
    #--WSL----
    # X-server to Windows
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):10.0
    # openGL for the X-server 
    export LIBGL_ALWAYS_INDIRECT=1
    # remove pyenv and poetry from the windows paths
    export PATH=$(echo "$PATH" | sed -e 's|:/mnt/c/Users/oryon/.poetry/bin$||g')
    export PATH=$(echo "$PATH" | sed -e 's|:/mnt/c/Users/oryon/.pyenv/pyenv-win/bin$||g')
    export PATH=$(echo "$PATH" | sed -e 's|:/mnt/c/Users/oryon/.pyenv/pyenv-win/shims$||g')
    export PATH=$(echo "$PATH" | sed -e 's|:/mnt/c/Users/oryon/AppData/Roaming/Python/Python39/Scripts/$||g')

    # export VIRTUALENVWRAPPER_SCRIPT="$HOME/.local/lib/python3.9/site-packages/virtualenvwrapper.sh"
    # export VIRTUALENVWRAPPER_LAZY_SCRIPT="$HOME/.local/lib/python3.9/site-packages/virtualenvwrapper_lazy.sh"
else
    # "native linux"
    # export VIRTUALENVWRAPPER_SCRIPT="$(dirname $PYTHON_PATH)/virtualenvwrapper.sh"
    # export VIRTUALENVWRAPPER_LAZY_SCRIPT="$(dirname $PYTHON_PATH)/virtualenvwrapper_lazy.sh"
fi

# source $VIRTUALENVWRAPPER_LAZY_SCRIPT


# pyenv, poetry & pipx
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$HOME/.poetry/bin:`yarn global bin`:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
eval "$(register-python-argcomplete pipx)"
source $(pyenv root)/completions/pyenv.bash
