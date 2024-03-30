#!/usr/bin/env pwsh

$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = [bool]$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if ($isAdmin -eq $false) {
    Write-Host "This script requires administrative rights to run. Please run it as an administrator."
    return
}

# Setup git, removes old gitconfig, replaces with symlink from dotfiles and
# adds a local (non-version-controlled) gitconfig for your user
# TODO: this is non-admin, it just requires privileges to create the symlink
. "$env:DOTFILES/install/windows/SetupGit.ps1"
SetupGit -email $null -name $null

# Delete old powershell profiles and symlink the one from the dotfiles.
. "$env:DOTFILES/install/windows/SymlinkPowershell.ps1"
SymlinkPowershell

. "$env:DOTFILES/install/windows/SymlinkDotfiles.ps1"
SymlinkDotfiles

# Setup ssh
# . "$env:DOTFILES/install/windows/SetupOpenSSH.ps1"
# SetupSSH


Write-Host "Done :)"
Write-Host ""
Write-Host "Now leave your privilege and install all neccessary software as the common user."
Write-Host '->>'
Write-Host 'iex $env:DOTFILES/install/windows/InstallAllSoftware.ps1'
Write-Host 'EasyInstall -use_defaults $true'
