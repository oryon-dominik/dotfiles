#!/usr/bin/env pwsh


function SymlinkGitConfigFromDotfiles {

    $gitconfigPath = "$env:USERPROFILE/.gitconfig"
    if (Test-Path $gitconfigPath) {
        # backup old gitconfig
        Write-Host "Backing up old gitconfig to $gitconfigPath.bak"
        Copy-Item -Path $gitconfigPath -Destination "$gitconfigPath.bak"
    } 

    # Delete the old gitconfig and symlink the dotfiles one.
    rm $gitconfigPath
    New-Item -Path $gitconfigPath -ItemType SymbolicLink -Value "$env:DOTFILES/common/git/.gitconfig"

    . "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"
    AddToDotenv -path "$env:DOTFILES\.env" -key "GIT_CONFIG_SYSTEM" -value "$env:USERPROFILE\.gitconfig" -overwrite $false -warn $false

}


function SetupLocalGitconfig {

    param (
        [string]$email = $null,
        [string]$name = $null
    )

    if ($email -eq $null) {
        $email = Read-Host "GIT: Enter your email address:"
    }
    if ($name -eq $null) {
        $name = Read-Host "GIT: Enter your name:"
    }
    $localGitconfigPath = "$env:USERPROFILE/.gitconfig.local"
    if (Test-Path $localGitconfigPath) {
        Write-Host "Local gitconfig already exists at $localGitconfigPath"
    } else {
        Write-Host "Creating local gitconfig at $localGitconfigPath"
        New-Item -Path $localGitconfigPath -ItemType File
    }

    $localGitconfig = Get-Content $localGitconfigPath
    $localGitconfig += @"[user]
    email = $email
    name = $name
"@
}


function SetupGit {

    param (
        [string]$email = $null,
        [string]$name = $null
    )

    SymlinkGitConfigFromDotfiles

    # Also setup the local gitconfig
    SetupLocalGitconfig -email $email -name $name

}
