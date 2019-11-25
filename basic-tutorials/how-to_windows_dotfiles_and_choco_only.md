# windows-dotfile-environment

Install powershell 7, start it and set a new profile

```powershell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
New-Item $PROFILE -Force
```

1. Set environment-variables (or get 'em from repo :P):

    - $hostname = the name of your machine
    - $den_loc = Join-Path -Path $home -ChildPath "\!den"
    - [Environment]::SetEnvironmentVariable("DEN_ROOT", "$den_loc", "User")

```powershell
Rename-Computer -ComputerName $env:computername -NewName $hostname
```

Then install [chocolatey](https://chocolatey.org/)

```powershell
cd ~
set-ExecutionPolicy remotesigned
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

`choco feature enable -n allowGlobalConfirmation`

choco install

```powershell
cmder
googlechrome
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
```

refreshenv

Clone the repo.
Set settings `env_settings.json` in `.local`

Install Modules

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex !den/install/windows/powershell_modules.ps1
```

`cmd /c mklink /j "C:\Users\<username>\Documents\WindowsPowerShell" "C:\Users\<username>\!den\scripts\powershell"`

for powershell 7:
`cmd /c mklink /j "C:\Users\<username>\Documents\PowerShell" "C:\Users\<username>\!den\scripts\powershell"`
`cmd /c mklink /j C:\<cloud> "x:\<cloud>"`
