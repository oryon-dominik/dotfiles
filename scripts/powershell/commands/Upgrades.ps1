function update {
    Write-Host "'update' not implemented, try 'upgrade'"
}


function upgrade {
    param(
        [string] $argument
    )
    if ( -not $argument ) {
        Write-Host "please provide an argument:"
        Write-Host "    all                 Full System-Upgrade"
        Write-Host "    windows             Windows Update"
        Write-Host "    choco               Chocolatey Upgrade"
        Write-Host "    repos               Update the repositores that are set in $env:DOTFILES\local\git_pulls.txt"
        Write-Host "    python              Update pyenv, poetry and pip"
        Write-Host "    python-packages     Updates all python packages of the active repositories"
        Write-Host ""
        return
    }
    if ($argument -eq "all") { UpgradeAll }
    if ($argument -eq "windows") { WindowsUpdate }
    if ($argument -eq "repos") { UpdateRepositories }
    if ($argument -eq "python") { PythonUpdate }
    if ($argument -eq "python-packages") { PythonPackagesUpdate }
    if ($argument -eq "choco") { UpgradeChocolatey }
}

function UpgradeAll {
    $update_message = "Full System Upgrade"
    Write-Host "Starting $update_message..."
    LogUpdate -Message $update_message

    PythonUpdate
    UpdateRepositories
    UpgradeChocolatey
    WindowsUpdate

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
    Write-Host ""
}

function PythonUpdate {
    Write-Host "Updating python.."
    Write-Host "Updating pip.."
    python -m pip install --upgrade pip --no-warn-script-location
    Write-Host ""

    if (![bool](Get-Command -Name 'pyenv' -ErrorAction SilentlyContinue)) {
        Write-Host "could not find pyenv on path, skipping.."
    }
    else {
        Write-Host "Updating pyenv.."
        pyenv update
        if (Test-Path env:PYENV) {
            $current_path = $pwd
            Set-Location -Path (Split-Path -Path $env:PYENV -Parent)
            $git_command = "git pull"
            Invoke-Expression $git_command
            Set-Location -Path $current_path
            }
        else {
            Write-Host "env:PYENV not found, skipping repository"
        }
        Write-Host ""
    }
    
    if (![bool](Get-Command -Name 'poetry' -ErrorAction SilentlyContinue)) {
        Write-Host "could not find poetry on path, skipping.."
    }
    else {
        Write-Host "Updating poetry.."
        poetry self update
        Write-Host ""
    }
    Write-Host "Updating pipx.."
    python -m pip install --user -U pipx
    # python -m pipx ensurepath
}


function WindowsUpdate {
    Write-Host "Installing Windows Updates.."
    $updates = Start-WUScan
    if($updates.count -gt 0) {
        Write-Host "Updating .."
        LogUpdate -Message "Windows Update"
        foreach($update in $updates)
        {
            Write-Host $update.title
            Write-Host -NoNewLine "Success:"
            Install-WUUpdates -Updates $update
        }
        Write-Host "Windows Updates finished.."
    }
    else {
        Write-Host "No new Windows Updates found.."
    }
}


function PythonPackagesUpdate {
    Write-Host "Updating python-packages.."
    pip install --upgrade ((pip list -o | Select-Object -Skip 2) | Foreach-Object {$_.Split()[0]}) --no-warn-script-location
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
        Write-Host "Updating" $repo
        Set-Location -Path $repo
        $git_command = "git pull"
        Invoke-Expression $git_command
    }
    $repositories = $null
    Write-Host "Switching back to your directory.."
    Set-Location -Path $current_path
    Write-Host "Repository update finished :-)"
    Write-Host ""
}


function LogUpdate {
    param([Parameter(Mandatory=$True)][string]$message = $(throw "Parameter -Message is required."))
    $update_log_path = (Join-Path -Path $env:DOTFILES -ChildPath "local\logs\$env:computername\updates.log")
    if (Test-Path -Path $update_log_path -PathType Leaf) {
        Write-Output (-join('{"message": "', $($update_message), '", "timestamp": "', $(Get-TimeStamp), '"},')) | Out-file $update_log_path -append
    }
    else {
        Write-Host "ERROR: Logfile not found"
    }
}
