#!/usr/bin/env pwsh

# Installing all software on a new windows machine.

# TODO: make functions out of these scripts that return their states and installed packages and take some arguments (paths, categories etc) as input.
# TODO: check for what installation are privileges needed and ask for them at the beginning of the script.

Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallScoopBucketsAndPackages.ps1")

Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallRust.ps1")
Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallModernUnixForWindows.ps1")

Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallPython.ps1")

Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGolang.ps1")

Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGoogleDriveFileStream.ps1")

Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallVisualstudioBuildTools.ps1")
Invoke-Expression $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallAdditionalPowershellModules.ps1")
