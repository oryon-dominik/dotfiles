#!/usr/bin/env pwsh

Import-Module "$PSScriptRoot\components\DotEnvs.ps1"


function InstallJavaScriptToolchain {

    $installed = @()
    
    Write-Host "Installing Javascript Toolchain... "

    # install nvm - node version manager
    scoop install main/nvm
    scoop update nvm

    $env:NVM_HOME = "$(Join-Path -Path $env:SCOOP -ChildPath 'apps\nvm\current')"
    AddToDotenv -path "$env:DOTFILES\.env" -key "NVM_HOME" -value "$env:NVM_HOME" -overwrite $false -warn $false

    nvm list available
    # install npm
    nvm install latest
    $installed += "node"
    nvm use latest

    # install yarn
    npm install --global yarn
    $installed += "yarn"

    if ($env:YARN_GLOBAL_HOME -eq $null) {
        $env:YARN_GLOBAL_HOME = "$env:USERPROFILE\.yarn"
        AddToDotenv -path "$env:DOTFILES\.env" -key "YARN_GLOBAL_HOME" -value "$env:YARN_GLOBAL_HOME"
    }

    # re-set yarn's global modules path
    yarn config set prefix $env:YARN_GLOBAL_HOME

    return $installed
}
