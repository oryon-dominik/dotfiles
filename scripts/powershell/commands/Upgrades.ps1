function update{
    Write-Host "'Update' not implemented: Try 'upgrade' (Full System-Upgrade), 'windows-update', 'repo-update' or 'script-update' instead"
}


function upgrade{  # update all choco-packages, including windows-update
    # required: python and powershell files execute via '.' TODO: run scripts from executables-path
    $update_message = "Full System Upgrade"
    Write-Host "Starting Full System Upgrade..."
    Write-Host ""
    Write-Output (-join('{"message": "', $($update_message), '", "timestamp": "', $(Get-TimeStamp), '"},')) | Out-file (Join-Path -Path $env:DOTFILES -ChildPath "local\logs\$env:computername\updates.log") -append

    Write-Host ""
    Write-Host "Updating python.."
    python-update
    Write-Host ""
    Write-Host "Updating local repositories.."
    update-repositories
    Write-Host ""
    Write-Host "Updating installed Software Packages.."
    choco upgrade all
    Write-Host ""

    Write-Host "Adding installed chocolatey packages to local list"
    Write-Output (choco list -lo -r -y) | Out-file (Join-Path -Path $env:DOTFILES -ChildPath "local\installedPackages\$env:computername\choco_installed_packages.txt")
    Write-Host ""

    Write-Host "Installing Windows Updates.."
    $updates = Start-WUScan
    foreach($update in $updates)
    { 
        Write-Host $update.title
        Write-Host "Success:"
        Install-WUUpdates -Updates $update
    }

    Import-Module PSWindowsUpdate
    Get-WUInstall -AcceptAll -IgnoreUserInput -Confirm:$false
    wmic qfe list
    Write-Host ""
    Write-Host "Updates finished"
}


function python-update{
    Write-Host "Updating pip.."
    python -m pip install --upgrade pip
    Write-Host ""
    
    Write-Host "Updating pyenv.. (pulling from repo)"
    if (Test-Path env:PYENV) {
        $current_path = $pwd
        Set-Location -Path (Split-Path -Path $env:PYENV -Parent)
        $git_command = "git pull"
        Invoke-Expression $git_command
        Set-Location -Path $current_path
        }
    else {
        Write-Host "env:PYENV not found, skipping.."
    }
    Write-Host ""

    Write-Host "Updating python-poetry.."
    poetry self update
    Write-Host ""
}


function windows-update{
    $update_message = "Windows Update"
    Write-Host "Installing Windows Updates.."
    $updates = Start-WUScan
    if($updates.count -gt 0) {
        Write-Host "Updating.."
        Write-Output (-join('{"message": "', $($update_message), '", "timestamp": "', $(Get-TimeStamp), '"},')) | Out-file (Join-Path -Path $env:DOTFILES -ChildPath "local\logs\$env:computername\updates.log") -append
            foreach($update in $updates)
            { 
                Write-Host $update.title
                Write-Host "Success:"
                Install-WUUpdates -Updates $update
            }
            Write-Host "Updates finished.."
         } else {
            Write-Host "No new Windows Updates found.." 
        }
    
}


function python-packages-update{
    Write-Host "Updating python-packages.."
    pip install --upgrade ((pip list -o | Select-Object -Skip 2) | Foreach-Object {$_.Split()[0]})
    Write-Host ""
}


function update-repositories {
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
}

