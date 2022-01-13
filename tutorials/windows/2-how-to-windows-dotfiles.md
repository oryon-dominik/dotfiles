# windows-dotfile-environment

> This is about: How-to configure your own dotfile repository

## Prerequisites

If you followed the first tutorial [1-post-installation-windows10](1-post-installation-windows10.md) you're
already set to start with the dotfiles environment. So skip the next paragraph.

Make sure you have installed a [powershell](https://github.com/PowerShell/PowerShell#get-powershell) (This tutorial assumes, youre using `powershell7`), [chocolatey](https://chocolatey.org/) & [git](https://git-scm.com/).

Open an admin-powershell.


## Setup your dotfiles repository

Create a directory for the location you want to install your config to. Then set an environment variable (`$env:DOTFILES`) pointing to it.

```powershell
New-Item -Path "$env:USERPROFILE/.dotfiles" -ItemType Directory -Force
```
```powershell
$env:DOTFILES = Convert-Path "$env:USERPROFILE/.dotfiles"
```
```powershell
[Environment]::SetEnvironmentVariable("DOTFILES", "$env:DOTFILES", "User")
```


Clone | Fork this dotfile git repository to `$env:DOTFILES`.

```powershell
git clone https://github.com/oryon-dominik/dotfiles "$env:DOTFILES"
```

Set the execution policy, to make your scripts executable (You could also
elaborate on that to a script-by-script policy).


```powershell
Set-ExecutionPolicy RemoteSigned
```

Make system links from the cloned powershell profile to both of the generic powershell-profile-folders.  
This will delete the old folders (don't forget to backup your old powershell configs).  

Traditional pre-installed powershell.
```powershell
Remove-Item -Path "$env:USERPROFILE\Documents\WindowsPowerShell" -Recurse -Force;
New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
```
Powershell 7.
```powershell
Remove-Item -Path "$env:USERPROFILE\Documents\PowerShell" -Recurse -Force;
New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
```


Install the additional powershell-modules.

```powershell
refreshenv;
Set-ExecutionPolicy Bypass -Scope Process -Force;
Invoke-Expression "$env:DOTFILES/install/windows/InstallAdditionalPowershellModules.ps1"
```

Install packages neccessary for full features and command-availability of these dotfiles.

```powershell
choco install "$env:DOTFILES/install/windows/choco_cli_enhanced.config"
```


Support for C, Go, Rust Haskell, Java & Dotnet compilers + yarn.

```powershell
choco install "$env:DOTFILES/install/windows/choco_languages.config"
```


The modern unix tools (via rust's package manager `cargo`).

```powershell
refreshenv;
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression "$env:DOTFILES/install/windows/InstallModernUnixForWindows.ps1"
```


Install optional software (If you like, have a look into my essential software packages for everyday work and add them to your system).

```powershell
choco install "$env:DOTFILES/install/windows/choco_development.config";
choco install "$env:DOTFILES/install/windows/choco_security.config";
choco install "$env:DOTFILES/install/windows/choco_google_web.config";
choco install "$env:DOTFILES/install/windows/choco_essential_guis.config";
choco install "$env:DOTFILES/install/windows/choco_media.config";
;refreshenv
```


Now symlink your dotfiles to the installed programs configs. You may get some
elevation errors, depending on your system-config.  
Run the failed lines on an elevated shell again (assuming your user has
elevation privilege, otherwise you have to fix the paths to match the elevated
`$env`).

```powershell
refreshenv;
Set-ExecutionPolicy Bypass -Scope Process -Force;
Invoke-Expression "$env:DOTFILES/install/windows/SymlinkDotfiles.ps1"
```

Touch a dotenv to store your custom environment variables - valid for powershell sessions only.
```powershell
$dotenv_path = (Join-Path -Path "$env:DOTFILES" -ChildPath ".env");
if (!(Test-Path -Path $dotenv_path -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $dotenv_path
}
```


You can also add your dotfiles location to explorers quick-access.

```powershell
(new-object -com shell.application).Namespace("$env:DOTFILES").Self.InvokeVerb("pintohome")
```


Restart your shell.

From here on you should be good to go and use your config, now feel free to
[customize your windows dotfiles](3-customize-windows-dotfiles.md)
and follow the rest of my tutorial.
