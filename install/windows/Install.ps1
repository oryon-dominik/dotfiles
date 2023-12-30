#!/usr/bin/env pwsh

# Windows 10 Powershell dotfiles Installation.

Write-Host "Deprecation Notice: This script is deprecated and needs a heavy rebuild. Exiting."
Exit 1


# Elevated powershell
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
# TODO: make it runnable as an unprivileged user, skip software that needs privileges
if (!$is_elevated) { Write-Host "Can't install powershell dotfiles as unprivileged user."; return }

# Pre-install
# 1. Install latest powershell
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

# 2. Add the dotfiles environment variable pointing to your personalized dotfiles location.
$dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES", "$dotfiles_location", "User")

# 3. reopen a new shell
Exit 0

# 1. Install package manager 'scoop'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# git
scoop install git

# clone the dotfiles
git clone https://github.com/oryon-dominik/dotfiles-den "$env:DOTFILES"
AddToDotenv -path "$env:DOTFILES\.env" -key "GIT_CONFIG_SYSTEM" -value "$env:USERPROFILE\.gitconfig" -overwrite $false -warn $false

# delete old powershell profiles and symlink the one from the dotfiles
. "$env:DOTFILES\install\windows\SymlinkPowershell.ps1"
SymlinkPowershell

Exit 1

# TODO: symlink the gitconfig from the dotfiles. Also edit the name from the local user as default here.. (maybe use a function for this)
# TODO: input possible for minimal installation (without rust, golang, python, visualstudio, google drive file stream, etc..)

# Install ALL programms
Write-Host "Installing ALL Software packages.. this may take a while."
Write-Host "Meanwhile style your taskbar, desktop and color-theme (#861a22). Customize sounds. Get some coffee, go for a walk.."
. "$env:DOTFILES/install/windows/InstallAllSoftware.ps1"

# TODO: call with mandatory parameter  # ask what software to install here as args
# Only install essentials (modern unix and scoops, without current python)

InstallSoftware -essentials $true -python $false

# TODO: symlink all configs for installed software (maybe return a list of it from InstallAllSoftware.ps1 ??)
. "$env:DOTFILES/install/windows/SymlinkDotfiles.ps1"

# TODO:
# create initial .env and other directories neccessary for a vital and runnable installation
#

Exit 0

# Post-install
# Prerequisite: scoop and dotfiles installed correctly
# Also remove the legacy openssh and replace it with an actual version
sudo Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
sudo Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

scoop install openssh
# install sshd service and daemon
sudo $env:SCOOP\apps\openssh\current\install-sshd.ps1
Write-host "To uninstall the ssh agent: 'sudo $env:SCOOP\apps\openssh\current\uninstall-sshd.ps1'"

# ! You have to manually start the ssh-agent service in an elevated powershell, sudo doesn't work here.
Get-Service -Name ssh-agent | Set-Service -StartupType Automatic
sudo Start-Service ssh-agent

# now cd into ~./ssh and generate a new ssh keypair
ssh-keygen -t ed25519 -C "$env:USERPROFILE@$(hostname)" -f "$env:USERPROFILE\.ssh\id_ed25519"
ssh-add "$env:USERPROFILE\.ssh\id_ed25519"

Write-Host "Done :)"
