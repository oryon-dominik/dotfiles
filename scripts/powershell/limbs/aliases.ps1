﻿# required: set variables to your configs locations
#             ($env:DOTFILES, $console, $icons, $powershell_location, $shortcuts, $position)
# required: the directory .$settings.local_location/logs/ must be available | TODO: implement check on install script and create first logfiles manually..

# load functions
. $PSScriptRoot\functions.ps1

# load projects
. $PSScriptRoot\projects.ps1
# load machine
. $PSScriptRoot\..\machines\load_machine.ps1

# managing the computer's state
Set-Alias -Name reboot -Value Restart-Computer -Description "reboot"
Set-Alias -Name reb -Value Restart-Computer -Description "reboot"
# %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState Hibernate
function hibernate {& "$env:windir\system32\shutdown.exe" /h}
Set-Alias -Name hib -Value hibernate -Description "hibernation"
Set-Alias -Name aus -Value Stop-Computer -Description "shutdown"

# some linux aliases
Set-Alias -Name ll -Value Get-ChildItem -Description "linux ll like"
Set-Alias -Name la -Value Get-ChildItem -Force -Description "linux ll like"
Set-Alias -Name touch -Value New-Item -Description "Creates a file"

function linux_grep($string, $file) {sls $string .\$file -ca}
Set-Alias -Name grep -Value linux_grep -Description "Linux like grep"

Set-Alias -Name whereis -Value Get-Command -Description "Shows commands locations"
Set-Alias -Name manpage -Value Get-help -Description "Manpage"
Set-Alias -Name cat -Value lolcat -Description "Replace cat with colors :) from lolcat (installation required)"

Set-Alias -Name draw -Value Write-Pixel -Description "Draws pictures in pixel into shell"
function md5($filepath) {Get-FileHash $filepath -Algorithm MD5}


# development
Set-Alias git hub  # integrates hub into git command-line (https://github.com/github/hub)
function webserver { python "-m http.server 80" }

# media
$env:path += ";C:\Program Files\VideoLAN\VLC\vlc.exe"
Set-Alias -Name play -Value vlc -Description "Plays media with vlc"

# programs
function jup {jupyter notebook}
function netflix { Start-Process -FilePath "$shortcuts\netflix.lnk" }
function pocketcast { Start-Process -FilePath "$shortcuts\Pocket Casts.lnk" }
Set-Alias -Name steam -Value "D:\Steam\Steam.exe" -Description "start gameclient steam"

# office
Set-Alias -Name word -Value "C:\Program Files\Microsoft Office\root\Office16\winword.exe" -Description "start word"
Set-Alias -Name ppt -Value "C:\Program Files\Microsoft Office\root\Office16\powerpnt.exe" -Description "start powerpoint"
Set-Alias -Name excel -Value "C:\Program Files\Microsoft Office\root\Office16\excel.exe" -Description "start excel"
Set-Alias -Name mail -Value "C:\Program Files (x86)\Mozilla Thunderbird\thunderbird.exe" -Description "Open thunderbird"
Set-Alias -Name pdf -Value SumatraPDF -Description "reads pdf"
Set-Alias -Name np -Value notepad++ -Description "edit file fast"

# docker
Set-Alias -Name dc -Value docker-compose -Description "Docker-Compose"
function up {docker-compose up}
function build {docker-compose build}
function mm {docker-compose run --rm django python manage.py makemigrations}
function mig {docker-compose run --rm django python manage.py migrate}
function te {docker-compose run --rm django pytest}
function init {docker-compose run --rm django python manage.py initialize; docker-compose run --rm django python manage.py createusers}

# custom-dotfiles-scripts
Set-Alias -Name clitube -Value (Join-Path -Path $script_location -ChildPath "\python\cliTube.py") -Description "Plays Youtube Search-Results"  # needs cliTube.py in $script_location
Set-Alias -Name timer -Value (Join-Path -Path $script_location -ChildPath "\python\timer.py") -Description "Starts a timer"  # needs timer.py in $script_location

# loading local aliases last, to overwrite existing ones
# load locations
. $PSScriptRoot\locations.ps1
