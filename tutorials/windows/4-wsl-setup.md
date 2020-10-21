# Windows 10 wsl-setup

If you followed the windows tutorials [1-post-installation-windows10](1-post-installation-windows10.md), [2-how-to-windows-dotfiles] and


Enable WSL

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

Set the version to wsl2

    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    wsl.exe --set-default-version 2

Download the kernel-component update for wsl2:

    Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $env:USERPROFILE/Downloads/wsl_update_x64.msi
    Start-Process "msiexec.exe" -ArgumentList "/I $env:USERPROFILE/Downloads/wsl_update_x64.msi /quiet" -Wait -NoNewWindow

Download and install ubuntu-20.04 directly from the Microsoft-Store (recommended), or

    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile $env:USERPROFILE/Downloads/Ubuntu2004.appx -UseBasicParsing
    Add-AppxPackage $env:USERPROFILE/Downloads/Ubuntu2004.appx

    # FIXME: enable dev-mode?!
    Set-ExecutionPolicy Bypass -Scope Process
    $env:USERPROFILE/.dotfiles/scripts/powershell/utils/enable_dev_mode.ps1
    # restart?

Verify the installation

    wsl --list --verbose

Set the default version for wsl

    wsl --set-version Ubuntu-20.04 2

Pin the wsl-mount-point to your explorer quick access

    (new-object -com shell.application).Namespace('\\wsl$\Ubuntu-20.04').Self.InvokeVerb("pintohome")


Activate wsl and setup user and root password

    wsl

You're on a native ubuntu environment now. Time to setup your [ubuntu dotfiles](../ubuntu/1-how-to-ubuntu-dotfiles.md)