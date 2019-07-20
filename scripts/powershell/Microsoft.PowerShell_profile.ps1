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

. $PSScriptRoot\limbs\intro.ps1  # load the intro

# check admin-rights
$is_admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

# unlock secrets (conditional)
. $PSScriptRoot\commands\unlock_secrets.ps1 -is_admin $is_admin

# initializing DEN-root environment variable, if not already set properly
if (-not (Test-Path env:DEN_ROOT)) { 
    $den_loc = Join-Path -Path $home -ChildPath "\!den"
    $env:DEN_ROOT = $den_loc }

# load local settings
. $PSScriptRoot\limbs\read_settings.ps1
# TODO: check for existence of ($settings.den_location, $settings.cloud, $settings.projects, $settings.shortcuts)

# init PROJECTS_DIR, if not set
if (-not (Test-Path env:PROJECTS_DIR)) { $env:PROJECTS_DIR = $settings.projects }

# set powershell variables
$shortcuts = Join-Path -Path $env:DEN_ROOT -ChildPath $settings.shortcuts
$powershell_location = Join-Path -Path $env:windir -ChildPath '\System32\WindowsPowerShell\v1.0'
$script_location = Join-Path -Path $env:DEN_ROOT -ChildPath '\scripts'
$file_location = Join-Path -Path $env:DEN_ROOT -ChildPath '\files'
$console = Join-Path -Path $file_location -ChildPath '\images\console'
$icons = Join-Path -Path $file_location -ChildPath '\icons'

# set geolocation from google-API
. $PSScriptRoot\commands\device_location.ps1

# import modules
. $PSScriptRoot\commands\import_modules.ps1

# set prompt
. $PSScriptRoot\limbs\prompt.ps1

# load aliases & function-definitions
. $PSScriptRoot\limbs\aliases.ps1

# loading custom paths
$env:path += Join-Path -Path $script_location -ChildPath "\python"
$env:path += Join-Path -Path $script_location -ChildPath "\batch"
$env:path += ";C:\Program Files\NASM"  # netwide-assembler

# powershell-error-colors
$host.PrivateData.ErrorForegroundColor = "DarkRed"
$host.PrivateData.ErrorBackgroundColor = "White"

# vi-edit-mode
Set-PSReadlineOption -EditMode vi -BellStyle None


# ======================================================

# TODO add script for connecting to wifi-network

# TODO: add-pomodore-timer (https://andrewpla.github.io/A-Toasty-Pomodoro-Timer/)

# TODO: use geolocation for open-weather api

# TODO: add check for last upgrade (logged in .local/logs/updates.log) and recommend upgrade if too long ago

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
