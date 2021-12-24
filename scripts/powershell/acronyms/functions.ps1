# TODO: implement write-to-log(message, logtype) function

function sudo () {
    if ($args.Length -lt 1) {
        Write-Host "No command specified."
    }
    if ($args.Length -ge 1) {  # Opens a new elevated Powershell in Windows-Terminal.
        Start-Process wt.exe -ArgumentList "pwsh.exe", "-NoExit", "-Command", "$args" -verb "runAs"
    }
}

function lock{
    # locks the computer
    c:\windows\system32\rundll32.exe user32.dll, LockWorkStation
}

function GeneratePassword ([int]$pass_length = 50) {
    $Password =  ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | sort {Get-Random})[0..$pass_length] -join ''
}

function new {
    . (Join-Path -Path $script_location -ChildPath "\python\new_project.py")
}

function Get-TimeStamp {
    return "{0:yyyy-MM-dd} {0:HH:mm:ss}" -f (Get-Date)
}
Set-Alias -Name dt -Value Get-TimeStamp -Description "Gets time stamp"

function weather{  # weather <city> <country>
    Param([Parameter(Mandatory=$false)] [String]$city = $position.city, [Parameter(Mandatory=$false)] [String]$country = $position.country) # default-city
    Get-Weather -City $city -Country $country
}
Set-Alias -Name wetter -Value weather -Description "Wetterbericht"

function isadmin {[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")}  # are you admin [BOOL] ?

function cfg { 
    set-location $env:DOTFILES  # config (DEN) folder
    if (Get-Command 'deactivate' -errorAction Ignore) {
        Try {
            deactivate | out-null
        }
        Catch {}
    }  # deactivate any active env, to work on "pure" system-python
}

function aliases { notepad++ "$env:DOTFILES\scripts\powershell\acronyms\locations.ps1" }  # edit local Aliases

function sysinfo {
    Get-CimInstance -ClassName Win32_processor | ft -AutoSize Name,MaxClockSpeed,NumberOfCores
    Get-CimInstance -ClassName Win32_Physicalmemory | ft -AutoSize Manufacturer,PartNumber,Configuredclockspeed,Capacity
    Get-CimInstance -ClassName Win32_VideoController | ft -AutoSize Name,AdapterRAM,DriverVersion
    Get-CimInstance -ClassName Win32_BaseBoard | ft -AutoSize Manufacturer,Product
    Get-CimInstance -ClassName win32_bios | ft -AutoSize Manufacturer,Version,Name
    Get-CimInstance -ClassName WIN32_DiskDrive -ComputerName $server
    # Get-CimInstance -ClassName Win32_Networkadapter | ft -AutoSize DeviceID,Name,ServiceName
}

function ver {
    $name = (Get-CimInstance -ClassName Win32_OperatingSystem).caption
    $bit = (Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture
    $ver = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx
    Write-Host $name, $bit, " Version:", $ver, "- Build:", $build
}

# link <target> <source>              create a junction -> "symlink" for directories
function linkdir($target, $source){New-Item -Path $target -ItemType Junction -Value $source}
# symlink <target> <source>           create a symlink for files
function link($target, $source){New-Item -Path $target -ItemType SymbolicLink -Value $source}

function ip { xh ident.me --body }  # == (Invoke-WebRequest -uri "http://ipinfo.io/json").Content }

function envs {gci env:* | sort-object name }  # -Description "displays all environment variables"
Set-Alias printenv envs


function spool { . $env:DOTFILES\scripts\batch\printer_restart.bat }


function AddPoetryRequirements { foreach($requirement in (Get-Content "$pwd\requirements.txt")) {Invoke-Expression "poetry add $requirement"} }


function ansible {
    Write-Host "ERROR: Ansible does not support windows (yet?). To use ansible, switch to WSL"
}


function CreateAssociation {
    Param(
        [parameter(Mandatory=$true, HelpMessage="File extension name")] [String[]] $extension,
        [parameter(Mandatory=$true, HelpMessage="Path to executable")] [String[]] $pathToExecutable
    )

    # create the filetype
    $filetype = cmd /c "assoc $extension 2>NUL"

    if ($filetype) { # Association already exists: override it
        $filetype = $filetype.Split('=')[1]
        Write-Output "Overwriting filetype $filetype ($extension)"
    } else { # Name doesn't exist: create it
        $filetype = "$($extension.Replace('.',''))file" # ".log.1" becomes "log1file"
        Write-Output "Creating filetype $filetype ($extension)"
        cmd /c 'assoc $extension=$filetype'
    }
    Write-Output "Associating filetype $filetype ($extension) with $pathToExecutable.."
    cmd /c "ftype $filetype=`"$pathToExecutable`" `"%1`""
}


function venvName {
    python $env:DOTFILES\scripts\python\get_venv_name.py
}


function clock { # "Starts a timer"  # needs timer.py in $script_location
    $timer_script_path = (Join-Path -Path $script_location -ChildPath "\python\timer.py")
    if (-Not (Test-Path -Path $timer_script_path -PathType Leaf)) {
        Write-Host "aborting: clock/timer script $timer_script_path not found"
        return
    }
    python $timer_script_path $args
}

function cliTube {
    $cliTube_path = Join-Path -Path $script_location -ChildPath "\python\cliTube.py"
    if (!( Test-Path $cliTube_path)) {
        Write-Warning "could not find $cliTube_path"
        return
    }
    python $cliTube_path $args
}
Set-Alias -Name tube -Value cliTube -Description "Plays Youtube Search-Results"  # needs cliTube.py in $script_location


function hockey { # Plays Highlights from different hockey leagues.
# you can create a symbolic link to that script with:  New-Item -Path "$env:DOTFILES/scripts/python/hockey.py" -ItemType SymbolicLink -Value "<location-of-your>/hockey.py"
    $nhl_path = Join-Path -Path $script_location -ChildPath "\python\hockey.py"
    if (!( Test-Path $nhl_path)) {
        Write-Warning "could not find $nhl_path"
        return
    }
    python $nhl_path $args
}
function nhl {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "NHL" $arguments
}
function hawks {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "NHL" --team "Blackhawks" $arguments
}
Remove-Alias -Name del
function del {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "DEL" $arguments
}
function deg {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "DEL" --team "Düsseldorfer EG" $arguments
}


# restic backups
function restic-apollon {
    $is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if (-not $is_elevated) {
        Write-Warning "Please run backups as root"
    }
    else {
        $REPOSITORY = "G:\backups"
        restic -r $REPOSITORY -p $env:HOME/.secrets/backups $args
    }
}

function backup() {
    if (!$args) { 
        Write-Warning "Please provide a valid path to backup"
        return
    }
    if ( $(Try { Test-Path -Path $args } Catch { $false }) ) {
        restic-apollon --tag custom backup $args
    }
    else {
        Write-Warning "Invalid path. Please provide a valid path to backup"
    }
}

function backups {
    $is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if (-not $is_elevated) {
        Write-Warning "Please run backups as root"
    }
    else {
        Write-Host --------------------------------------------
        Write-Host starting backup at (Get-Date)
        Write-Host --------------------------------------------

        restic-apollon --tag apollon --exclude-file $env:DOTFILES\local\restic-excludefile backup c:\dev d:\keep
        restic-apollon forget --prune --keep-last=7 --keep-daily=30 --keep-weekly=52 --keep-monthly=24 --keep-yearly=10
    }
}


# call command shortcuts, used for python projects
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