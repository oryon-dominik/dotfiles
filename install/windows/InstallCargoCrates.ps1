#!/usr/bin/env pwsh

$cratesPath = Join-Path $env:DOTFILES "install\crates\cargo-tools.json"
$cratesJsonContent = Get-Content -Path $cratesPath | ConvertFrom-Json
$crates = $cratesJsonContent.crates
foreach ($element in $crates) {
    Write-Host ""
    $crate = $element.crate
    if ($element.os -eq $null -or $element.os -eq "windows") {
        Write-Host "Installing $crate..."
        cargo install $crate
    } else {
        Write-Host "Skipping installation of $crate on Windows operating system."
    }
}
