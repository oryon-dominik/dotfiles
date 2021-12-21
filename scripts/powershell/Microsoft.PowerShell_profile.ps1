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

lolcat $PSScriptRoot\limbs\intro  # print an intro

# Check admin-rights
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

# unlock secrets (conditional)
# TODO: rework to decrypt envs..
# . $PSScriptRoot\commands\unlock_secrets.ps1 -is_elevated $is_elevated

# Initializing dotfiles environment variable, if not already set properly
if (-not (Test-Path env:DOTFILES)) { 
    $dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
    $env:DOTFILES = $dotfiles_location }

# load local settings
. $PSScriptRoot\limbs\read_settings.ps1
# TODO: check for existence of ($settings.dotfiles_location, $settings.cloud, $settings.projects, $settings.shortcuts)
# calculate last update
. $PSScriptRoot\limbs\read_update_log.ps1


# init PROJECTS_DIR, if not set
if (-not (Test-Path env:PROJECTS_DIR)) { $env:PROJECTS_DIR = $settings.projects }

# set powershell variables
$shortcuts = Join-Path -Path $env:DOTFILES -ChildPath $settings.shortcuts
$powershell_location = Join-Path -Path $env:windir -ChildPath '\System32\WindowsPowerShell\v1.0'
$script_location = Join-Path -Path $env:DOTFILES -ChildPath '\scripts'
$file_location = Join-Path -Path $env:DOTFILES -ChildPath '\files'
$console = Join-Path -Path $file_location -ChildPath '\images\console'
$icons = Join-Path -Path $file_location -ChildPath '\icons'

# TODO: load the machines to include from a list or from settings "exclude_from_geo_location_service"
if (-not ($settings.exclude_from_geo_location_service)) {
  # get geolocation from google-API
  . $PSScriptRoot\components\GetDeviceLocation.ps1
}

# Imports all custom-added-modules to the powershell-space
Import-Module DockerCompletion
# Virtualenvwrapper (https://github.com/regisf/virtualenvwrapper-powershell)
Import-Module $PSScriptRoot\externals\VirtualEnvWrapper.psm1
# Upgrades & Update functionality
. $PSScriptRoot\components\Upgrades.ps1
# The Tutorial explaining common commands for this CLI
. $PSScriptRoot\components\CmdTutorial.ps1
# Win-EventTail (tails Windows Event Logs) (https://gist.github.com/jeffpatton1971/a908cac57489e6ca59a6)
. $PSScriptRoot\externals\Get-WinEventTail.ps1
# Weather-Script
. $PSScriptRoot\externals\Get-Weather.ps1
# Metadata for files
. $PSScriptRoot\externals\Get-FileMetaData.ps1
# Cli-Pixel-Drawing
. $PSScriptRoot\externals\Write-Pixel.ps1
# Zoxide Utilities (show with zoxide init powershell)
. $PSScriptRoot\externals\zoxideUtilities.ps1

# load local dotenv
. $PSScriptRoot\LoadDotEnv.ps1 
LoadDotEnv("$env:DOTFILES\.env")

# set prompt (via starship)
$ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\common\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# load aliases & function-definitions
. $PSScriptRoot\limbs\aliases.ps1


# loading custom paths
$env:path += ";$(Join-Path -Path $script_location -ChildPath "\python")"
$env:path += ";$(Join-Path -Path $script_location -ChildPath "\batch")"
$env:path += ";$Env:Programfiles\NASM"  # netwide-assembler
$env:path += ";$(Join-Path -Path $env:USERPROFILE -ChildPath "\.cargo\bin\")"  # rust commands

# vi-edit-mode
# Set-PSReadlineOption -EditMode vi -BellStyle None


# ======================================================

# TODO add script for connecting to wifi-network

# TODO: add-pomodore-timer (https://andrewpla.github.io/A-Toasty-Pomodoro-Timer/)

# TODO: use geolocation for open-weather api

# TODO: config wsl-linux distributions

# TODO: if projects are created with new_project script there should be a name and a lsvirtualenv.. so maybe add a shortcut to it to projects and import that to aliases too

# TODO: haxx : highlight every ip-location for every connection on world-map

# TODO: add powershell-history (https://software.intel.com/en-us/blogs/2014/06/17/giving-powershell-a-persistent-history-of-commands)

# TODO: add a ps-script aliases-structrue that includes all the scripts named as the localhost, so that you load the local-aliases too

# ======================================================

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
