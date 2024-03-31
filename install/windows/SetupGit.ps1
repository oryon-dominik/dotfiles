#!/usr/bin/env pwsh


Import-Module "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"


function SymlinkGitConfigFromDotfiles {

    $gitconfigPath = "$env:USERPROFILE/.gitconfig"
    if (Test-Path $gitconfigPath) {
        # backup old gitconfig
        Write-Host "Backing up old gitconfig to $gitconfigPath.bak"
        Copy-Item -Path $gitconfigPath -Destination "$gitconfigPath.bak"
    } 

    # Delete the old gitconfig and symlink the dotfiles one.
    try {
        rm $gitconfigPath
    } catch {
        Write-Output "Failed to remove old gitconfig. Maybe it doesn't exist yet. Continuing.."
    }

    New-Item -Path $gitconfigPath -ItemType SymbolicLink -Value "$env:DOTFILES/common/git/.gitconfig"

    $gitconfigIncludesPath = "$env:USERPROFILE/.gitconfig.includes"
    if (Test-Path $gitconfigIncludesPath) {
        # backup old gitconfig
        Write-Host "Backing up old gitconfig.includes to $gitconfigIncludesPath.bak"
        Copy-Item -Path $gitconfigIncludesPath -Destination "$gitconfigIncludesPath.bak"
    } 

    try {
        rm $gitconfigIncludesPath
    } catch {
        Write-Output "Failed to remove old gitconfig.inlcudes. Maybe it doesn't exist yet. Continuing.."
    }

    New-Item -Path $gitconfigIncludesPath -ItemType SymbolicLink -Value "$env:DOTFILES/common/git/.gitconfig.includes"


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
    $localGitconfigPath = "$env:USERPROFILE/.gitconfig.user"
    if (Test-Path $localGitconfigPath) {
        Write-Host "Local gitconfig already exists at $localGitconfigPath"
    } else {
        Write-Host "Creating local gitconfig at $localGitconfigPath"
        New-Item -Path $localGitconfigPath -ItemType File
    }

    $localSafeDirectoriesGitconfigPath = "$env:USERPROFILE/.gitconfig.safe"
    if (Test-Path $localSafeDirectoriesGitconfigPath) {
        Write-Host "Local gitconfig for safe directories already exists at $localSafeDirectoriesGitconfigPath"
    } else {
        Write-Host "Creating local gitconfig for safe directories at $localSafeDirectoriesGitconfigPath"
        New-Item -Path $localSafeDirectoriesGitconfigPath -ItemType File
    }


    $localGitconfig = Get-Content $localGitconfigPath
    $localGitconfig += @"
[user]
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
