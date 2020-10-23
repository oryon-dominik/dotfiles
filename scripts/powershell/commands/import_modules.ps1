### imports all custom-added-modules to the powershell-space
### all modules can be installed via the install-scripts

# Chocolatey profile (https://chocolatey.org/)
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Win-EventTail (tails Windows Event Logs) (https://gist.github.com/jeffpatton1971/a908cac57489e6ca59a6)
. $PSScriptRoot\Get-WinEventTail.ps1

# Virtualenvwrapper (https://github.com/regisf/virtualenvwrapper-powershell)
Import-Module $PSScriptRoot\VirtualEnvWrapper.psm1

# POSH-Git (coloured git prompt and auto-complete) (https://github.com/dahlbyk/posh-git/)
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
# posh-docker (docker image autocomplete) (https://github.com/matt9ucci/DockerCompletion)
Import-Module DockerCompletion
# change the Directory-Color (back) to yellow:
$GitPromptSettings.DefaultForegroundColor = "Yellow"
# local branches are ahead and behind - Color
$GitPromptSettings.BranchAheadStatusForegroundColor = "Magenta"
$GitPromptSettings.BranchBehindStatusForegroundColor = "Red"
# bracket colors
$GitPromptSettings.BeforeForegroundColor = "Blue"
$GitPromptSettings.AfterForegroundColor = "Blue"
# branches
$GitPromptSettings.BranchForegroundColor = "Blue"
$GitPromptSettings.BranchGoneStatusForegroundColor = "Blue"
$GitPromptSettings.BranchIdenticalStatusToForegroundColor = "White"
# abbreviate home
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# $GitPromptSettings.DefaultPromptPath

# exclude some repositories from Git prompt, to speed up
$prompt_ignores_paths = Join-Path -Path $env:DOTFILES -ChildPath $settings.git_prompt_ignore
if (Test-Path -Path $prompt_ignores_paths -PathType Leaf) { 
    $ignored_prompts = Get-Content $prompt_ignores_paths
    foreach($prompt_path in $ignored_prompts)
    { 
      $GitPromptSettings.RepositoriesInWhichToDisableFileStatus += $prompt_path
    }
}

# Weather-Script
. $PSScriptRoot\Get-Weather.ps1

# Cli-Pixel-Drawing
. $PSScriptRoot\Write-Pixel.ps1

# sudo
. $PSScriptRoot\sudo.ps1

# ls with Get-ChildItemColor
Import-Module $PSScriptRoot\..\Modules\Get-ChildItemColor
Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
