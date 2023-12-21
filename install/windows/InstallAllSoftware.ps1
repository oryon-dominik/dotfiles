#!/usr/bin/env pwsh

function InstallSoftware {
    # Installing open source and proprietary software on a windows machine.
    # Prepare for a long installation time.
    param (
        [bool]$scoops = $true,
        [bool]$essentials = $true,
        [bool]$rust = $true,
        [bool]$modernunix = $true,
        [bool]$python = $true,
        [bool]$golang = $false,
        [bool]$buildtools = $false,
        [bool]$googlefs = $false,
        [bool]$pwshmodules = $false
        [string]$dotfilespath = $($env:DOTFILES),
    )

    if ($dotfilespath -eq $null) {
        Write-Host "No dotfiles path given. env:DOTFILES is not set. Exiting."
        return
    }

    # TODO: make functions out of these scripts that return their states and installed packages and take some arguments (paths, categories etc) as input.
    # TODO: check for what installation are privileges needed and ask for them at the beginning of the script.

    if ($scoops -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallScoopBucketsAndPackages.ps1")
        $installed = InstallScoops -essentials $essentials
    }

    if ($rust -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallRust.ps1")
        if ($modernunix -eq $true) {
            . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallModernUnixForWindows.ps1")
        }
    }

    if ($python -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallPython.ps1")
    }

    if ($golang -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGolang.ps1")
    }

    if ($googlefs -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGoogleDriveFileStream.ps1")
    }

    if ($buildtools -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallVisualstudioBuildTools.ps1")
    }

    if ($pwshmodules -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallAdditionalPowershellModules.ps1")
    }

}
