# required: set variables to your configs locations ($env:DOTFILES)

# load system functions
. $env:DOTFILES\scripts\powershell\System.ps1
. $env:DOTFILES\scripts\powershell\PythonPowershell.ps1
. $env:DOTFILES\scripts\powershell\Tube.ps1

# load machine specific scripts
. $env:DOTFILES\scripts\powershell\machines\LoadMachine.ps1

# managing the computer's state
Set-Alias -Name reboot -Value Restart-Computer -Description "reboot"
Set-Alias -Name reb -Value Restart-Computer -Description "reboot"
# %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState Hibernate
function hibernate {& "$env:windir\system32\shutdown.exe" /h}
Set-Alias -Name hib -Value hibernate -Description "hibernation"
Set-Alias -Name aus -Value Stop-Computer -Description "shutdown"

# ls -> exa
Remove-Alias -Name ls
function ls {exa --group-directories-first --git-ignore $args}
function ll {exa --color-scale --long --header --group-directories-first $args}
function la {exa --all --color-scale --long --header --group-directories-first $args}
function lt {exa --tree --color-scale --group-directories-first $args}
function l {exa --all --color-scale --long --header --git --group-directories-first $args}

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

# symlinks
# link <target> <source>              create a junction -> "symlink" for directories
function linkdir($target, $source){New-Item -Path $target -ItemType Junction -Value $source}
# symlink <target> <source>           create a symlink for files
function link($target, $source){New-Item -Path $target -ItemType SymbolicLink -Value $source}

# media
Set-Alias -Name play -Value vlc -Description "Plays media with vlc"

# office
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

# python
function ansible { Write-Host "ERROR: Ansible does not support windows (yet?). To use ansible, switch to WSL" }

# config
function cfg { 
    set-location $env:DOTFILES  # dir to the config (the dotfiles) folder.
    if (Get-Command 'deactivate' -errorAction Ignore) { Try { deactivate | out-null } Catch {} }  # deactivate any active env, to work on "pure" system-python
}
# edit the local aliases
function aliases { notepad++ "$env:DOTFILES\common\powershell\Locations.ps1" }  # edit local Aliases
# loading local aliases last, to overwrite existing ones
# load locations
if(!(test-path $PSScriptRoot\Locations.ps1)) {
    New-Item -ItemType File -Force -Path $PSScriptRoot\Locations.ps1
}
. $PSScriptRoot\Locations.ps1
