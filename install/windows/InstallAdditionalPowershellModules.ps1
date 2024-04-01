#!/usr/bin/env pwsh


function InstallAdditionalPowershellModules {

    $installed = @()

    # $admin = isadmin
    # if (!$admin ) {
    #     # TODO: check if elevated powershell is required at all.
    #     Write-Host "Can't install powershell modules as unprivileged user? I don't know yet. Check it out."
    #     # return $installed
    # }
    # TODO: add installed to list

    Write-Host "Installing additional powershell modules..."

    # Install prerequisite NuGet
    scoop install main/nuget
    # Install-PackageProvider -Name NuGet -Force
    $installed += "nuget"

    # Enforce TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    # PowerShellGet is the package manager for PowerShell. https://github.com/PowerShell/PowerShellGet
    Install-Module -Name PowerShellGet -Force -ErrorAction SilentlyContinue
    $installed += "PowerShellGet"

    # Windows Updates via Powershell. https://www.powershellgallery.com/packages/PSWindowsUpdate
    Install-Module -Name PSWindowsUpdate -Force -ErrorAction SilentlyContinue
    $installed += "PSWindowsUpdate"

    # Run Linux programs directly from PowerShell. https://github.com/jimmehc/PowerBash
    Install-Module -Name PowerBash -Force -ErrorAction SilentlyContinue
    $installed += "PowerBash"

    # Docker command completion for PowerShell. https://github.com/matt9ucci/DockerCompletion
    scoop install extras/dockercompletion
    # Install-Module -Name DockerCompletion -Force

    # WSL-Commands natively bound to PowerShell https://github.com/mikebattista/PowerShell-WSL-Interop#usage
    Install-Module WslInterop -ErrorAction SilentlyContinue
    $installed += "WslInterop"

    # PSReadLine provides fish-like auto-suggestions, included in powershell since 7.2, we need a version >= 2.2.6
    # PSReadLine 2.2.2 extends the power of Predictive IntelliSense by adding
    # support for plug-in modules that use advanced logic to provide
    # suggestions for full commands. The latest version, PSReadLine 2.2.6,
    # enables predictions by default.
    # Using Predictive IntelliSense
    # https://docs.microsoft.com/de-de/powershell/module/psreadline/about/about_psreadline
    Install-Module -Name PSReadLine -AllowPrerelease -Force -ErrorAction SilentlyContinue
    $installed += "PSReadLine"

    # To enable PowerShell command line auto-completion plugin for the
    # PSReadLine Predictive Intellisense feature:
    # https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.4
    # FIXME: Maybe this has to be run twice?! - at first sight this is not obviously working..
    Enable-ExperimentalFeature PSSubsystemPluginMode
    # https://github.com/PowerShell/CompletionPredictor
    Install-Module -Name CompletionPredictor -Repository PSGallery -Force -ErrorAction SilentlyContinue
    $installed += "CompletionPredictor"

    return $installed
}
