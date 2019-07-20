# this script loads a file named like your machine (yourcomputername.ps1)
# place any machine-specific aliases inside that file

$machine_path = Join-Path -Path $PSScriptRoot -ChildPath "$env:computername.ps1"
$machine_exists = Test-Path $machine_path
If ($machine_exists -eq $True) {. $machine_path}
