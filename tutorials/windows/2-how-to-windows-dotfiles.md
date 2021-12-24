# windows-dotfile-environment

> This is about: How-to configure your own dotfile repository

## Prerequisites

If you followed the first tutorial [1-post-installation-windows10](1-post-installation-windows10.md) you're
already set to start with the dotfiles environment. So skip the next paragraph.

Make sure you have installed a [powershell](https://github.com/PowerShell/PowerShell#get-powershell) (This tutorial assumes, youre using `powershell7`), [chocolatey](https://chocolatey.org/) & [git](https://git-scm.com/).

Open an admin-powershell.

## Setup your dotfiles repository

Set an environment variable (`$env:DOTFILES`) to the location you want to install your config to. 

```powershell
$env:DOTFILES = Convert-Path "$env:USERPROFILE/.dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES", "$env:DOTFILES", "User")
```

Clone | Fork | Create a dotfile repo into `$env:DOTFILES`.

```powershell
git clone https://github.com/oryon-dominik/dotfiles $env:DOTFILES
```

Set the execution policy, to make your scripts executable. (You could also
elaborate on that to a script-by-script policy)
```powershell
Set-ExecutionPolicy RemoteSigned
```

Make system links from the cloned powershell profile to the generic powershell-profile-folders.
This will delete the old folders (don't forget to backup your old powershell configs).

```powershell
Remove-Item -path "$env:USERPROFILE\Documents\WindowsPowerShell" -recurse
mkdir "$env:USERPROFILE/Documents/WindowsPowerShell"
New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/scripts/powershell"

# for powershell 7:
Remove-Item -path "$env:USERPROFILE\Documents\PowerShell" -recurse
mkdir "$env:USERPROFILE/Documents/PowerShell"
New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/scripts/powershell"
```

Install the additional powershell-modules. 

```powershell
refreshenv
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression $env:DOTFILES/install/windows/additional_powershell_modules.ps1
choco install $env:DOTFILES/install/windows/choco_development.config
choco install $env:DOTFILES/install/windows/choco_cli_enhanced.config
choco install $env:DOTFILES/install/windows/choco_languages.config
refreshenv
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression $env:DOTFILES/install/windows/modern_unix_for_windows.ps1

# optional (If you like add essential software for your everyday work)
choco install $env:DOTFILES/install/windows/choco_web.config
choco install $env:DOTFILES/install/windows/choco_essentials.config
choco install $env:DOTFILES/install/windows/choco_media.config
choco install $env:DOTFILES/install/windows/choco_security.config
refreshenv
```


You can also add your dotfiles location to explorers quick-access.

```powershell
(new-object -com shell.application).Namespace("$env:DOTFILES").Self.InvokeVerb("pintohome")
```

Restart your shell.

From here on you should be good to go and use your config, feel free to [customize your windows dotfiles](3-customize-windows-dotfiles.md)
and follow the rest of my tutorial.
