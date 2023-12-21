#!/usr/bin/env pwsh

Write-Host "Installing Golang Toolchain... https://go.dev/"

# Alternative: manually pick releases from https://go.dev/dl/.

# Install using scoop.
scoop install main/go
scoop update go
