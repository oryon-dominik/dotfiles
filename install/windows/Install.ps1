#!/usr/bin/env pwsh

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
# Touch a dotenv to store your custom environment variables - valid for powershell sessions only.
$dotenv_path = (Join-Path -Path "$env:DOTFILES" -ChildPath ".env");
if (!(Test-Path -Path $dotenv_path -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $dotenv_path
}


Write-Host "Done :)"
