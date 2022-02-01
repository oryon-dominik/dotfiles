
# Implementing powershell commands that run python under the hood.

# Call command shortcuts, used for python projects
function cc () {
    $commands = ".\commands.py"
    $cwd = (Get-Location)
    $parent = Split-Path -Path $cwd
    if (Test-Path $commands -PathType leaf)    {
        python commands.py $args
    }
    elseif (Test-Path (Join-Path -Path $parent -ChildPath $commands) -PathType leaf) {
        Set-Location $parent
        python commands.py $args
        Set-Location $cwd
    }
    else {
        Write-Host "commands.py not found" 
    }
}


function HashFromPassword {
    python -c "from passlib.hash import sha512_crypt; import getpass; print(sha512_crypt.using(rounds=656_000).hash(getpass.getpass()))"
}


# New project
function new {
    $cwd = (Get-Location)
    Set-Location (Join-Path -Path $script_location -ChildPath "\python\")
    python new_project.py
    Set-Location $cwd
}


function timer { # "Starts a timer"  # needs timer.py in $script_location
    $timer_script_path = (Join-Path -Path $script_location -ChildPath "\python\timer.py")
    if (-Not (Test-Path -Path $timer_script_path -PathType Leaf)) {
        Write-Host "aborting: clock/timer script $timer_script_path not found"
        return
    }
    python $timer_script_path $args
}


function ShowConfigSSH {
    $cwd = (Get-Location)
    Set-Location (Join-Path -Path $script_location -ChildPath "\python\")
    python pretty_print_ssh_config.py
    Set-Location $cwd
}
Set-Alias -Name showssh -Value ShowConfigSSH -Description "Show a brief ssh-config summary."



function AddPoetryRequirements { foreach($requirement in (Get-Content "$pwd\requirements.txt")) {Invoke-Expression "poetry add $requirement"} }


function venvName {
    python $env:DOTFILES\scripts\python\get_venv_name.py
}


function CmdTutorial {
    python $env:DOTFILES\scripts\python\cli_tutorial.py
}
Set-Alias -Name tut -Value CmdTutorial -Description "Show a short introductory tutorial for this CLI configuration."


function OnlineManPage {
    python $env:DOTFILES\scripts\python\manpage_from_https.py $args
}
Remove-Alias -Name man
Set-Alias -Name man -Value OnlineManPage -Description "Show online manpages for a linux command."


function RunSpeedtest { Write-Host "Running python module 'speedtest-cli'.";python -W ignore::DeprecationWarning -m speedtest }
Set-Alias -Name speedtest -Value RunSpeedtest -Description "Run a speedtest."


function ansible { Write-Host "ERROR: Ansible does not support windows (yet?). To use ansible, switch to WSL" }

function RunIPython { python -m IPython }
Set-Alias -Name ipython -Value RunIPython -Description "Run an ipython shell."
Set-Alias -Name bpython -Value RunIPython -Description "Run an ipython shell. Because bpython does not run on windows since fcntl is not available."

function GoogleCLISearch {
    python $env:DOTFILES\scripts\python\google.py $args
}
Set-Alias -Name search -Value GoogleCLISearch -Description "Run a google search inside CLI."

# Cryptography
function rot13 {
    $cwd = (Get-Location)
    Set-Location (Join-Path -Path $script_location -ChildPath "\python\")
    python rot13.py "$args"
    Set-Location $cwd
}
