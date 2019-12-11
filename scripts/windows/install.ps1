# Hyperten - Windows 10 Enterprise VM
# Installation-Script for hypervised Virtual Machine

# 1. start an elevated powershell
# install powershell 7 preview
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
# set a new hostname and restart
$hostname = "testclient"
Rename-Computer -ComputerName $env:computername -NewName $hostname
Restart-Computer

# 2. start elevated ps7
mkdir ~/.den
$den_loc = Join-Path -Path $home -ChildPath "\.den"
[Environment]::SetEnvironmentVariable("DEN_ROOT", "$den_loc", "User")

mkdir c:\local_projects
$PROJECTS_DIR = "c:\local_projects"
[Environment]::SetEnvironmentVariable("PROJECTS_DIR", "$PROJECTS_DIR", "User")
New-Item $PROFILE -Force

Set-ExecutionPolicy remotesigned
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# 3. reopen elevated shell
choco install git hub -y
refreshenv
git clone https://github.com/oryon-dominik/dotfiles-den $env:DEN_ROOT

$ps_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\WindowsPowerShell'
$ps7_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\PowerShell'
$den_loc = Join-Path -Path $env:DEN_ROOT -ChildPath 'scripts\powershell'
Remove-Item -path $ps_path -recurse
Remove-Item -path $ps7_path -recurse
cmd /c mklink /j ($ps_path) ($den_loc)
cmd /c mklink /j ($ps7_path) ($den_loc)

# create directory structure
mkdir ~/.den/.secrets
mkdir ~/.den/.local/logs/
mkdir ~/.den/.local/shortcuts
New-Item ~/.den/.local/logs/updates.log
New-Item ~/.den/scripts/powershell/limbs/locations.ps1
New-Item ~/.den/scripts/powershell/limbs/projects.ps1

# install programms
choco feature enable -n allowGlobalConfirmation
choco install python vscode vscode-insiders less get-childitemcolor vim poshgit wsl firefox

refreshenv

New-Item ~/.den/local/env_settings.json
Add-Content ~/.den/local/env_settings.json "{`n    `"den_location`": `".den`",`n    `"cloud`": `"C:\\local_projects`",`n    `"projects`": `"C:\\local_projects`",`n    `"heap`": `"C:\\local_projects`",`n    `"shortcuts`": `".local\\shortcuts`",`n    `"residence`": [`"Alamo`", `"US`"],`n    `"coordinates`": [37.234332396, -115.80666344],`n    `"files_url`": `"https://github.com/oryon-dominik/files`",`n    `"files_location`": `"files`"`n}"

# install the required powershell modules
Install-Module -Name PowerShellGet -verbose
Install-Module -Name PSWindowsUpdate -verbose
Install-Module -Name PowerBash -verbose
Install-Module Find-String -verbose
Install-Module DockerCompletion -verbose
Install-Module PSReadLine -AllowPrerelease -Force -verbose
Install-Module -Name Get-ChildItemColor -AllowClobber -verbose
# will take a while:
Install-Package System.ServiceProcess.ServiceController -verbose

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
