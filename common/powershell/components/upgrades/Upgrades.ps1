function update {
    Write-Host "'update' not implemented, try 'upgrade'"
}

# TODO: add a log level object, which supports the correct types

function upgrade {
    param(
        [string] $argument
    )
    # check admin-rights
    # $is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    # if (!$is_elevated) { Write-Host "Running upgrades without admin-rights is not recommended" }
    if ( -not $argument ) {
        Write-Host "please provide an argument:"
        Write-Host "    all                 Full System-Upgrade"
        Write-Host "    windows             Windows Update"
        # Write-Host "    choco               Chocolatey Upgrade"
        Write-Host "    repos               Update the repositores that are set in $env:DOTFILES\.repositories.txt"
        Write-Host "    python              Update python and pip"
        # Write-Host "    python-packages     Updates all python packages of the active repositories"
        Write-Host "    powershell          Update powershell"
        Write-Host "    rust                Update rust via rustup"
        Write-Host "    log                 Just Update the log"
        Write-Host ""
        return
    }
    if ($argument -eq "all") { UpgradeAll; return }
    if ($argument -eq "windows") { WindowsUpdate; return }
    if ($argument -eq "repos") { UpdateRepositories; return }
    if ($argument -eq "python") { PythonUpdate; return }
    if ($argument -eq "powershell") { PowershellUpdate; return }
    # if ($argument -eq "python-packages") { PythonPackagesUpdate; return }
    # if ($argument -eq "choco") { UpgradeChocolatey; return }
    if ($argument -eq "scoop") { UpgradeScoop; return }
    if ($argument -eq "rust") { RustUpgrade; return }
    if ($argument -eq "log") { JustUpgradeLogMessage; return }
    Write-Host "(upgrade) invalid argument: 'upgrade $argument' not found"
}

function UpgradeAll {
    $update_message = "Full System Upgrade"
    Write-Host "Starting $update_message..."

    PythonUpdate
    RustUpgrade
    UpdateRepositories
    UpgradeScoop
    # UpgradeChocolatey
    WindowsUpdate

    LogUpdate -Message "$update_message" -Level "INFO"  # TODO: calculate level from all upgrade result errorcodes

    Write-Host ""
    Write-Host "Updates finished"
}

function RustUpgrade {
    Write-Host "Updating rust.."
    iex "rustup update"
    LogUpdate -Message "Rust Update" -Level "INFO"  # TODO: calculate level from rust update errorcodes
    Write-Host ""
    # TODO: return errorcode or success
}


