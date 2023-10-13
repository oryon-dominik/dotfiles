# powershell-profile / oryon-dominik / 2019

$PSDefaultParameterValues = @{'*:Encoding' = 'utf8'}
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#                                       `  
#                                      y. 
#                               `:.`.:ymh 
#                            `o  /mmmmmmm-
#                        -//+hm:  dmmmmmm+
#                        `hmmmmy  smmmmmm+
#                         ommmmy  smmmmmm-
#                         smmmm+ `dmmmmmh 
#                        .dmmmh` ommmmmd- 
#                       `ymmmh- +dmmmmd:  
#                      :hmmms.`sdmmmmy.   
#   `..             ./ydmds-.+hmmmmh/`    
#     `:/::--..-:/oyddhs/-/sdmmmdy:`      
#        ./+sssssoo++/+shdmmmhs/`         
#            .:/ossyyyyss+/-`             

lolcat "$PSScriptRoot\intro"  # print the intro-graphic

# Initializing dotfiles environment variable, if not already set properly
if (-not (Test-Path $env:DOTFILES)) { 
  $dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
  $env:DOTFILES = $dotfiles_location
}

# load local dotenv
. "$PSScriptRoot\components\LoadDotEnv.ps1"
LoadDotEnv("$env:DOTFILES\.env")

# calculate last update
. "$PSScriptRoot\components\upgrades\ReadUpdateLog.ps1"

# set powershell variables
$shortcuts = Join-Path -Path "$env:DOTFILES" -ChildPath "\shared\shortcuts"
$script_location = Join-Path -Path "$env:DOTFILES" -ChildPath '\scripts'
$file_location = Join-Path -Path "$env:DOTFILES" -ChildPath '\shared\files'
$console = Join-Path -Path "$file_location" -ChildPath '\images\console'
$icons = Join-Path -Path "$file_location" -ChildPath '\icons'

# Get device location.
. "$PSScriptRoot\components\GetDeviceLocation.ps1"

# Imports all custom-added-modules to the powershell-space
Import-Module DockerCompletion
# Virtualenvwrapper bindings
$env:WORKON_HOME = "$env:USERPROFILE\$env:GLOBAL_PYTHON_VENVS"
. "$PSScriptRoot\components\SlimVenvWrapper.ps1"
# Upgrades & Update functionality
. "$PSScriptRoot\components\upgrades\Upgrades.ps1"
# Win-EventTail (tails Windows Event Logs) (https://gist.github.com/jeffpatton1971/a908cac57489e6ca59a6)
. "$PSScriptRoot\ModulesInVersionControl\Get-WinEventTail.ps1"
# Weather-Script
. "$PSScriptRoot\ModulesInVersionControl\Get-Weather.ps1"
# Metadata for files
. "$PSScriptRoot\ModulesInVersionControl\Get-FileMetaData.ps1"
# Zoxide Utilities (show with zoxide init powershell)
. "$PSScriptRoot\ModulesInVersionControl\zoxideUtilities.ps1"
# PSReadLine provides fish-like auto-suggestions, included in powershell since 7.2
. "$PSScriptRoot\components\PSReadLineOptions.ps1"
# Thefuck is a command line tool for automatically correcting commands
. "$PSScriptRoot\components\TheFuck.ps1"
# Converting line endings from Windows to Unix
. "$PSScriptRoot\components\ConvertLineEndings.ps1"
# Pull the repositories to avoid merge conflicts every single day..
. "$PSScriptRoot\components\GitPullHelpers.ps1"

# add custom paths
# TODO: read paths from a different path file at a different location and add it here successively
$env:path += ";$Env:Programfiles\VideoLAN\VLC\vlc.exe"
$env:path += ";$Env:Programfiles\NASM"  # netwide-assembler
$env:path += ";$Env:Programfiles\GTK3-Runtime Win64\bin"  # gtk3 (used for weasyprint)
$env:path += ";$(Join-Path -Path "$env:DOTFILES" -ChildPath "\bin")"  # local binaries
$env:path += ";$(Join-Path -Path "$script_location" -ChildPath "\batch")"
$env:path += ";$(Join-Path -Path "$env:USERPROFILE" -ChildPath "\.cargo\bin\")"  # rust commands
$env:path += ";$(Join-Path -Path "$env:PYENV_HOME" -ChildPath "\versions\$env:GLOBAL_PYTHON_VERSION\scripts\")"  # python scripts
$env:path += ";$(Join-Path -Path "$env:USERPROFILE" -ChildPath "\go\bin\")"  # go commands
$env:path += ";$(Join-Path -Path "$env:POETRY_HOME" -ChildPath "\bin")"  # python poetry
# $env:path += ";$(Join-Path -Path "$env:USERPROFILE" -ChildPath "\AppData\Roaming\npm\")"  # npm
if ($env:DOTFILES_SKIP_YARN -eq $false) {
  $env:path += ";$(yarn global bin)"
}


# set BAT_THEME
$env:BAT_THEME="Dracula"
$env:BAT_PAGER='""'  # don't page BAT results

# vi-edit-mode
# Set-PSReadlineOption -EditMode vi -BellStyle None

# set prompt (via starship)
$env:STARSHIP_CONFIG = "$env:DOTFILES\common\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# load aliases & system-function-definitions
. "$PSScriptRoot\Aliases.ps1"

# will pull every time another machine has pulled (and maybe pushed before)
GitPullOnceADayAndWorkingMachine

# ======================================================

# TODO add script for connecting to wifi-network

# TODO: add-pomodore-timer (https://andrewpla.github.io/A-Toasty-Pomodoro-Timer/)

# TODO: config wsl-linux distributions

# TODO: haxx : highlight every ip-location for every connection on world-map

# TODO: add powershell-history (https://software.intel.com/en-us/blogs/2014/06/17/giving-powershell-a-persistent-history-of-commands)

# ======================================================

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Scoop package manager
$env:SCOOP="$env:USERPROFILE\scoop\"
$env:path += ";$env:SCOOP\apps\scoop\current\bin\;$env:SCOOP\shims\"
