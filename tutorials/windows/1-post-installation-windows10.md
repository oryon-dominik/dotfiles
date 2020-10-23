# Windows 10 post-installation

Open an admin-shell.

Install powershell 7, start it and set a new profile

```powershell
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
New-Item $PROFILE -Force
```

(Optional) Set a new [hostname](http://seriss.com/people/erco/unixtools/hostnames.html)

```powershell
Rename-Computer -ComputerName $env:computername -NewName "enceladus"
```

Then install [chocolatey](https://chocolatey.org/)

```powershell
cd ~
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
```

Install git, hub and poshgit via chocolatey.

```powershell
    refreshenv
    choco install git hub poshgit
```

Set up your `ssh-key`.

```powershell
    mkdir $env:USERPROFILE/.ssh/
    ssh-keygen -t rsa -C "A comment of your choice" -f $env:USERPROFILE/.ssh/id_rsa
```

Set up your `git config`.

```powershell
    git config --global user.name "Your Name"
    git config --global user.email "your_email@address.domain"
    git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa"
    git config --global core.autocrlf "input"
```

~~More on git in my [git-repo-tutorial](how-to_init_a_git_repo.md#preparations).~~

Continue with [installing the dotfiles from this repo](2-how-to-windows-dotfiles.md)

Reboot, setup dotfiles.
