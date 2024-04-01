#!/usr/bin/env pwsh


# Load dotenv from provided path
function LoadDotEnv {
    Param([parameter(Mandatory=$true)] [String[]] $path)

    # does env exist?
    if (!( Test-Path $path)) {
        Write-Warning "Failed to load environment variables from $path"
        return
    }

    $dotenvs = Get-Content $path -ErrorAction Stop

    foreach ($line in $dotenvs) {
        if (!$line -or $line.StartsWith("#")) { continue }  # skip empty lines and comments
        elseif ($line.Trim()) {
            $kvp = $line.Replace("`"","") -split "=",2
            [Environment]::SetEnvironmentVariable($kvp[0].Trim(), $kvp[1].Trim(), "Process") | Out-Null
        }
    }
}


function AddToDotenv {
    Param(
        [parameter(Mandatory=$true)] [String[]] $path,
        [parameter(Mandatory=$true)] [String[]] $key,
        [parameter(Mandatory=$false)] [String[]] $value = "",
        [parameter(Mandatory=$false)] [bool] $overwrite = $false,
        [parameter(Mandatory=$false)] [bool] $warn = $true
    )

    # does env exist?
    if (!( Test-Path $path -PathType Leaf))) {
        Write-Warning "Failed to load environment variables from $path"
        return
    }

    $dotenvs = Get-Content $path -ErrorAction Stop
    if ($dotenvs -eq $null -or $dotenvs.Count -eq 0) {
    # If there are no entries yet, add the first line.
        $dotenvs = @("# Set all environment variables here")
    }

    $found = $false
    foreach ($line in $dotenvs) {
        if ($line -match "^$key") {
            $found = $true
            # Replace
            if (!$overwrite) {
                if ($warn) {
                    Write-Host "Skipping $key in $path, already exists."
                }
                return
            }
            if ($warn) {
                Write-Host "Replacing $key in $path with $value."
            }
            $dotenvs[$dotenvs.IndexOf($line)] = "$key=$value"
        }
    }

    if (!$found) {
        $dotenvs += "$key=$value"
    }

    $dotenvs | Set-Content $path
}
