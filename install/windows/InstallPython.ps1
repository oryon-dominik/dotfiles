#!/usr/bin/env pwsh


function ManagePythonToolchain {

    param (
        [string]$version = "",
        [bool]$python = $false,
        [bool]$pyenv = $false,
        [string]$pyenv_url = "https://github.com/pyenv-win/pyenv-win",
        [bool]$poetry = $false,
        [bool]$global = $false,
        [bool]$favourites = $false,
        [bool]$clean = $true,
        [string]$workon_home = $($env:WORKON_HOME),
        [string]$global_python_venvs = $($env:GLOBAL_PYTHON_VENVS),
    )

    Write-Host "Installing Python Toolchain... https://python.org/"

    $installed = @()
    $updated_pyenv = $false

    if ($workon_home -eq $null) {
        if ($global_python_venvs -eq $null) {
            Write-Host "No 'env:GLOBAL_PYTHON_VENVS' path given. Using default: 'venvs'."
            $global_python_venvs = "venvs"
        }
        $env:WORKON_HOME = "$env:USERPROFILE\$global_python_venvs"
        Write-Host "No workon home path given. env:WORKON_HOME is not set. Using default $env:WORKON_HOME."
        [Environment]::SetEnvironmentVariable("WORKON_HOME", "$env:USERPROFILE\venvs", [System.EnvironmentVariableTarget]::Session)
    }

    # TODO: write $env:WORKON_HOME and $env:GLOBAL_PYTHON_VENVS to the dotfiles .env file if any is not present.

    # TODO: clean up every PATH, or other remaining clutter.

    if ($pyenv -eq $true) {
        # Install pyenv-win.
        # TBD: git clone, because the scoop package is kinda outdated fast..
        # TODO: PYENV_HOME should be cloned (and the env set to) $env:USERPROFILE\.pyenv\pyenv-win\ by default and set to .env file. if not found.

        # Install using scoop.
        scoop install pyenv-win
        $installed += "pyenv-win"
        scoop update pyenv-win

        # git clone $pyenv_url $env:PYENV_HOME
        # TODO: git cleanup / reset / pull and update
        pyenv update
        $updated_pyenv = $true
        # TODO: delete pyenv cache
    }

    # Install target python version or latest.
    if ($python -eq $true) {
        if ($version -eq "") {
            # Get latest python version.
            if ($updated_pyenv -eq $false) {
                pyenv update
            }
            $python = pyenv install --list | Sort-Object {[System.Version]$_} -ErrorAction SilentlyContinue -Descending | Select-Object -First 1
        }
        pyenv install $latest
        if ($global -eq $true) {
            pyenv global $latest
            # TODO: also set GLOBAL_PYTHON_VERSION in .env file.
            pyenv rehash  # TBD: is this necessary?
        }
        $installed += "python $latest"
    }

    python -m pip install --upgrade pip
    

    if ($favourites -eq $true) {
        # Install favourite system packages.
        python -m pip install -r "$env_DOTFILES.\common\python\system-packages.txt"
        $installed += "python-system-packages"
    }

    if ($poetry -eq $true) {
        # Install poetry.
        # TODO: POETRY_HOME should be set to $env:USERPROFILE\.poetry by default and set to .env file. if not found.
        # Install to the active python interpreter via their offical script.
        (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
        $installed += "poetry"
    }

    if ($clean -eq $true) {
        # Clean up.
        python -m pip cache purge
        # TODO: delete pyenv cache
        # TODO: delete unused pyenv versions
        # TODO: delete poetry cache
    }

    return $installed
}
