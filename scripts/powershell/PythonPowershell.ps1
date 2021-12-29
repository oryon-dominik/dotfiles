
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


# New project
function new {
    . (Join-Path -Path $script_location -ChildPath "\python\new_project.py")
}


function clock { # "Starts a timer"  # needs timer.py in $script_location
    $timer_script_path = (Join-Path -Path $script_location -ChildPath "\python\timer.py")
    if (-Not (Test-Path -Path $timer_script_path -PathType Leaf)) {
        Write-Host "aborting: clock/timer script $timer_script_path not found"
        return
    }
    python $timer_script_path $args
}


function AddPoetryRequirements { foreach($requirement in (Get-Content "$pwd\requirements.txt")) {Invoke-Expression "poetry add $requirement"} }


function venvName {
    python $env:DOTFILES\scripts\python\get_venv_name.py
}
