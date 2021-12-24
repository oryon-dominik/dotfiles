# Windows 10 post-installation

Open an admin-powershell.

Install powershell 7, start it and set a new profile

```powershell
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
```

Then install [chocolatey](https://chocolatey.org/)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
```

Install git via chocolatey.

```powershell
    refreshenv
    choco install git
```

Set up your `ssh-key`.

```powershell
    mkdir $env:USERPROFILE/.ssh/
    ssh-keygen -t rsa -C "A comment of your choice" -f $env:USERPROFILE/.ssh/id_rsa
```

(Optional) Set a new [hostname](http://seriss.com/people/erco/unixtools/hostnames.html)

```powershell
Rename-Computer -ComputerName $env:computername -NewName "enceladus"
```

Reboot, [setup dotfiles](2-how-to-windows-dotfiles.md).
