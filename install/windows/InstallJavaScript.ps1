#!/usr/bin/env pwsh

. "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"

# FIXME: no unattended install yet: nvm will not run from a script?!.
function InstallJavaScriptToolchain {

    $installed = @()
    
    Write-Host "Installing Javascript Toolchain... "

    # Install nvm - node version manager
    # Newer versions of nvm introduced some bad bugs for automation. Seems it
    # will get deprecated in favor of a tool called 'runtime' soon.
    # https://github.com/coreybutler/nvm-windows/issues/1068
    scoop install main/nvm@1.1.11
    # scoop update nvm

    $env:NVM_HOME = "$(Join-Path -Path $env:SCOOP -ChildPath 'apps\nvm\current')"
    AddToDotenv -path "$env:DOTFILES\.env" -key "NVM_HOME" -value "$env:NVM_HOME" -overwrite $false -warn $false

    iex "nvm list available"
    # install npm
    iex "nvm install latest"
    $installed += "node"
    iex "nvm use latest"

    # install yarn
    if (($env:YARN_GLOBAL_HOME -eq $null) -or ($env:YARN_GLOBAL_HOME -eq "")) {
        $env:YARN_GLOBAL_HOME = "$env:USERPROFILE\.yarn"
        AddToDotenv -path "$env:DOTFILES\.env" -key "YARN_GLOBAL_HOME" -value "$env:YARN_GLOBAL_HOME"
    }

    # re-read all paths.
    . "$env:DOTFILES\common\powershell\Paths.ps1"
    
    # Write-Host "Now install yarn manually:"
    # Write-Host "iex npm install --global yarn"
    iex "npm install --global yarn"
    # re-set yarn's global modules path
    iex "yarn config set prefix $env:YARN_GLOBAL_HOME"
    # Write-Host "iex 'yarn config set prefix $env:YARN_GLOBAL_HOME'"
    $installed += "yarn"
    # Write-Host

    return $installed
}
