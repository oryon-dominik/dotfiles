#!/usr/bin/env pwsh
# Powershell-profile oryon-dominik (c) since 2019                             #
#                                       `                                     #
#                                      y.                                     #
#                               `:.`.:ymh                                     #
#                            `o  /mmmmmmm-                                    #
#                        -//+hm:  dmmmmmm+                                    #
#                        `hmmmmy  smmmmmm+                                    #
#                         ommmmy  smmmmmm-                                    #
#                         smmmm+ `dmmmmmh                                     #
#                        .dmmmh` ommmmmd-                                     #
#                       `ymmmh- +dmmmmd:                                      #
#                      :hmmms.`sdmmmmy.                                       #
#   `..             ./ydmds-.+hmmmmh/`                                        #
#     `:/::--..-:/oyddhs/-/sdmmmdy:`                                          #
#        ./+sssssoo++/+shdmmmhs/`                                             #
#            .:/ossyyyyss+/-`                                                 #
#                ``````                                                       #

# ! Order matters.

# Set default encoding to UTF8
$PSDefaultParameterValues = @{'*:Encoding' = 'utf8'}
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Initializing dotfiles environment variable, if not already set properly.
if (-not (Test-Path $env:DOTFILES)) { 
  $dotfiles_location = Join-Path -Path $home -ChildPath "\.dotfiles"
  $env:DOTFILES = $dotfiles_location
}

# HISTFILE, used by PSReadLine and McFly
$env:HISTFILE = "$env:DOTFILES\.history"
if (-not (Test-Path $env:HISTFILE)) {
    # History doesn't exist, so create it
    New-Item -ItemType File -Path $env:HISTFILE -Force
}

. "$PSScriptRoot\components\EntryPanel.ps1"
Greet

# Set BAT_THEME
$env:BAT_THEME="Dracula"
$env:BAT_PAGER='""'  # don't page BAT results

# Load local dotenv.
Import-Module "$PSScriptRoot\components\DotEnvs.ps1"
LoadDotEnv("$env:DOTFILES\.env")

# Scoop package manager.
$env:SCOOP="$env:USERPROFILE\scoop\"

# Set powershell variables.
$shortcuts = Join-Path -Path "$env:DOTFILES" -ChildPath "\shared\shortcuts"
$script_location = Join-Path -Path "$env:DOTFILES" -ChildPath '\scripts'
$file_location = Join-Path -Path "$env:DOTFILES" -ChildPath '\shared\files'
$console = Join-Path -Path "$file_location" -ChildPath '\images\console'
$icons = Join-Path -Path "$file_location" -ChildPath '\icons'

# Add custom paths.
. "$PSScriptRoot\Paths.ps1"

# Calculate last update.
Import-Module "$PSScriptRoot\components\upgrades\ReadUpdateLog.ps1"
# Get device location.
. "$PSScriptRoot\components\GetDeviceLocation.ps1"
# Imports all custom-added-modules to the powershell-space.
Import-Module DockerCompletion
# Virtualenvwrapper bindings
$env:WORKON_HOME = "$env:USERPROFILE\$env:GLOBAL_PYTHON_VENVS"
Import-Module "$PSScriptRoot\components\SlimVenvWrapper.ps1"
# Upgrades & Update functionality
Import-Module "$PSScriptRoot\components\upgrades\Upgrades.ps1"
# Win-EventTail (tails Windows Event Logs) (https://gist.github.com/jeffpatton1971/a908cac57489e6ca59a6)
Import-Module "$PSScriptRoot\ModulesInVersionControl\Get-WinEventTail.ps1"
# Weather-Script
Import-Module "$PSScriptRoot\ModulesInVersionControl\Get-Weather.ps1"
# Metadata for files
Import-Module "$PSScriptRoot\ModulesInVersionControl\Get-FileMetaData.ps1"
# Thefuck is a command line tool for automatically correcting commands
Import-Module "$PSScriptRoot\components\TheFuck.ps1"
# Converting line endings from Windows to Unix
Import-Module "$PSScriptRoot\components\ConvertLineEndings.ps1"
# Be able to reset your powershell session.
Import-Module "$PSScriptRoot\components\ResetSession.ps1"
# Pull the repositories to avoid merge conflicts every single day..
Import-Module "$PSScriptRoot\components\GitPullHelpers.ps1"
# PSReadLine provides fish-like auto-suggestions, included in powershell since 7.2
. "$PSScriptRoot\components\PSReadLineOptions.ps1"
# PSFzfOptions provides an fzf interface for better path completion
. "$PSScriptRoot\components\PSFzFOptions.ps1"
Import-Module -Name CompletionPredictor
# McFly - reverse fuzzy search
if ($env:MCFLY_ISACTIVE -eq $true) {
  . "$PSScriptRoot\components\Mcfly.ps1"
}
# Zoxide Utilities (show with zoxide init powershell)
. "$PSScriptRoot\ModulesInVersionControl\zoxideUtilities.ps1"
# Broot directory tree navigation https://github.com/Canop/broot/
. "$PSScriptRoot\components\BrootWrapper.ps1"
# Gsudo to implement a sudo command in ps.
Import-Module gsudoModule

# vi-edit-mode
# Set-PSReadlineOption -EditMode vi -BellStyle None

# Set prompt (via starship)
$env:STARSHIP_CONFIG = "$env:DOTFILES\common\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# load aliases & system-function-definitions
. "$PSScriptRoot\Aliases.ps1"
. "$PSScriptRoot\components\FixYarnBehaviourWithoutArgs.ps1"

# Read the update log and inform if necessary.
ReadUpdateLog
# Will pull every time another machine has pulled (and maybe pushed before).
GitPullOnceADayAndWorkingMachine

# ====================================================

# BUG: tilde does not expand in pwsh > 7.4
# https://github.com/PowerShell/PowerShell/issues/20750
# Workaround by injecting a patched TabExpansion2 function
# from this gist https://gist.github.com/jhoneill/322a77199350c76a5785f5406ea97bac
# by jhoneill [James O'Neill](https://twitter.com/jamesoneill)
. "$PSScriptRoot\Bugfixes.ps1"

# ====================================================

# TODO: config wsl-linux distributions
# TODO: haxx : highlight every ip-location for every connection on world-map (via pihole!)

# ======================================================

# ! DeprecationWarning
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
