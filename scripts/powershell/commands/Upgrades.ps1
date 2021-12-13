function update {
    Write-Host "'update' not implemented, try 'upgrade'"
}


function upgrade {
    param(
        [string] $argument
    )
    # check admin-rights
    $is_admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if (!$is_admin) { Write-Host "Running upgrades without admin-rights is not recommended" }
    if ( -not $argument ) {
        Write-Host "please provide an argument:"
        Write-Host "    all                 Full System-Upgrade"
        Write-Host "    windows             Windows Update"
        Write-Host "    choco               Chocolatey Upgrade"
        Write-Host "    repos               Update the repositores that are set in $env:DOTFILES\local\git_pulls.txt"
        Write-Host "    python              Update pyenv, poetry and pip"
        Write-Host "    python-packages     Updates all python packages of the active repositories"
        Write-Host "    powershell          Update powershell"
        Write-Host "    log                 Just Update the log"
        Write-Host ""
        return
    }
    if ($argument -eq "all") { UpgradeAll; return }
    if ($argument -eq "windows") { WindowsUpdate; return }
    if ($argument -eq "repos") { UpdateRepositories; return }
    if ($argument -eq "python") { PythonUpdate; return }
    if ($argument -eq "powershell") { PowershellUpdate; return }
    if ($argument -eq "python-packages") { PythonPackagesUpdate; return }
    if ($argument -eq "choco") { UpgradeChocolatey; return }
    if ($argument -eq "log") { JustUpgradeLogMessage; return }
    Write-Host "(upgrade) invalid argument: 'upgrade $argument' not found"
}

function UpgradeAll {
    $update_message = "Full System Upgrade"
    Write-Host "Starting $update_message..."

    PythonUpdate
    UpdateRepositories
    UpgradeChocolatey
    WindowsUpdate

    LogUpdate -Message "$update_message"

    Write-Host ""
    Write-Host "Updates finished"
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
    $choco_packages_log_path = (Join-Path -Path $env:DOTFILES -ChildPath "local\installedPackages\$env:computername\choco_installed_packages.txt")
    if (Test-Path -Path $choco_packages_log_path -PathType Leaf) {
        Write-Output (choco list -lo -r -y) | Out-file $choco_packages_log_path
    }
    else {
        Write-Host "ERROR: $choco_packages_log_path not found"
    }
    LogUpdate -Message "Chocolatey packages upgrade"
    Write-Host ""
}

function PythonUpdate {
    Write-Host "=== === === PYTHON Update === === ==="
    $update_message = "Updating PYTHON (pip, pyenv, poetry, pipx).."
    Write-Host $update_message
    Write-Host ""
    LogUpdate -Message "$update_message"
    Write-Host "Updating pip.."
    python -m pip install --upgrade pip --no-warn-script-location
    Write-Host ""

    if (![bool](Get-Command -Name 'pyenv' -ErrorAction SilentlyContinue)) {
        Write-Host "could not find pyenv on path, skipping.."
    }
    else {
        Write-Host "Updating pyenv.."
        if (Test-Path env:PYENV) {
            $current_path = $pwd
            Set-Location -Path (Split-Path -Path $env:PYENV -Parent)
            Invoke-Expression "git pull"
            Invoke-Expression "git checkout -- pyenv-win/.versions_cache.xml"
            Set-Location -Path $current_path
            }
        else {
            Write-Host "env:PYENV not found, skipping repository pull"
        }
        Write-Host "Ask for new python versions available to pyenv.."
        pyenv update
        Write-Host ""
    }

    Write-Host "Updating pipx.."
    # TODO: automate clean up: e.g: in .local\pipx
    # New-Item -Path "$env:USERPROFILE\.local\bin\python" -ItemType SymbolicLink -Value "$env:USERPROFILE\.pyenv\pyenv-win\shims\python.bat"
    python -m pip install --quiet --user -U pipx

    if (![bool](Get-Command -Name 'poetry' -ErrorAction SilentlyContinue)) {
        Write-Host "Could not find poetry on path, skipping.."
    }
    else {
        Write-Host "Updating poetry.."
        # poetry self update
        pipx upgrade poetry
        Write-Host ""
    }

    Write-Host ""
    # python -m pipx ensurepath
    Write-Host "=== === === PYTHON Update Finished === === ==="
}

function PowershellUpdate {
    Write-Host "Updating powershell.."
    iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
    LogUpdate -Message "Powershell Update"
    Write-Host ""
}

function JustUpgradeLogMessage {
    Write-Host "Updating the logfile.."
    LogUpdate -Message "Updated this logfile to surpress the notification"
}

function WindowsUpdate {
    Write-Host "Installing Windows Updates.."
    if (!$is_admin) { 
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
        LogUpdate -Message "Windows Update"
        Get-WindowsUpdate -Install -AcceptAll
        Write-Host "Windows Updates finished."
    }
    else {
        Write-Host "No new Windows Updates found."
    }
}


function PythonPackagesUpdate {
    Write-Host "Updating python-packages.."
    pip install --upgrade ((pip list -o | Select-Object -Skip 2) | Foreach-Object {$_.Split()[0]}) --no-warn-script-location
    LogUpdate -Message "Python packages Update"
    Write-Host ""
}


function UpdateRepositories {
    Write-Host "Updating local repositories.."
    # is git installed?
    if (![bool](Get-Command -Name 'git' -ErrorAction SilentlyContinue)) {
        Write-Host "aborting: could not find git"
        return
    }
    # are settings available?
    if (!$settings.git_pulls) {
        Write-Host "aborting: could not resolve a path to the repositories from settings"
        return
    }
    # init respositories to update
    $respository_path = Join-Path -Path $env:DOTFILES -ChildPath $settings.git_pulls
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
    Write-Host "Switching back to your directory.."
    Set-Location -Path $current_path
    Write-Host "Repository update finished :-)"
    Write-Host ""
    LogUpdate -Message "Repository Update"
}


function LogUpdate {
    param([Parameter(Mandatory=$True)][string]$message = $(throw "Parameter -Message is required."))
    $update_log_path = (Join-Path -Path $env:DOTFILES -ChildPath "local\logs\$env:computername\updates.log")
    if (Test-Path -Path $update_log_path -PathType Leaf) {
        Write-Output (-join('{"message": "', $($message), '", "timestamp": "', $(Get-TimeStamp), '"},')) | Out-file $update_log_path -append
    }
    else {
        Write-Host "ERROR: Logfile not found"
    }
}