function UpgradeScoop {
    Write-Host "Updating installed Scoop Software Packages.."
    if (![bool](Get-Command -Name 'scoop' -ErrorAction SilentlyContinue)) {
        Write-Host "aborting: could not find scoop on path"
        return
    }
    scoop update *

    Write-Host ""
    Write-Host "Adding installed scoop packages to local list"
    $installed_scoops = (Join-Path -Path $env:DOTFILES_SHARED -ChildPath "installedPackages\$env:computername\")
    if(!(test-path $installed_scoops)) {
        New-Item -ItemType Directory -Force -Path $installed_scoops
    }
    $log = (Join-Path -Path $env:DOTFILES_SHARED -ChildPath "installedPackages\$env:computername\scoop_installed_packages.txt")
    if (Test-Path -Path $log -PathType Leaf) {
        Write-Output (scoop list) | Out-file $log
    }
    else {
        Write-Host "ERROR: $log not found"
    }

    LogUpdate -Message "Scoop packages upgrade" -Level "INFO"  # TODO: calculate level from result errorcodes
    Write-Host ""
}

function UpgradeChocolatey {
    Write-Host "Updating installed Software Packages.."
    if (![bool](Get-Command -Name 'choco' -ErrorAction SilentlyContinue)) {
        Write-Host "aborting: could not find chocolatey on path"
        return
    }
    choco upgrade all
    Write-Host ""
    Write-Host "Adding installed chocolatey packages to local list"
    $installed_packages_path = (Join-Path -Path $env:DOTFILES_SHARED -ChildPath "installedPackages\$env:computername\")
    if(!(test-path $installed_packages_path)) {
        New-Item -ItemType Directory -Force -Path $installed_packages_path
    }
    $choco_packages_log_path = (Join-Path -Path $env:DOTFILES_SHARED -ChildPath "installedPackages\$env:computername\choco_installed_packages.txt")
    if (Test-Path -Path $choco_packages_log_path -PathType Leaf) {
        Write-Output (choco list -lo -r -y) | Out-file $choco_packages_log_path
    }
    else {
        Write-Host "ERROR: $choco_packages_log_path not found"
    }
    LogUpdate -Message "Chocolatey packages upgrade" -Level "INFO"  # TODO: calculate level from result errorcodes
    Write-Host ""
    # TODO: return errorcode or success
}

function PythonUpdate {
    Write-Host "=== === === PYTHON Update === === ==="
    $update_message = "Updating PYTHON (pip, uv).. DEPRECATION WARNING, will call the install script instead"
    Write-Host $update_message
    Write-Host ""
    # TODO: calculate level from result errorcodes, so update the log, when
    # finished or breaking here..
    LogUpdate -Message "$update_message" -Level "INFO"


    . $(Join-Path -Path "$env:DOTFILES" -ChildPath "install/windows/InstallPython.ps1")
    $installed += ManagePythonToolchain -python $true -uv $true -global $true -favourites $true -clean $true

    Write-Host ""
    Write-Host "=== === === PYTHON Update Finished === === ==="

}

function PowershellUpdate {
    Write-Host "Updating powershell.."
    iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
    LogUpdate -Message "Powershell Update" -Level "INFO"  # TODO: calculate level from result errorcodes
    Write-Host ""
    # TODO: return errorcode or success
}

function JustUpgradeLogMessage {
    Write-Host "Updating the logfile.."
    LogUpdate -Message "Updated the logfile to surpress the notification" -Level "WARNING"
}

function WindowsUpdate {
    Write-Host "Installing Windows Updates.."
    if (!$is_elevated) { 
        Write-Host "Running windows upgrades without admin-rights is not possbile. Exiting."
        return
    }
    Import-Module PSWindowsUpdate
    if (-not (Get-Module -Name "PSWindowsUpdate")) {
        Write-Host "Module PSWindowsUpdate is not installed."
        $confirmation = Read-Host "Do you want to install the module? [y/n]"
        if ($confirmation -eq 'y') {
            Install-Module -Name PSWindowsUpdate
        }
        else {
            Write-Host "No Windows Update possible. Exiting."
            return
        }
    }
    $updates = Get-WUInstall
    if($updates.count -gt 0) {
        Write-Host "Updating .."
        LogUpdate -Message "Windows Update" -Level "INFO"  # TODO: calculate level from result errorcodes
        Get-WindowsUpdate -Install -AcceptAll
        Write-Host "Windows Updates finished."
    }
    else {
        Write-Host "No new Windows Updates found."
    }
    # TODO: return errorcode or success
}


function PythonPackagesUpdate {
    Write-Host "Updating python-packages.."
    python -m ensurepip --upgrade
    python -m pip install --upgrade ((pip list -o | Select-Object -Skip 2) | Foreach-Object {$_.Split()[0]}) --no-warn-script-location
    LogUpdate -Message "Python packages Update" -Level "INFO"  # TODO: calculate level from result errorcodes
    Write-Host ""
    # TODO: return errorcode or success
}


function UpdateRepositories {
    Write-Host "Updating local git repositories.. (see: '$env:DOTFILES/.repositories.txt')"
    # is git installed?
    if (![bool](Get-Command -Name 'git' -ErrorAction SilentlyContinue)) {
        Write-Host "aborting: could not find git"
        return
    }
    # are settings available?
    if (!(Test-Path(Join-Path -Path $env:DOTFILES -ChildPath '.repositories.txt'))) {
        Write-Host "aborting: could not resolve a path to the .repositories.txt"
        return
    }
    # init respositories to update
    $respository_path = Join-Path -Path $env:DOTFILES -ChildPath '.repositories.txt'
    if (-Not (Test-Path -Path $respository_path -PathType Leaf)) {
        Write-Host "aborting: repository config $respository_path not found"
        return
    }
    $repositories = Get-Content $respository_path
    $current_path = $pwd
    # pull the repos
    foreach($repo in $repositories)
    {
        if ($repo -and (Test-Path $path -PathType Leaf)) {
            Write-Host "Updating" $repo
            Set-Location -Path $repo
            $git_command = "git pull"
            Invoke-Expression $git_command
        }
        else {
            Write-Host "Skipping" $repo
        }
    }
    Set-Location -Path $current_path
    LogUpdate -Message "Upgrade Repositories" -Level "INFO"  # TODO: calculate level from result errorcodes
    LogUpdate -Message "Upgrade Repositories on $env:computername" -childpath "logs\global" -logfilename "auto-gitevents.log" -Level "INFO"  # TODO: calculate level from result errorcodes
    # TODO: return errorcode or success
}


function LogUpdate {

    param(
        [Parameter(Mandatory=$True)][string]$message = $(throw "Parameter -Message is required."),
        [Parameter(Mandatory=$True)][string]$level = $(throw "Parameter -Level is required."),
        [string]$childpath = "logs\$env:computername\",
        [string]$logfilename = "updates.log"
    )

    $update_machine_path = (Join-Path -Path $env:DOTFILES_SHARED -ChildPath $childpath)
    if(!(test-path $update_machine_path)) {
        New-Item -ItemType Directory -Force -Path $update_machine_path
    }
    $update_log_path = (Join-Path -Path $env:DOTFILES_SHARED -ChildPath "$childpath\$logfilename")
    if (!(Test-Path -Path $update_log_path -PathType Leaf)) {
        New-Item -ItemType File -Force -Path $update_log_path
    }
    Write-Output (-join($(Get-TimeStamp), " ", $($level), " ", $($message))) | Out-file $update_log_path -append

}
