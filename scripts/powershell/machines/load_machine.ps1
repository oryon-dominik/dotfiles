#!/usr/bin/env pwsh

# This script loads a file named like your machine ($env:computername.ps1)
# place any machine-specific code to run inside that file.

$machine_path = Join-Path -Path $PSScriptRoot -ChildPath "$env:computername.ps1"
If ((Test-Path $machine_path) -eq $True) {. $machine_path}
