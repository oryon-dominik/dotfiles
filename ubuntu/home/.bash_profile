if grep --quiet microsoft /proc/version; then
    #--WSL----
    # X-server to Windows
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):10.0
    # openGL for the X-server 
    export LIBGL_ALWAYS_INDIRECT=1
else
    # "native linux"
    :
fi

# Virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
export PYTHON_PATH=$(realpath $(which python))
export VIRTUALENVWRAPPER_SCRIPT="$(dirname $PYTHON_PATH)/virtualenvwrapper.sh"
export VIRTUALENVWRAPPER_LAZY_SCRIPT="$(dirname $PYTHON_PATH)/virtualenvwrapper_lazy.sh"
source $VIRTUALENVWRAPPER_LAZY_SCRIPT

# pyenv, poetry & pipx
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$HOME/.poetry/bin:`yarn global bin`:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
eval "$(register-python-argcomplete pipx)"
source $(pyenv root)/completions/pyenv.bash
