#!/usr/bin/env pwsh


. "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"


function InstallLatestPython {
    ManagePythonToolchain -python $true -uv $true -global $true -favourites $true -clean $true
}


function ManagePythonToolchain {

    param (
        [string]$version = "",
        [bool]$python = $false,
        [bool]$uv = $false,
        [bool]$global = $false,
        [bool]$favourites = $false,
        [bool]$clean = $true,
        [bool]$llm = $false,
        [string]$workon_home = "$($env:WORKON_HOME)",
        [string]$global_python_venvs = "$($env:GLOBAL_PYTHON_VENVS)"
    )

    Write-Host "Installing Python Toolchain... https://python.org/"

    $installed = @()

    if (($global_python_venvs -eq $null) -or ($global_python_venvs -eq "")) {
        Write-Host "No 'env:GLOBAL_PYTHON_VENVS' path given. Using default: 'venvs'."
        $global_python_venvs = "venvs"
    }

    if (($workon_home -eq $null) -or ($workon_home -eq "")) {
        $env:WORKON_HOME = "$env:USERPROFILE\$global_python_venvs"
        Write-Host "No workon home path given. env:WORKON_HOME is not set. Using default $env:WORKON_HOME."
        [Environment]::SetEnvironmentVariable("WORKON_HOME", $env:WORKON_HOME, [System.EnvironmentVariableTarget]::Session)
    }

    AddToDotenv -path "$env:DOTFILES\.env" -key "WORKON_HOME" -value "$env:WORKON_HOME" -overwrite $false -warn $false
    AddToDotenv -path "$env:DOTFILES\.env" -key "GLOBAL_PYTHON_VENVS" -value "$global_python_venvs" -overwrite $false -warn $false

    # Clean up PATH.
    # Remove WindowsApps from PATH. It will overshadow other python installations otherwise.
    $winAppsPath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"
    $path = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
    # Clean unwanted elements
    $path = ($path.Split(';') | Where-Object { $_ -ne "$winAppsPath" }) -join ';'
    # Set modified PATH.
    [System.Environment]::SetEnvironmentVariable('PATH', $path, 'User')

    if ($uv -eq $true) {
        # Install [uv](https://github.com/astral-sh/uv).
        irm https://astral.sh/uv/install.ps1 | iex

        AddToDotenv -path "$env:DOTFILES\.env" -key "UV_CONFIG_FILE" -value "$env:USERPROFILE\.config\uv.toml" -overwrite $false -warn $false
        AddToDotenv -path "$env:DOTFILES\.env" -key "UV_PYTHON_INSTALL_DIR" -value "$env:USERPROFILE\uv\python" -overwrite $false -warn $false
        AddToDotenv -path "$env:DOTFILES\.env" -key "UV_CACHE_DIR" -value "$env:USERPROFILE\uv\cache" -overwrite $false -warn $false

        $installed += "uv"
    }


    # Install target python version or latest.
    if ($python -eq $true) {
        if ($version -eq "") {
            # Get latest python version.
            $version = uv python list | ForEach-Object { ($_ -split '[-]') | Select-Object -First 1 -Skip 1} | Sort-Object {[System.Version]$_} -ErrorAction SilentlyContinue -Descending | Select-Object -First 1
        }
        uv python install $version
        if ($global -eq $true) {
            AddToDotenv -path "$env:DOTFILES\.env" -key "GLOBAL_PYTHON_VERSION" -value "$version" -overwrite $true -warn $false
            $current_path = $pwd
            Set-Location -Path $env:DOTFILES
            # echo $version > .python-version
            uv python pin $version
            Set-Location -Path $current_path
        }
        $installed += "python $version"
    }

    # re-read all paths.
    . "$env:DOTFILES\common\powershell\Paths.ps1"

    python -m pip install --upgrade pip --no-warn-script-location --break-system-packages

    if ($favourites -eq $true) {
        # Install favourite system packages.
        python -m pip install -r "$env:DOTFILES.\common\python\system-packages.txt" --break-system-packages
        $installed += "python-system-packages"
    }

    if ($llm -eq $true) {
        # Install llm.
        python -m pip install llm
        $llm_home = "$($env:LLM_USER_PATH)"
        if (($llm_home -eq $null) -or ($llm_home -eq "")) {
            Write-Host "No 'env:LLM_USER_PATH' set. Using default: 'env:DOTFILES\common\llm'."
            $llm_home = "$env:DOTFILES\common\llm"
        }
        # llm plugins
        # llm install llm-gpt4all
        # llm install llm-mistral
        $env:LLM_USER_PATH = $llm_home

        # Monkeypatch llm cli.py to use default template.
        $llm_cli_path = "$env:UV_PYTHON_INSTALL_DIR\cpython-$env:GLOBAL_PYTHON_VERSION-windows-x86_64-none\Lib\site-packages\llm\cli.py"
        (Get-Content -Path $llm_cli_path) -replace '@click.option\("-t", "--template", help="Template to use"\)', '@click.option("-t", "--template", help="Template to use", default="default")' | Set-Content -Path $llm_cli_path

        # Create if not exists.
        mkdir $llm_home -ErrorAction SilentlyContinue
        AddToDotenv -path "$env:DOTFILES\.env" -key "LLM_USER_PATH" -value $env:LLM_USER_PATH -overwrite $true -warn $false

        $installed += "llm"
    }

    if ($clean -eq $true) {
        # Clean up.
        python -m pip cache purge
        uv cache clean
    }

    return $installed
}
