#!/usr/bin/env pwsh


function ManagePythonToolchain {

    param (
        [string]$version = "",
        [bool]$python = $false,
        [bool]$pyenv = $false,
        [string]$pyenv_url = "https://github.com/pyenv-win/pyenv-win",
        [bool]$poetry = $false,
        [bool]$pipx = $false,
        [bool]$global = $false,
        [bool]$favourites = $false,
        [bool]$clean = $true,
        [bool]$llm = $false,
        [string]$workon_home = $($env:WORKON_HOME),
        [string]$pyenv_home = $($env:PYENV_HOME),
        [string]$poetry_home = $($env:POETRY_HOME),
        [string]$global_python_venvs = $($env:GLOBAL_PYTHON_VENVS)
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

    AddToDotenv -path "$env:DOTFILES\.env" -key "WORKON_HOME" -value "$env:WORKON_HOME" -overwrite $false -warn $false
    AddToDotenv -path "$env:DOTFILES\.env" -key "GLOBAL_PYTHON_VENVS" -value "$global_python_venvs" -overwrite $false -warn $false

    # TODO: clean up every PATH, or other remaining clutter.

    if ($pyenv -eq $true) {
        # Install pyenv-win.
        if ($pyenv_home -eq $null) {
            Write-Host "No 'env:PYENV_HOME' set. Using default: 'env:USERPROFILE\.pyenv\pyenv-win\'."
            $pyenv_home = "$env:USERPROFILE\.pyenv\pyenv-win\"
        }
        AddToDotenv -path "$env:DOTFILES\.env" -key "PYENV_HOME" -value "$pyenv_home" -overwrite $false -warn $false

        # Install using scoop.
        # scoop install pyenv-win
        # scoop update pyenv-win

        # Git clone instead, because the scoop package is kinda outdated fast..
        Invoke-Expression "git clone $pyenv_url $env:PYENV_HOME"
        $current_path = $pwd
        Set-Location -Path (Split-Path -Path $env:PYENV_HOME -Parent)
        Invoke-Expression "git checkout -- pyenv-win/.versions_cache.xml"
        Invoke-Expression "git pull"
        Set-Location -Path $current_path

        $installed += "pyenv-win"

        pyenv update

        $updated_pyenv = $true
    }

    # Install target python version or latest.
    if ($python -eq $true) {
        if ($version -eq "") {
            # Get latest python version.
            if ($updated_pyenv -eq $false) {
                pyenv update
            }
            $version = pyenv install --list | Sort-Object {[System.Version]$_} -ErrorAction SilentlyContinue -Descending | Select-Object -First 1
        }
        pyenv install $version
        if ($global -eq $true) {
            pyenv global $version
            AddToDotenv -path "$env:DOTFILES\.env" -key "GLOBAL_PYTHON_VERSION" -value "$version" -overwrite $true -warn $false
            pyenv rehash  # TBD: is this necessary?

            $current_path = $pwd
            Set-Location -Path $env:DOTFILES
            pyenv local $version
            Set-Location -Path $current_path
        }
        $installed += "python $version"
    }

    python -m ensurepip --upgrade
    python -m pip install --upgrade pip --no-warn-script-location

    if ($favourites -eq $true) {
        # Install favourite system packages.
        python -m pip install -r "$env:DOTFILES.\common\python\system-packages.txt"
        $installed += "python-system-packages"
    }

    if ($llm -eq $true) {
        # Install llm.
        python -m pip install llm
        $llm_home = $($env:LLM_USER_PATH)
        if ($llm_home -eq $null) {
            Write-Host "No 'env:LLM_USER_PATH' set. Using default: 'env:DOTFILES\common\llm'."
            $llm_home = "$env:DOTFILES\common\llm"
        }
        # llm plugins
        llm install llm-gpt4all
        llm install llm-mistral
        $env:LLM_USER_PATH = $llm_home

        # Monkeypatch llm cli.py to use default template.
        $llm_cli_path = "$env:PYENV_HOME\versions\$env:GLOBAL_PYTHON_VERSION\Lib\site-packages\llm\cli.py"
        (Get-Content -Path $llm_cli_path) -replace '@click.option\("-t", "--template", help="Template to use"\)', '@click.option("-t", "--template", help="Template to use", default="default")' | Set-Content -Path $llm_cli_path

        # Create if not exists.
        mkdir $llm_home -ErrorAction SilentlyContinue
        AddToDotenv -path "$env:DOTFILES\.env" -key "LLM_USER_PATH" -value $env:LLM_USER_PATH -overwrite $true -warn $false

        # TBD: do the editor settings belong here? Probably not.
        $editor = $($env:EDITOR)
        if ($editor -eq $null) {
            Write-Host "No 'env:EDITOR' set. Using default: 'code -w'."
            $editor = "code -w"
        }
        AddToDotenv -path "$env:DOTFILES\.env" -key "EDITOR" -value $editor -overwrite $true -warn $false

        $installed += "llm"
    }

    if ($poetry -eq $true) {
        # Install poetry.
        if ($poetry_home -eq $null) {
            Write-Host "No 'env:POETRY_HOME' set. Using default: 'env:USERPROFILE\.poetry'."
            $poetry_home = "$env:USERPROFILE\.poetry"
            mkdir $poetry_home -ErrorAction SilentlyContinue
        }
        AddToDotenv -path "$env:DOTFILES\.env" -key "POETRY_HOME" -value "$poetry_home" -overwrite $false -warn $false
        if (![bool](Get-Command -Name 'poetry' -ErrorAction SilentlyContinue)) {
            # Install to the active python interpreter via their offical script.
            (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
        }
        $installed += "poetry"
        poetry self update
        poetry config cache-dir "$poetry_home\cache"
        poetry config virtualenvs.options.always-copy "true"
        poetry config virtualenvs.path "$env:WORKON_HOME"
    }

    if ($pipx -eq $true) {
        # Install pipx.
        python -m pip install --quiet --user -U pipx
        python -m pipx reinstall-all
        $installed += "pipx"
    }

    if ($clean -eq $true) {
        # Clean up.
        python -m pip cache purge
        echo yes | poetry cache clear . --all
        # Pipx cache
        Remove-Item "$env:USERPROFILE\.local\pipx\.cache" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    }

    return $installed
}
