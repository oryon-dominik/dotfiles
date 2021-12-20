#!/usr/bin/env pwsh

# Elevated powershell
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$is_elevated) { 
    Write-Host "Can't install windows dotfiles without elevation."
    Return
}

# ...