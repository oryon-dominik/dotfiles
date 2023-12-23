#!/usr/bin/env pwsh


function InstallModernUnixToolchain {

    $installed = @()

    Write-Host "Installing modern unix cli-commands to powershell..."
    Write-Host "You should have installed scoop, git, the rust toolchain and Golang to sucessfully run this pipeline..."
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

    . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallCargoCrates.ps1")
    $installed += InstallCargoCrates

    # TODO: integrate go packages and npm global packages into this pipeline?
    # go install github.com/cheat/cheat/cmd/cheat@latest
    # npm install gtop -g
    # npm install slidev -g ??

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
