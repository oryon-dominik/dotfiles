﻿# required: set variables to your configs locations
# 			($env:DEN_ROOT, $console, $icons, $powershell_location, $shortcuts, $position)
# required: the dircetory .local/logs/ must be available | TODO: implement check on install script and create first logfiles manually..

# load functions
. $PSScriptRoot\functions.ps1
# load locations
. $PSScriptRoot\locations.ps1
# load projects
. $PSScriptRoot\projects.ps1

Set-Alias -Name draw -Value Write-Pixel -Description "Draws pictures in pixel into shell"

Set-Alias -Name reboot -Value Restart-Computer -Description "reboot"
Set-Alias -Name reb -Value Restart-Computer -Description "reboot"
# %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState Hibernate
Set-Alias -Name hibernate -Value "shutdown.exe /h" -Description "hibernation"
Set-Alias -Name hib -Value "shutdown.exe /h" -Description "hibernation"
Set-Alias -Name aus -Value Stop-Computer -Description "shutdown"

Set-Alias -Name touch -Value New-Item -Description "Creates a file"
Set-Alias -Name whereis -Value Get-Command -Description "Shows commands locations"
Set-Alias -Name manpage -Value Get-help -Description "Manpage"

function linux_grep($string, $file) {sls $string .\$file -ca}
Set-Alias -Name grep -Value linux_grep -Description "Linux like grep"

function md5($filepath) {Get-FileHash $filepath -Algorithm MD5}

# development
function webserver { python "-m http.server 80" }

Set-Alias git hub  # integrates hub into git command-line (https://github.com/github/hub)

# media
$env:path += ";C:\Program Files\VideoLAN\VLC\vlc.exe"
Set-Alias -Name play -Value vlc -Description "Plays media with vlc"

Set-Alias -Name tube -Value (Join-Path -Path $script_location -ChildPath "\python\cliTube.py") -Description "Plays Youtube Search-Results"  # needs cliTube.py in $script_location
Set-Alias -Name timer -Value (Join-Path -Path $script_location -ChildPath "\python\timer.py") -Description "Starts a timer"  # needs timer.py in $script_location

# programs
function jup {jupyter notebook}

function netflix { Start-Process -FilePath "$shortcuts\netflix.lnk" }

function pocketcast { Start-Process -FilePath "$shortcuts\Pocket Casts.lnk" }

Set-Alias -Name mail -Value "C:\Program Files (x86)\Mozilla Thunderbird\thunderbird.exe" -Description "Open thunderbird"

Set-Alias -Name pdf -Value SumatraPDF -Description "reads pdf"
