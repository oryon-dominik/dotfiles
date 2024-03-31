#!/usr/bin/env pwsh

function InstallScoops {
    param (
        [string]$path = $(Join-Path -Path $env:DOTFILES -ChildPath "install\scoops\scoop-packages.json"),
        [bool]$essentials = $false,
        [string[]]$categories = @(
            "cli", "development", "fonts", "guis", "languages", "media", "security", "web", "deployment"
        )  # ! shall be all categories by default
    )

    $json = Get-Content -Path $path | ConvertFrom-Json
    $scoops = $json.scoops

    $bucketsVisited = @()
    $skipped = @()
    $installed = @()

    foreach ($scoop in $scoops) {
        $package = $scoop.package
        $bucket = $scoop.bucket
        $category = $scoop.category
        $essential = $scoop.essential

        if ($essentials -eq $true -and $essential -eq $false) {
            continue  # Silently skip
        }

        if ($bucket -notin $bucketsVisited) {
            Write-Host "Adding bucket $bucket."
            # scoop bucket add $bucket
            $bucketsVisited += $bucket
        }

        if ($scoop.category -ne $null -and $categories -contains $category) {
            Write-Host "Installing $package."
            scoop install "$bucket/$package"
            $installed += $package
        } else {
            # "Skipping installation of $package. Category is not in list of categories to install."
            $skipped += $package
        }
    }
    if ($skipped -ne $null -and $skipped.Count -gt 0) {
        Write-Debug "Skipped packages: $skipped"
    }
    if ($installed -ne $null -and $installed.Count -gt 0) {
        Write-Debug "Installed packages: $installed"
    }
    return $installed
}
