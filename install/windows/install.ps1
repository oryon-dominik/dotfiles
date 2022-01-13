#!/usr/bin/env pwsh

# Windows 10 Powershell dotfiles Installation.

# Elevated powershell
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$is_elevated) { Write-Host "Can't install powershell dotfiles as unprivileged user."; return }

# Install powershell 7
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

$dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES", "$dotfiles_location", "User")

# Install package manager 'chocolatey'
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# deprecated: Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 3. reopen elevated shell
choco install git -y
refreshenv
git clone https://github.com/oryon-dominik/dotfiles-den "$env:DOTFILES"

# Symlink dotfiles to the old powershell profile
Remove-Item -path "$env:USERPROFILE/Documents/WindowsPowerShell" -recurse
New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
# and the powershell 7 profile
Remove-Item -path "$env:USERPROFILE/Documents/PowerShell" -recurse
New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"

# Install ALL programms
Write-Host "Installing Software.. this may take a while."
Write-Host "Meanwhile style your taskbar, desktop and color-theme (#861a22). Customize sounds."

choco feature enable -n allowGlobalConfirmation

Write-Host "Installing essentials for CLI and development."
. "$env:DOTFILES/install/windows/InstallAdditionalPowershellModules.ps1"

choco install "$env:DOTFILES/install/windows/choco_cli_enhanced.config"
choco install "$env:DOTFILES/install/windows/choco_languages.config"

refreshenv
. "$env:DOTFILES/install/windows/InstallModernUnixForWindows.ps1"

Write-Host "Installing Visual Studio, please wait... you should customize your visualstudio installation to include all neccessary build tools (C/C++)."
choco install visualstudio2022professional
refreshenv

Write-Host "Installing other useful software..."
function GetKeyPress([string]$regexPattern='[ynq]', [string]$message=$null, [int]$timeOutSeconds=0) {
    $key = $null
    $Host.UI.RawUI.FlushInputBuffer() 

    if (![string]::IsNullOrEmpty($message)) {
        Write-Host -NoNewLine $message
    }

    $counter = $timeOutSeconds * 1000 / 250
    while($key -eq $null -and ($timeOutSeconds -eq 0 -or $counter-- -gt 0)) {
        if (($timeOutSeconds -eq 0) -or $Host.UI.RawUI.KeyAvailable) {
            $key_ = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,IncludeKeyUp")
            if ($key_.KeyDown -and $key_.Character -match $regexPattern) {
                $key = $key_
            }
        } else {
            Start-Sleep -m 250  # Milliseconds
        }
    }

    if (-not ($key -eq $null)) {
        Write-Host -NoNewLine "$($key.Character)" 
    }

    if (![string]::IsNullOrEmpty($message)) {
        Write-Host "" # newline
    }
    return $(if ($key -eq $null) {$null} else {$key.Character})
}


$key = GetKeyPress '[y]' "Press y to install additional software packages for essential use cases, web & media editing." 7
if ($key -ne $null) {
    choco install "$env:DOTFILES/install/windows/choco_security.config"
    choco install "$env:DOTFILES/install/windows/choco_development.config"
    choco install "$env:DOTFILES/install/windows/choco_google_web.config"
    choco install "$env:DOTFILES/install/windows/choco_essential_guis.config"
    choco install "$env:DOTFILES/install/windows/choco_media.config"
} else {
    Write-Host "Skipped additional software installation."
}

refreshenv
. "$env:DOTFILES/install/windows/SymlinkDotfiles.ps1"

Write-Host "Done :)"
