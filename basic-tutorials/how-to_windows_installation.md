# Windows dotfiles

> How-to install and configure Windows and its settings with powershell-scripts & [chocolaty](https://chocolatey.org/) packages

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#markdown-header-preparations)
- [Installation](#markdown-header-installation)

---

## TODOS

ATTENTION: this "guide" is completely personal. It is for my own use, my own notes for my own installation.
It is absolutely out of date (because I will actualize it only every couple of years, when I have to reinstall something).
It may not work for you, there may be nonsense steps, things you don't like or even find absolutely disgusting. Feel free to use it as your guide too, but don't blame me if something goes terribly wrong!

the level automation ist still very low, there is much to do.. this will take time or worse: maybe never be complete, don't wait for it.

TODO: complete how to install Windows
TODO: write python script schreiben, to change the colors of virtualenvwerpaper
  `<user>\Envs\<cast>\Scripts\Activate.ps1`
  -> Line 38: `Write-Host -NoNewline -ForegroundColor Green '(cast) '` change it to whatever you like, green is not my favourite
  TODO: add DNS: 46.182.19.48 (https://digitalcourage.de/support/zensurfreier-dns-server)
  212.82.226.212 (https://www.ccc.de/de/censorship/dns-howto)
  
  if something doesnt work: google-dns: 8.8.8.8 or 8.8.4.4

## Preparations

To prepare your windows-installation

- Fork the repo using [hub](https://github.com/github/hub) (`git clone <url>`) switch to the directory and `git fork` it
- Customize the Environment-Variables in `.env.example` and save them as `.env`
- Create a list of your installed vscode extensions in `settings/programs/vscode` with:  `code.cmd --list-extensions > extensions.list`
- Commit the changes to your fork

## Installation

Windows 10 TODO:

install Windows from medium, (offline-account!)

TODO: get the install script and the repo from url
      start the script

TODO: create the script from commands below

TODO: implement all the small steps into an automatically running script

1. Set environment-variables (or get 'em from repo :P):

    - $hostname = the name of your machine
    - $den_loc = Join-Path -Path $home -ChildPath "\!den"
    - [Environment]::SetEnvironmentVariable("DEN_ROOT", "$den_loc", "User")

```powershell
Rename-Computer -ComputerName $env:computername -NewName $hostname
```

reboot!

(TODO: script a workflow, that sets everything up in place..) [like so](https://stackoverflow.com/questions/15166839/powershell-reboot-and-continue-script)

if you forgot to choose "offline-account" at installation:
TODO: set a global env over all users for the - $old_username from `$env:UserName`

```powershell
$username = "your user name"
$admin_group_name = "Administratoren"  # attention, localized groupnames!!
Write-Host "Enter a new password for your User ($username): "
$password = Read-Host -AsSecureString
New-LocalUser $username -Password $password
Add-LocalGroupMember -Group $admin_group_name -Member $username
```

TODO: script reboot log into new user_account..

TODO: script:

- delete the old_user and its files & folders
  `Remove-LocalUser -Name $old_username`
- delete the global env for $old_username

TODO: choose a more secure user-management-system

Then install [chocolatey](https://chocolatey.org/)

```powershell
cd ~
set-ExecutionPolicy remotesigned
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

`choco feature enable -n allowGlobalConfirmation`

Clone the repo.

choco install

cmder
google-drive-file-stream
googlechrome
powershell
powershell-core
python
vscode
less
get-childitemcolor
vim
git
poshgit
hub
wsl
vlc '/Language:de'

Choose the config for cmder from the repo.

Remove the built-in apps manually or use the script

```powershell
$ Get-AppXPackage | Select-Object Name
# Get-AppXPackage *<name>* | Remove-AppXPackage
```

TODO: set script to use "DEN_ROOT"

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex !den/install/windows/remove_unwantedClutter.ps1
```

set the explorer settings from your choices in the script

```powershell
. $dotfile_path/install/windows/explorer_settings.ps1
ShowFileExtensions
ShowHiddenFiles
DeactivateAutoCheckSelect
ForceExplorerRestart
```

Install Modules

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex !den/install/windows/powershell_modules.ps1
```

For a full install: install all packages from a proper set-up xml

```powershell
choco feature enable -n allowGlobalConfirmation
choco install !den\install\windows\choco_win10_install.config -y

choco install microsoft-office-deployment -y --params=/64bit /Language de-de /Product ProPlusRetail /Exclude Publisher /Exclude OneDrive /Exclude Outlook /Exclude Lync /Exclude Groove /Exclude Access
  
refreshenv
```

Dump file with processes from fresh_install
TODO: implement: optional: setup OEM Information

```powershell
tasklist > ~/!den/logs/processes_fresh_install.txt
```

Create a Junction link for your Powershell-Settings & the cloud (googledrive for me):

`cmd /c mklink /j "C:\Users\<username>\Documents\WindowsPowerShell" "C:\Users\<username>\!den\scripts\powershell"`
`cmd /c mklink /j C:\<cloud> "x:\<cloud>"`

TODO: Install updates (you can do that with the corresponding choco module too)

Add your files-den to the repo.

o&o shutup (OOSU10 in Software / files-den [you have to find it yourself..]) import .cfg-file to deactivate telemetry

customize privacy-rules (Settings/privacyrules)
 already included: registry -> LOCAL_MACHINE/SOFTWARE/Policies/Microsoft/Windows/DataCollection | Neuer DWORD-Wert (32 Bit) "AllowTelemetry" | wert = 0
 already included: cortana deactivate

TODO: get the commands or reg-entries for all these steps

```powershell

configure virtual memory (sysdm.cpl)
configure Settings\System\Notifications & Actions

deactivate startmenu proposals
delete preinstalled apps

change systemname

check devicemanager driver: devmgmt.msc
copnfigure maintenance-center: wscui.cpl

deactivate trashbin

correct drive-letters

preconfigure quick-access, taskbar and systembar

delete windows.old (if present on c:)
Memory - Run Disk Cleanup

---
install drivers

set chrome as standard-app & google search // define standardapps (npp-editor, imageview etc..)
change password-manager

configure path [git\bin to path (C:\Program Files\Git\bin) etc]

assign sounds theme

$ tasklist > processes_progs_install.txt  # dump file with processes

!IMAGE!

HKEY_CURRENT_USER -> Control Panel -> Desktop | "Neu" und "Zeichenfolge" | WaitToKillAppTimeOut | integer Wert, siehe oben (zB 2500)
                                                                            "HungAppTimeout" auf den wert s.o
                                                                            "AutoEndTasks" auf 1

set system-restore-point

install remaining software
install npp-plugin compare

setup vnc + mediaserver
check context-menu entries (vscode, notepad++ 7zip)
new-files for word-docs and .py(vscode)

install all vscode-extensions :
$ code.cmd --install-extension <extension-name>


configure chrome profile / firefox profile
configure thunderbird + addons

setup desktop

change dns: (whats the name of my net?: netsh interface show interface) (Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "46.182.19.48","212.82.226.212")

create ssh-keys for Version-Control
$ ssh-keygen -t rsa -C “email-address”
(copy& paste path + _UNIQUE_IDENTIFIER) // passphrase or no passphrase is up to you
copy public-key, eg: notepad ~/.ssh/id_rsa_GITHUB.pub
and set it up under github: settings (on the homepage, online) -> ssh-keys new ssh-key (titel eg: Desktop-Windows10-vscode)

remove double poshgit entry from powershell profile (is in after choco install 2x) and in Git-prompt-ps1 (c:\tools\poshgit\...\src\) change the Color:

control sheduled tasks in "C:\Windows\System32\Tasks" and in registry under "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree"

shedule cmder start with powershell script "shedule_tasks_once.ps1" (control if it really ran) [BUG: executing script was not enough, execute the code itself in powershell worked though]
maybe set script-policies temporarily?!) and remove that from autostart (look that up!) TODO

$ tasklist > processes_full_install.txt  # dump file with processes info again

create a backup for the local settings in a directory of your choice

$ set TODAY=%DATE:~4,2%-%DATE:~7,2%-%DATE:~10,4%
$ regedit /e "%CD%\user_env_variables[%TODAY%].reg" "HKEY_CURRENT_USER\Environment"
$ regedit /e "%CD%\global_env_variables[%TODAY%].reg" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

set system-restore-point
========READY=======================

(forgot Filemneu-Tools ?)

install netflix, pocketcast from the Store.. or via powershell (still form the store) TODO: add to script

$ Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
(or: choco install wsl)


```
