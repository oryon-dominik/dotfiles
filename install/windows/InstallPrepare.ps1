#!/usr/bin/env pwsh

$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = [bool]$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if ($isAdmin -eq $true) {
    Write-Host "This script should not be run with administrative privileges. Please run as unprivileged user."
    return
}

# Touch a dotenv to store your custom environment variables - valid for powershell sessions only.
$dotenv_path = (Join-Path -Path "$env:DOTFILES" -ChildPath ".env");
if (!(Test-Path -Path $dotenv_path -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $dotenv_path
}

# TODO: fill initial .env and
# TODO: create other directories (shared logs et cetera..) neccessary for a vital and runnable installation

Write-Host "Done :)"


# # Install programms as user
# . "$env:DOTFILES/install/windows/InstallAllSoftware.ps1"
# EasyInstall -use_defaults $true
