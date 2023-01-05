# Convert Line endings from Windows to Unix recursively from a given path (default: current directory)
# Usage: ConvertLineEndings -path "C:\path\to\convert".
# ! dos2unix is required to be installed on the system.

function ConvertLineEndings {
    Param ([string]$path)

    if ($path -eq "") {
        $path = Get-Location
    }

    # Does the path exist?
    if (!(Test-Path -Path $path)) {
        Write-Host "Path $path does not exist."
        return
    }

    Write-Host "Converting line endings from Windows to Unix..."
    Get-ChildItem -Path $path -Recurse |
        Foreach-Object {
            if (Test-Path -Path $_.FullName -PathType Leaf) {
                dos2unix --verbose $_.FullName
            }
        }
}
