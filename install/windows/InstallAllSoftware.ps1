#!/usr/bin/env pwsh


function EasyInstall {

    param (
        [bool]$scoops = $null,
        [bool]$essentials = $null,
        [bool]$rust = $null,
        [bool]$modernunix = $null,
        [bool]$python = $null,
        [bool]$golang = $null,
        [bool]$javascript = $null,
        [bool]$buildtools = $null,
        [bool]$google_filestream = $null,
        [bool]$pwsh_modules = $null,
        [bool]$use_defaults = $false
    )

    if ($use_defaults -eq $true) {
        $scoops = $true
        $essentials = $true
        $rust = $true
        $modernunix = $true
        $python = $true
        $golang = $false
        $javascript = $true
        $buildtools = $false
        $google_filestream = $false
        $pwsh_modules = $true
    }

    # 1. Install package manager 'scoop' packages
    if ($scoops -eq $null) {
        $install_scoops = Read-Host "Install essential scoops pacakges? [recommended] (y/n)"
        $scoops = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_scoops)
    }
    if ($scoops -eq $true -and $essentials -eq $null) {
        $install_essentials = Read-Host "Install ALL scoop packages [optional] (y/n)"
        $essentials = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_essentials)
        # invert the boolean
        $essentials = -not $essentials
    }
    # 2. Install rust toolchain
    if ($rust -eq $null) {
        $install_rust = Read-Host "Install rust toolchain? [recommended] (y/n)"
        $rust = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_rust)
    }
    # 3. Install modern unix toolchain
    if ($rust -eq $true -and $modernunix -eq $null) {
        $install_modernunix = Read-Host "Install ALL modernunix cargo crates [recommended] (y/n)"
        $modernunix = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_modernunix)
    }
    # 4. Install python toolchain
    if ($python -eq $null) {
        $install_python = Read-Host "Install python toolchain? [recommended] (y/n)"
        $python = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_python)
    }
    # 5. Install golang toolchain
    if ($golang -eq $null) {
        $install_golang = Read-Host "Install golang toolchain? [recommended] (y/n)"
        $golang = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_golang)
    }
    # 6. Install javascript toolchain
    if ($javascript -eq $null) {
        $install_javascript = Read-Host "Install javascript toolchain? [recommended] (y/n)"
        $javascript = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_javascript)
    }
    # 7. Install additional powershell modules
    if ($pwsh_modules -eq $null) {
        $install_pwsh_modules = Read-Host "Install additional powershell modules? [recommended] (y/n)"
        $pwsh_modules = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_pwsh_modules)
    }
    # 8. Install google drive file stream
    if ($google_filestream -eq $null) {
        $install_google_filestream = Read-Host "Install google drive file stream? [not recommended] (y/n)"
        $google_filestream = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_google_filestream)
    }
    # 9. Install visual studio build tools
    if ($buildtools -eq $null) {
        $install_buildtools = Read-Host "Install visual studio build tools? [not recommended] (y/n)"
        $buildtools = [System.Management.Automation.LanguagePrimitives]::ConvertToBoolean($install_buildtools)
    }

    InstallSoftware -scoops $scoops -essentials $essentials -rust $rust -modernunix $modernunix -python $python -golang $golang -javascript $javascript -pwsh_modules $pwsh_modules -google_filestream $google_filestream -buildtools $buildtools

}


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
        [bool]$javascript = $false,
        [bool]$buildtools = $false,
        [bool]$google_filestream = $false,
        [bool]$pwsh_modules = $false,

        [string]$dotfilespath = $($env:DOTFILES)
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

    if ($golang -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallGolang.ps1")
        $installed += InstallGolangToolchain
    }

    if ($javascript -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallJavaScript.ps1")
        $installed += InstallJavaScriptToolchain
    }

    if ($modernunix -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallModernUnixForWindows.ps1")
        $installed += InstallModernUnixToolchain
    }

    # TODO: check what installations need privileges and ask for them at the beginning of the script(s). (use sudo)
    # (And if the user needs an install, chown/chmod the files to the user.)
    if ($python -eq $true) {
        . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallPython.ps1")
        $installed += ManagePythonToolchain -python $true -pyenv $true -poetry $true -global $true -favourites $true -clean $true
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
