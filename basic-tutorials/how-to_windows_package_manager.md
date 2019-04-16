# Windows package-management with powershell

> How-to install and configure Windows packages with chocolatey

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

```powershell

~ @Adminpowershell

  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex $env:DEN_ROOT/install/windows/powershell_modules.ps1
  
  choco feature enable -n allowGlobalConfirmation
  choco install ~\.config\install\windows\choco_win10_install.config -y

  # office
  choco install microsoft-office-deployment -y --params=/64bit /Language de-de /Product ProPlusRetail /Exclude Publisher /Exclude OneDrive /Exclude Outlook /Exclude Lync /Exclude Groove /Exclude Access
  
  # add the cygwin-packages
  cyg-get default attr cron shutdown zip coreutils openssl pulseaudio sqlite3 gdb git fzf-vim vim python python3 mutt pylint fish fzf-fish guake lynx nginx xfce irssi bash-completion fzf-bash-completion fzf-fish fish-debuginfo

  # list the packages installed locally (without '-l'-parameter you get all packages avaiable online):
  choco list -l

  # to update the path variables type:
  refreshenv

  =====GENERAL INSTRUCTION==========================================
  # to search for a package (e.g notepadplusplus) we list all the packages with that name
  choco search notepad

  # installing the fitting package (with -y to autoconfirm the installation) we type the full package-name
  choco install notepadplusplus -y

  # to uninstall any package named <package_name>
  choco uninstall <package_name> -y

  =====Other powershell package-Commands===
  # Find-Package  # first run packagemanager nuget gets installed// shows available packages, eg: Find-Package notepad*
  # Get-PackageSource  # show source
  # Get-Package -Provider Programs -IncludeWindowsInstaller  # shows instgalled packages
  # Install-Package <name>

```
