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
        [bool]$google_filestream = $false,
        [bool]$pwsh_modules = $false
        [string]$dotfilespath = $($env:DOTFILES),
    )

    if ($dotfilespath -eq $null) {
        Write-Host "No dotfiles path given. env:DOTFILES is not set. Exiting."
        return
    }

    $installed = @()

    if ($scoops -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallScoopBucketsAndPackages.ps1")
        $installed += InstallScoops -essentials $essentials
    }

    if ($rust -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallRust.ps1")
        $installed += InstallRustToolchain
    }

    if ($modernunix -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallModernUnixForWindows.ps1")
        $installed += InstallModernUnixToolchain
    }

    # TODO: check what installations need privileges and ask for them at the beginning of the script(s).
    # (And if the user needs an ionstall, chown/chmod the files to the user.)
    # TODO: make functions out of these scripts that return their states and installed packages and take some arguments (paths, categories etc) as input.
    if ($python -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallPython.ps1")
        $installed += ManagePythonToolchain -python $true -pyenv $true -poetry $true -global $true -favourites $true -clean $true
    }

    if ($golang -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGolang.ps1")
        $installed += InstallGolangToolchain
    }

    if ($google_filestream -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGoogleDriveFileStream.ps1")
        $installed += DownloadAndInstallGoogleDriveFileStream
    }

    if ($buildtools -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallVisualstudioBuildTools.ps1")
        $installed += InstallVisualstudioBuildTools
    }

    if ($pwsh_modules -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallAdditionalPowershellModules.ps1")
        $installed += InstallAdditionalPowershellModules
    }

    Write-Host "Installed software:"
    foreach ($element in $installed) {
        Write-Host $element
    }

    return $installed
}
