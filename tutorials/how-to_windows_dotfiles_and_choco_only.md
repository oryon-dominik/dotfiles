# windows-dotfile-environment

Install powershell 7, start it and set a new profile

```powershell
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
New-Item $PROFILE -Force
```

Set environment-variables (or get 'em from repo :P):

- $hostname = the name of your machine
- $dotfile_location = the path to your dotfiles ('\_dotfiles')
- `$den_loc = Join-Path -Path $home -ChildPath "$dotfile_location"`
- `[Environment]::SetEnvironmentVariable("DEN_ROOT", "$den_loc", "User")`

```powershell
Rename-Computer -ComputerName $env:computername -NewName $hostname
```

Then install [chocolatey](https://chocolatey.org/)

```powershell
cd ~
set-ExecutionPolicy remotesigned
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

And the packages you want

```powershell
choco feature enable -n allowGlobalConfirmation
choco install ~\.config\install\windows\choco_win10_minimal_developer.config
```

Refresh the environment variables with `refreshenv`

Clone the repo `git clone https://github.com/oryon-dominik/dotfiles-den $env:DEN_ROOT`.

Set settings `env_settings.json` in `local`:

```powershell
$env_settings = "\local\env_settings.json"
$settings_path = Join-Path -Path $env:DEN_ROOT -ChildPath $env_settings
$settings = Get-Content -Raw -Path $settings_path | ConvertFrom-Json
```

Create the missing-files

```powershell
New-Item -ItemType file $ENV:DEN_ROOT/local/logs/$env:computername/updates.log
New-Item -ItemType file "$ENV:DEN_ROOT/scripts/powershell/machines/$hostname.ps1"
New-Item -ItemType file $ENV:DEN_ROOT/scripts/powershell/limbs/locations.ps1
New-Item -ItemType file $ENV:DEN_ROOT/scripts/powershell/limbs/projects.ps1
```

Install Modules

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression $env:DEN_ROOT/install/windows/powershell_modules.ps1
```

Make system links

```powershell
`cmd /c mklink /j "C:\Users\<username>\Documents\WindowsPowerShell" "$env:DEN_ROOT\scripts\powershell"`

# for powershell 7:
`cmd /c mklink /j "C:\Users\<username>\Documents\PowerShell" "$env:DEN_ROOT\scripts\powershell"`

# your cloud:
`cmd /c mklink /j C:\<cloud> "$settings.cloud"`
```
