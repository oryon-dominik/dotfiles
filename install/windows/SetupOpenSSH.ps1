#!/usr/bin/env pwsh


# ! Handling & configuring ssh-agents on windows is a pain.. will continue here later some day..


Import-Module "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"


function SetupSSH {
    param (
        [bool]$official = $true
    )

    $admin = isadmin
    if ($admin -eq $true) {
        Write-Host "This script should not be run as an administrator."
        return
    }

    if ($official -eq $true) {
        $ssh_path = "C:\Windows\System32\OpenSSH\ssh.exe"
        sudo OpenSSHOfficialInstall
    } else {
        sudo RemoveOfficialSSHInstall
        scoop install openssh
        $ssh_path = "$(Join-Path -Path $env:SCOOP -ChildPath "apps\openssh\current\ssh.exe")"
        # TBD: scoop install script should not be needed I guess.
        # sudo OpenSSHScoopInstall
    }

    # TBD: restart the system here?
    sudo RegisterAndStartSSHAgent
    SetupSSHKeys -sshpath $ssh_path
}


function OpenSSHOfficialInstall {
    # ! You have to manually start an elevated powershell, sudo doesn't work here.
    $admin = isadmin
    if ($admin -eq $false) {
        Write-Host "This script needs to be run as administrator."
        return
    }

    # Install the official OpenSSH Client
    Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
}


function RemoveOfficialSSHInstall {
    $admin = isadmin
    if ($admin -eq $false) {
        Write-Host "This script needs to be run as administrator."
        return
    }

    $admin = isadmin
    if ($admin -eq $false) {
        Write-Host "This script needs to be run as administrator."
        return
    }

    # We remove the Windows-Builtin openssh
    Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    # server should not be installed by default
    # Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}


function RegisterAndStartSSHAgent {
    # Start & register the ssh-agent's service
    Get-Service -Name ssh-agent | Set-Service -StartupType Automatic
    Start-Service ssh-agent
}


# function OpenSSHScoopInstall {
#     # Manually install the sshd service and daemon from the scoop script?
#     $admin = isadmin
#     if ($admin -eq $false) {
#         Write-Host "This script needs to be run as administrator."
#         return
#     }
#     # $env:SCOOP\apps\openssh\current\install-sshd.ps1
#     # Write-host "To uninstall the ssh agent: 'sudo $env:SCOOP\apps\openssh\current\uninstall-sshd.ps1'"
# }


function SetupSSHKeys {
    param ([str]$sshpath)

    $admin = isadmin
    if ($admin -eq $true) {
        Write-Host "This script should not be run as an administrator."
        return
    }
    # Back to your normal shell.
    AddToDotenv -path "$env:DOTFILES\.env" -key "GIT_SSH" -value $sshpath -overwrite $false -warn $false
    # generate a new ssh keypair
    z $env:USERPROFILE/.ssh
    ssh-keygen -t ed25519 -C "$env:USERPROFILE@$(hostname)" -f "$env:USERPROFILE\.ssh\id_ed25519"
    ssh-add "$env:USERPROFILE\.ssh\id_ed25519"
    
    # check if the key is added correctly
    ssh-add -L
}
