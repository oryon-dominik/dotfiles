# Hyperten - Windows 10 Enterprise VM
# Installation-Script for hypervised Virtual Machine

# 1. start an elevated powershell
# install powershell 7 preview
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
# set a new hostname and restart
$hostname = "testclient"
Rename-Computer -ComputerName $env:computername -NewName $hostname
Restart-Computer

# 2. start elevated ps7
mkdir ~/.dotfiles
$den_loc = Join-Path -Path $home -ChildPath "\.dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES", "$den_loc", "User")

mkdir c:\local_projects
$PROJECTS_DIR = "c:\local_projects"
[Environment]::SetEnvironmentVariable("PROJECTS_DIR", "$PROJECTS_DIR", "User")
New-Item $PROFILE -Force

Set-ExecutionPolicy remotesigned
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# 3. reopen elevated shell
choco install git hub -y
refreshenv
git clone https://github.com/oryon-dominik/dotfiles-den $env:DOTFILES

$ps_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\WindowsPowerShell'
$ps7_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\PowerShell'
$den_loc = Join-Path -Path $env:DOTFILES -ChildPath 'scripts\powershell'
Remove-Item -path $ps_path -recurse
Remove-Item -path $ps7_path -recurse
cmd /c mklink /j ($ps_path) ($den_loc)
cmd /c mklink /j ($ps7_path) ($den_loc)

# create directory structure
# local may be a suprepository too!
mkdir ~/.dotfiles/local/.secrets
mkdir ~/.dotfiles/local/logs/$env:computername
mkdir ~/.dotfiles/local/shortcuts
New-Item ~/.dotfiles/local/logs/updates.log
New-Item ~/.dotfiles/scripts/powershell/limbs/locations.ps1
New-Item ~/.dotfiles/scripts/powershell/limbs/projects.ps1

# install programms
choco feature enable -n allowGlobalConfirmation
choco install python vscode vscode-insiders less get-childitemcolor vim poshgit wsl firefox

refreshenv

New-Item ~/.dotfiles/local/env_settings.json
Add-Content ~/.dotfiles/local/env_settings.json "{`n    `"dotfiles_location`": `".dotfiles`",`n    `"cloud`": `"C:\\local_projects`",`n    `"projects`": `"C:\\local_projects`",`n    `"heap`": `"C:\\local_projects`",`n    `"shortcuts`": `"local\\shortcuts`",`n    `"residence`": [`"Alamo`", `"US`"],`n    `"coordinates`": [37.234332396, -115.80666344],`n    `"files_url`": `"https://github.com/oryon-dominik/files`",`n    `"files_location`": `"files`"`n}"

# install the required powershell modules
Install-Module -Name PowerShellGet
Install-Module -Name PSWindowsUpdate
Install-Module -Name PSPuTTY
Install-Module -Name PSnmap
Install-Module -Name PowerBash
Install-Module Find-String
Install-Module psgoogle
Install-Module DockerCompletion
Install-Module PSReadLine -AllowPrerelease -Force
Install-Module -Name Get-ChildItemColor -AllowClobber
Install-Module -Name lolcat
# needed for window-update to work correctly:
# will take a while:
# Install-Package System.ServiceProcess.ServiceController

Install-Script -Name Speedtest

refreshenv

# 4. sync vscode settings (extension: settings-sync: login to github and select the gist) -> shift+alt+d
#    restart vscode

# 5. remove double poshgit entry from last line of powershell profile (it is 2x after the choco install)

# 6 install visual studio with all dependencies
choco install visualstudio2017community # <-- customize installation

# 7. meanwhile style your taskbar, desktop and color-theme (#861a22). 
#    Deactivate sounds.
#    Set file extensions-view and hidden files for explorer


# 8. locations example: 
# function cloud { set-location $settings.cloud }
# function dev { set-location (Join-Path -Path $settings.cloud -ChildPath '\Development\Python') }

# 9. projects example
#   function pi {
# 	set-location (Join-Path -Path $env:PROJECTS_DIR -ChildPath '\raspi')
# 	workon raspberry
# 	code raspi.code-workspace
# 	ssh pi@111.111.1.11
#  }
# function df {
# 	set-location (Join-Path -Path $settings.heap -ChildPath '\project1')
# 	workon project1
#  }

# Done :)
