
# Implementing powershell commands that run python under the hood.

function pip { python -m pip $args }  # always use active's python pip

function python { uv run python $args }  # always use active uv's python


# Call command shortcuts, used for python projects
function cc () {
    $commands = ".\commands.py"
    $cwd = (Get-Location)
    $parent = Split-Path -Path $cwd
    if (Test-Path $commands -PathType leaf)    {
        if ($args) {
            python commands.py $args
        }
        else {
            python commands.py
        }
        
    }
    elseif (Test-Path (Join-Path -Path $parent -ChildPath $commands) -PathType leaf) {
        Set-Location $parent
        if ($args) {
            python commands.py $args
        }
        else {
            python commands.py
        }
        Set-Location $cwd
    }
    elseif (Test-Path (Join-Path -Path $cwd -ChildPath "application/commands.py") -PathType leaf) {
        Set-Location (Join-Path -Path $cwd -ChildPath "application/")
        if ($args) {
            python commands.py $args
        }
        else {
            python commands.py
        }
        Set-Location $cwd
    }
    else {
        Write-Host "commands.py not found" 
    }
}

function HashFromPassword {
    python -c "from passlib.hash import sha512_crypt; import getpass; print(sha512_crypt.using(rounds=656_000).hash(getpass.getpass()))"
}

function timer { # "Starts a timer"  # needs timer.py in $script_location
    $timer_script_path = (Join-Path -Path $script_location -ChildPath "\python\timer.py")
    if (-Not (Test-Path -Path $timer_script_path -PathType Leaf)) {
        Write-Host "aborting: clock/timer script $timer_script_path not found"
        return
    }
    python $timer_script_path $args
}

function InstallPythonSystemPackages {
    if ($env:VIRTUAL_ENV_PROMPT -ne "" -and $env:VIRTUAL_ENV_PROMPT -ne $null) {
        deactivate
    }
    python -m pip install -r $env:DOTFILES\common\python\system-packages.txt --break-system-packages
}

function ShowConfigSSH {
    $cwd = (Get-Location)
    Set-Location (Join-Path -Path $script_location -ChildPath "\python\")
    python pretty_print_ssh_config.py
    Set-Location $cwd
}
Set-Alias -Name showssh -Value ShowConfigSSH -Description "Show a brief ssh-config summary."

function keepAlive {
    python $env:DOTFILES\scripts\python\keepalive.py
}

function markdown {
    # Parse markdown file or pipe content and display it in the terminal.
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $line
    )
    Begin {
        $file = New-TemporaryFile
        $content = $args
        $text = @()
        $arg_is_file = $false
        if (-Not ($line -eq $null)) {
            if (Test-Path $line -PathType Leaf) {
                $arg_is_file = $true
            }
        }
    }
    Process {
        if (-Not ($arg_is_file)) {
            $text += $line.Trim()
        }
    }
    End {
        if ($arg_is_file) {
            python -m rich.markdown $line
        }
        else {
            $text | Out-File -FilePath $file.FullName -Encoding utf8
            python -m rich.markdown $file
        }
        Remove-Item -Path $file -Force
    }
}

function venvName {
    python $env:DOTFILES\scripts\python\get_venv_name.py
}

function venvNameLegacy {
    python $env:DOTFILES\scripts\python\get_venv_name.py --legacy
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
