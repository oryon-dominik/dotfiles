#!/usr/bin/env pwsh


function InstallAdditionalPowershellModules {

    $installed = @()
    # TODO: add check for elevated powershell
    # TODO: add installed to list
    # Elevated powershell
    # $is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    # if (!$is_elevated) { Write-Host "Can't install additional powershell modules as unprivileged user."; return }

    Write-Host "Installing additional powershell modules..."

    # TBD: also install via scoop?
    # scoop install main/nuget
    # scoop install extras/dockercompletion

    # Install prerequisite NuGet
    Install-PackageProvider -Name NuGet -Force

    # Enforce TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    # PowerShellGet is the package manager for PowerShell. https://github.com/PowerShell/PowerShellGet
    Install-Module -Name PowerShellGet -Force

    # Windows Updatges via Powershell. https://www.powershellgallery.com/packages/PSWindowsUpdate
    Install-Module -Name PSWindowsUpdate -Force

    # Run Linux programs directly from PowerShell. https://github.com/jimmehc/PowerBash
    Install-Module -Name PowerBash -Force

    # Docker command completion for PowerShell. https://github.com/matt9ucci/DockerCompletion
    Install-Module -Name DockerCompletion -Force

    # WSL-Commands natively bound to PowerShell https://github.com/mikebattista/PowerShell-WSL-Interop#usage
    Install-Module WslInterop

    # PSReadLine provides fish-like auto-suggestions, included in powershell since 7.2, we need a version >= 2.2.6
    # PSReadLine 2.2.2 extends the power of Predictive IntelliSense by adding support for plug-in modules that use advanced logic to provide suggestions for full commands. The latest version, PSReadLine 2.2.6, enables predictions by default.
    # Using Predictive IntelliSense
    # https://docs.microsoft.com/de-de/powershell/module/psreadline/about/about_psreadline?view=powershell-7.2
    Install-Module -Name PSReadLine -AllowPrerelease -Force

    # To enable PowerShell command line auto-completion plugin for the
    # PSReadLine Predictive Intellisense feature:
    Enable-ExperimentalFeature PSSubsystemPluginMode
    # https://github.com/PowerShell/CompletionPredictor
    Install-Module -Name CompletionPredictor -Repository PSGallery -Force

    return $installed
}
