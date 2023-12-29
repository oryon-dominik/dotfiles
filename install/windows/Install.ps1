#!/usr/bin/env pwsh

# Windows 10 Powershell dotfiles Installation.

Write-Host "Deprecation Notice: This script is deprecated and needs a heavy rebuild. Exiting."
Exit 1


# Elevated powershell
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
# TODO: make it runnable as an unprivileged user, skip software that needs privileges
if (!$is_elevated) { Write-Host "Can't install powershell dotfiles as unprivileged user."; return }

# 1. Install latest powershell
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

$dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES", "$dotfiles_location", "User")

# 2. reopen a new shell
function Reset-Session {
    # store this shell's parent PID for later use
    $parentPID = $PID
    # get the the path of this shell's executable
    $thisExePath = (Get-Process -Id $PID).Path
    # start a new shell, same window
    Start-Process $thisExePath -NoNewWindow
    # stop this shell if it's still alive
    Stop-Process -Id $parentPID -Force
}
Reset-Session

# 3. Install package manager 'scoop'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# git
scoop install git

# clone the dotfiles
git clone https://github.com/oryon-dominik/dotfiles-den "$env:DOTFILES"

# Symlink dotfiles to the old powershell profile
# TODO: use and create a (or two, one for pwsh and one for custom scripts..) symlink script from dotfiles
Remove-Item -path "$env:USERPROFILE/Documents/WindowsPowerShell" -recurse
New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
# and the powershell 7 profile
Remove-Item -path "$env:USERPROFILE/Documents/PowerShell" -recurse
New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"

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

Write-Host "Done :)"
