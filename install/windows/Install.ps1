#!/usr/bin/env pwsh

# Windows 10 Powershell dotfiles Installation.

Write-Host "Deprecation Notice: This script is deprecated and needs a heavy rebuild. Exiting."
Exit 1


# Pre-install
# 1. Install latest powershell (as admin)
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

# 2. reopen a new (user) shell
Exit 0

# Install package manager 'scoop'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# git
scoop install git

# Add the dotfiles environment variable pointing to your personalized dotfiles location.
$dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES", "$dotfiles_location", "User")

# Clone the dotfiles
git clone https://github.com/oryon-dominik/dotfiles "$env:DOTFILES"

# Setup git, removes old gitconfig, replaces with symlink from dotfiles and
# adds a local (non-version-controlled) gitconfig for your user
. "$env:DOTFILES\install\windows\SetupGit.ps1"
SetupGit -email $null -name $null

# Delete old powershell profiles and symlink the one from the dotfiles.
. "$env:DOTFILES\install\windows\SymlinkPowershell.ps1"
SymlinkPowershell

# Install programms
. "$env:DOTFILES/install/windows/InstallAllSoftware.ps1"
EasyInstall -use_defaults $true

. "$env:DOTFILES/install/windows/SymlinkDotfiles.ps1"
SymlinkDotfiles

# Setup ssh
. "$env:DOTFILES/install/windows/SetupOpenSSH.ps1"
SetupSSH

# TODO: create initial .env and other directories (shared logs et cetera..) neccessary for a vital and runnable installation

Write-Host "Done :)"
