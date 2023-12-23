#!/usr/bin/env pwsh


function InstallGolangToolchain {

    $installed = @()
    
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
