# required: set variables to your configs locations
#             ($env:DOTFILES, $shortcuts, $position)
# required: the directory shared/logs/ must be available | TODO: implement check on install script and create first logfiles manually..

# load functions
. $PSScriptRoot\functions.ps1

# load machine
. $PSScriptRoot\..\machines\load_machine.ps1

# managing the computer's state
Set-Alias -Name reboot -Value Restart-Computer -Description "reboot"
Set-Alias -Name reb -Value Restart-Computer -Description "reboot"
# %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState Hibernate
function hibernate {& "$env:windir\system32\shutdown.exe" /h}
Set-Alias -Name hib -Value hibernate -Description "hibernation"
Set-Alias -Name aus -Value Stop-Computer -Description "shutdown"

# ls -> exa
Remove-Alias -Name ls
function ls {exa --group-directories-first --git-ignore}
function ll {exa --color-scale --long --header --group-directories-first}
function la {exa --all --color-scale --long --header --group-directories-first}
function lt {exa --tree --color-scale --group-directories-first}
function l {exa --all --color-scale --long --header --git --group-directories-first}

# linux-like
Set-Alias -Name touch -Value New-Item -Description "Creates a file"
function .. {cd ..}
Set-Alias -Name clear -Value cls
function ports {netstat -n}
Set-Alias -Name grep -Value rg -Description "Ripgrep"
Set-Alias -Name whereis -Value Get-Command -Description "Shows commands locations"
Set-Alias -Name cat -Value lolcat -Description "Replace cat with colors :) -> lolcat (installation required)" -Option AllScope

function run_fzf {fzf $args}  # needs fzf installed
Set-PSReadlineKeyHandler -Key Ctrl+r -BriefDescription fzf -LongDescription "Reverse History search with fzf" ` -ScriptBlock {run_fzf}

# hashes
function md5($filepath) {Get-FileHash $filepath -Algorithm MD5}
function sha256($filepath) {Get-FileHash $filepath -Algorithm SHA256}

# media
Set-Alias -Name play -Value vlc -Description "Plays media with vlc"

# programs
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
Set-Alias -Name npp -Value notepad++ -Description "edit file fast"
Set-Alias -Name notepad -Value notepad++ -Description "edit file fast"

function cloud {  # cd into your mounted cloud drive
    if (("{0}" -f $env:CLOUD_MOINT_POINT) -ne "") {
        cd $env:CLOUD_MOINT_POINT
    } else {
        Write-Host "env:CLOUD_MOINT_POINT not set. Skipping."
    }
}

# loading local aliases last, to overwrite existing ones
# load locations
if(!(test-path $PSScriptRoot\locations.ps1)) {
    New-Item -ItemType File -Force -Path $PSScriptRoot\locations.ps1
}
. $PSScriptRoot\locations.ps1
