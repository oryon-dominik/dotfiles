#!/usr/bin/env pwsh


function InstallCargoCrates {

    param (
        [string]$path = $(Join-Path -Path $env:DOTFILES -ChildPath "install\crates\cargo-tools.json"),
    )

    $installed = @()

    $json = Get-Content -Path $path | ConvertFrom-Json
    $crates = $json.crates
    foreach ($element in $crates) {
        Write-Host ""
        $crate = $element.crate
        if ($element.os -eq $null -or $element.os -eq "windows") {
            Write-Host "Installing $crate..."
            cargo install $crate
            $installed += $crate
        } else {
            Write-Host "Skipping installation of $crate on Windows operating system."
        }
    }

    return $installed
}
