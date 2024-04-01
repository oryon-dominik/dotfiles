#!/usr/bin/env pwsh

. "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"

# FIXME: no unattended install yet: nvm will not run from a script?!.
function InstallJavaScriptToolchain {

    $installed = @()
    
    Write-Host "Installing Javascript Toolchain... "

    # install nvm - node version manager
    scoop install main/nvm
    scoop update nvm


    $env:NVM_HOME = "$(Join-Path -Path $env:SCOOP -ChildPath 'apps\nvm\current')"
    AddToDotenv -path "$env:DOTFILES\.env" -key "NVM_HOME" -value "$env:NVM_HOME" -overwrite $false -warn $false

    iex "nvm list available"
    # install npm
    iex "nvm install latest"
    $installed += "node"
    iex "nvm use latest"

    # install yarn
    iex "npm install --global yarn"
    $installed += "yarn"

    if (($env:YARN_GLOBAL_HOME -eq $null) -or ($env:YARN_GLOBAL_HOME -eq "")) {
        $env:YARN_GLOBAL_HOME = "$env:USERPROFILE\.yarn"
        AddToDotenv -path "$env:DOTFILES\.env" -key "YARN_GLOBAL_HOME" -value "$env:YARN_GLOBAL_HOME"
    }

    # re-set yarn's global modules path
    iex "yarn config set prefix $env:YARN_GLOBAL_HOME"

    return $installed
}
