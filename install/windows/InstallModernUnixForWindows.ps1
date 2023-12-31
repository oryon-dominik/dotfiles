#!/usr/bin/env pwsh


function InstallModernUnixToolchain {

    $installed = @()

    Write-Host "Installing modern unix cli-commands to powershell..."
    Write-Host "You should have installed scoop, git, the rust toolchain, the JavaScript toolchain and Golang to sucessfully run this pipeline..."
    Write-Host ""

    # Manually install the packages via scoop, that don't compile easily with cargo.
    scoop install main/starship
    $installed += "starship"
    scoop update starship
    scoop install main/gitui
    $installed += "gitui"
    scoop update gitui

    # create the (gitignored) .dotfiles/bin directory if it doesn't exist
    $DOTFILES_BIN = Join-Path -Path $env:DOTFILES -ChildPath 'bin'
    mkdir $DOTFILES_BIN -ErrorAction SilentlyContinue


    $CargoCratesInstallScript = $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallCargoCrates.ps1")
    if (Test-Path $CargoCratesInstallScript) {
        . $CargoCratesInstallScript
    } else {
        Write-Host "Downloading InstallCargoCrates.ps1 to $CargoCratesInstallScript"
        $CargoCratesInstallScript = Invoke-WebRequest https://raw.githubusercontent.com/oryon-dominik/dotfiles/trunk/install/windows/InstallCargoCrates.ps1
        Invoke-Expression $($CargoCratesInstallScript.Content)
    }

    $installed += InstallCargoCrates

    # Explicitly add mcfly directory to path for a consistent history across shells.
    $mcfly_home = $($env:MCFLY_HOME)
    if ($mcfly_home -eq $null) {
        $mcfly_home = "$(Join-Path -Path $env:USERPROFILE -ChildPath '.mcfly')"
        Write-Host "No 'env:MCFLY_HOME' path given. Using default: '$mcfly_home'."
        AddToDotenv -path "$env:DOTFILES\.env" -key "MCFLY_HOME" -value "$mcfly_home" -overwrite $false -warn $false
    }
    mkdir $mcfly_home -ErrorAction SilentlyContinue

    # [*nix*-style inspired cli cheatsheets](https://github.com/cheat/cheat)
    go install github.com/cheat/cheat/cmd/cheat@latest
    $installed += "cheat"

    # [gtop - graphical system monitoring dashboard](https://github.com/aksakalli/gtop)
    yarn global add gtop
    $installed += "gtop"

    # [slidev - Presentation Slides for Developers](https://github.com/slidevjs/slidev)
    yarn global add @slidev/cli
    $installed += "slidev"

    Write-Host ""
    Write-Host "Pick the latest windows executable for these additional packages from github."
    Write-Host "Save them to $DOTFILES_BIN."
    Write-Host ""
    Write-Host "dog - dns lookup"
    Write-Host "https://github.com/ogham/dog/releases"
    Write-Host ""
    Write-Host "jq - Command-line JSON processor"
    Write-Host "https://github.com/stedolan/jq/releases"
    Write-Host ""
    Write-Host "curlie - The power of curl, the ease of use of httpie."
    Write-Host "https://github.com/rs/curlie/releases"

    return $installed
}
