#!/usr/bin/env pwsh


Import-Module "$PSScriptRoot\components\DotEnvs.ps1"


function InstallGolangToolchain {

    param (
        [string]$gopath = $($env:GOPATH)
    )

    if ($gopath -eq $null) {
        $gopath = "$(Join-Path -Path $env:SCOOP -ChildPath 'apps\go\current\')"
        Write-Host "No 'env:GOPATH' path given. Using default: '$gopath'."
    }

    $installed = @()

    AddToDotenv -path "$env:DOTFILES\.env" -key "GOPATH" -value "$gopath" -overwrite $false -warn $false

    Write-Host "Installing Golang Toolchain... https://go.dev/"

    # Alternative: manually pick releases from https://go.dev/dl/.

    # Install using scoop.
    scoop install main/go
    scoop update go
    $installed += "golang"

    # Ensure latest go.
    # TBD: go get -u golang.org/dl/go

    return $installed
}
