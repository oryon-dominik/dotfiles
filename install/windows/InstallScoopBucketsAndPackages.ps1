#!/usr/bin/env pwsh

# TODO: make a function out of this that takes categories and path as args, return installed and skipped packages

$categories = @("cli", "development", "fonts", "guis", "languages", "media", "security", "web", "deplyoment")

$scoopsPath = Join-Path $env:DOTFILES "install\scoops\scoop-packages.json"
$scoopsJsonContent = Get-Content -Path $scoopsPath | ConvertFrom-Json
$scoops = $scoopsJsonContent.scoops

$bucketsVisited = @()
$scoopsInstalled = @()
$scoopsSkipped = @()

foreach ($scoop in $scoops) {
    $package = $scoop.package
    $bucket = $scoop.bucket
    $category = $scoop.category

    if ($bucket -notin $bucketsVisited) {
        Write-Host "Adding bucket $bucket."
        # scoop bucket add $bucket
        $bucketsVisited += $bucket
    }
    if ($scoop.category -ne $null -and $categories -contains $category) {
        Write-Host "Installing $package."
        # scoop install $package
        $scoopsInstalled += $package
    } else {
        # Write-Host "Skipping installation of $package. Category is not in list of categories to install."
        $scoopsSkipped += $package
    }
}
if ($scoopsSkipped -ne $null -and $scoopsSkipped.Count -gt 0) {
    Write-Host "Skipped packages: $scoopsSkipped"
}
if ($scoopsInstalled -ne $null -and $scoopsInstalled.Count -gt 0) {
    Write-Host "Installed packages: $scoopsInstalled"
}
