
# required: python and powershell files execute via '.' TODO: run scripts from executables-path

$update_message = "Full System Upgrade"
Write-Host "Starting Full System Upgrade..."
Write-Host ""
Write-Output (-join('{"message": "', $($update_message), '", "timestamp": "', $(Get-TimeStamp), '"},')) | Out-file (Join-Path -Path $env:DEN_ROOT -ChildPath "local\logs\$env:computername\updates.log") -append
Write-Host "Updating local Python-Scripts.."
. (Join-Path -Path $script_location -ChildPath "\python\update_scripts.py")
Write-Host ""
Write-Host "Updating python.."
python-update
Write-Host ""
Write-Host "Updating local repositories.."
. (Join-Path -Path $script_location -ChildPath "\powershell\limbs\update_repositories.ps1")
Write-Host ""
Write-Host "Updating installed Software Packages.."
choco upgrade all
Write-Host ""

Write-Host "Adding installed chocolatey packages to local list"
Write-Output choco list -lo -r -y | Out-file (Join-Path -Path $env:DEN_ROOT -ChildPath "local\installedPackages\$env:computername\choco_installed_packages.txt")
Write-Host ""

Write-Host "Installing Windows Updates.."
$updates = Start-WUScan
foreach($update in $updates)
{ 
    Write-Host $update.title
    Write-Host "Success:"
    Install-WUUpdates -Updates $update
}

Import-Module PSWindowsUpdate
Get-WUInstall -AcceptAll -IgnoreUserInput -Confirm:$false
wmic qfe list
Write-Host ""
Write-Host "Updates finished"
