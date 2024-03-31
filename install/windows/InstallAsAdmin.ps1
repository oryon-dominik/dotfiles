#!/usr/bin/env pwsh

$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = [bool]$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if ($isAdmin -eq $false) {
    Write-Host "This script requires administrative rights to run. Please run it as an administrator."
    return
}

# This is non-admin user specific, it just requires privileges to create the symlink for the users user.
# So I have to ask (or assume) the correct username here!
$UserPath = Read-Host "Enter the user path (Press Enter for default: $env:USERPROFILE)"
if (-not $UserPath) {
    $UserPath = $env:USERPROFILE
}

# Setup git, removes old gitconfig, replaces with symlink from dotfiles and
# adds a local (non-version-controlled) gitconfig for your user
. "$env:DOTFILES/install/windows/SetupGit.ps1"
SetupGit -email $null -name $null -UserPath "$UserPath"
Write-Host

# Delete old powershell profiles and symlink the one from the dotfiles.
. "$env:DOTFILES/install/windows/SymlinkPowershell.ps1"
SymlinkPowershell -UserPath "$UserPath"
Write-Host

# Symlink program configs from your dotfiles.
. "$env:DOTFILES/install/windows/SymlinkDotfiles.ps1"
SymlinkDotfiles -UserPath "$UserPath"
Write-Host

Write-Host "SSH setup is deactivated for now. Fix manually."
# . "$env:DOTFILES/install/windows/SetupOpenSSH.ps1"
# SetupSSH
Write-Host

Write-Host "Done :)"
Write-Host ""
Write-Host "Now leave your privilege and install all neccessary software as the common user."
Write-Host '->>'
Write-Host 'iex $env:DOTFILES/install/windows/InstallAllSoftware.ps1'
Write-Host 'EasyInstall -use_defaults $true'
