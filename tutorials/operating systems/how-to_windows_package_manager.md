# Windows package-management with powershell

> How-to install and configure Windows packages with chocolatey

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

~ @Adminpowershell

```powershell

  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex $env:DEN_ROOT/install/windows/powershell_modules.ps1
  
  choco feature enable -n allowGlobalConfirmation
  choco install $env:DEN_ROOT/install/windows/choco_win10_minimal_developer.config -y
```

or if you've prepared your scripts and previously [dumped your installed windows packages](scripts/python/dump_installed_windows_packages.py)

```powershell
  choco install $env:DEN_ROOT/install/windows/choco_installed_packages_$env:computername.config -y
```

for ms-office:

```powershell
  choco install microsoft-office-deployment -y --params=/64bit /Language de-de /Product ProPlusRetail /Exclude Publisher /Exclude OneDrive /Exclude Outlook /Exclude Lync /Exclude Groove /Exclude Access
```

cygwin-packages:

```powershell
  cyg-get default attr cron shutdown zip coreutils openssl pulseaudio sqlite3 gdb git fzf-vim vim python python3 mutt pylint fish fzf-fish guake lynx nginx xfce irssi bash-completion fzf-bash-completion fzf-fish fish-debuginfo
  # also add all cygwin packages needed for compilation..
```

list the packages installed locally (without '-l'-parameter you get all packages avaiable online):

```powershell
choco list --local-only
#or
choco list -l
```

To also get installed packages outside of choco:

```powershell
choco list -li
```

to update the path variables type:

```powershell
refreshenv
```

to search for a package (e.g notepadplusplus) we list all the packages with that name

```powershell
choco search notepad
```

installing the fitting package (with -y to autoconfirm the installation) we type the full package-name

```powershell
choco install notepadplusplus -y
```

to uninstall any package named <package_name>

```powershell
choco uninstall <package_name> -y
```

package-Commands outside choco:

```powershell
Find-Package  # shows available packages, eg: Find-Package notepad* (on first run the packagemanager nuget gets installed)

Get-PackageSource  # show source

Get-Package -Provider Programs -IncludeWindowsInstaller  # shows installed packages
Install-Package <name>
```
