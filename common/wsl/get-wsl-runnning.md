# How-to WSL

1. Activate the WSL features

```powershell
# as admin
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

2. [Linux kernel update package](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

3. Setup

```powershell
wsl --set-default-version 2
```

Example, install debian.

```powershell
curl -L -o debian.appx https://aka.ms/wsl-debian-gnulinux
Add-AppxPackage .\debian.appx
```

```powershell
wsl --list --verbose
```

You might also need [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit)

```powershell
# install the latest release
wsl --import wsl-vpnkit . ./wsl-vpnkit.tar.gz

# run in the foreground
wsl -d wsl-vpnkit --cd /app wsl-vpnkit

# or configure it as a service
# ...
```

DNS might bring some issues if you're in a heavily configured environment (corporate).

```/etc/resolv.conf
# To redirect to the next node (usally your 'host' DNS):
# /etc/resolv.conf ->
# nameserver 1.1.1.1
```

4. Symlink this config to USERPROFILE

```powershell
New-Item -Path "$env:USERPROFILE/.wslconfig" -ItemType SymbolicLink -Value "$env:DOTFILES\common/wsl/.wslconfig"
```

