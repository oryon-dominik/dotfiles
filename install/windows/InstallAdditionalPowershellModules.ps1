#!/usr/bin/env pwsh

# Elevated powershell
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$is_elevated) { Write-Host "Can't install additional powershell modules as unprivileged user."; return }

Write-Host "Installing additional powershell modules for all users..."

# Install prerequisite NuGet
Install-PackageProvider -Name NuGet -Force

# Enforce TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# PowerShellGet is the package manager for PowerShell. https://github.com/PowerShell/PowerShellGet
Install-Module -Name PowerShellGet -Force

# Windows Updatges via Powershell. https://www.powershellgallery.com/packages/PSWindowsUpdate
Install-Module -Name PSWindowsUpdate -Force

# Run Linux programs directly from PowerShell. https://github.com/jimmehc/PowerBash
Install-Module -Name PowerBash -Force

# Docker command completion for PowerShell. https://github.com/matt9ucci/DockerCompletion
Install-Module -Name DockerCompletion -Force

# Simplified implementation of lolcat in PowerShell. https://github.com/andot/lolcat
Install-Module -Name lolcat -Force
