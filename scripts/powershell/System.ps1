
# Implementing various additional system commands to make life easier.

# are you admin [BOOL] ?
function isadmin {[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")}


function sudo () {
    if ($args.Length -lt 1) {
        Write-Host "No command specified."
    }
    if ($args.Length -ge 1) {  # Opens a new elevated Powershell in Windows-Terminal.
        Start-Process wt.exe -ArgumentList "pwsh.exe", "-NoExit", "-Command", "$args" -verb "runAs"
    }
}


# Show IP-Address
function ip { xh ident.me --body }  # == (Invoke-WebRequest -uri "http://ipinfo.io/json").Content }


function sysinfo {
    Get-CimInstance -ClassName Win32_processor | ft -AutoSize Name,MaxClockSpeed,NumberOfCores
    Get-CimInstance -ClassName Win32_Physicalmemory | ft -AutoSize Manufacturer,PartNumber,Configuredclockspeed,Capacity
    Get-CimInstance -ClassName Win32_VideoController | ft -AutoSize Name,AdapterRAM,DriverVersion
    Get-CimInstance -ClassName Win32_BaseBoard | ft -AutoSize Manufacturer,Product
    Get-CimInstance -ClassName win32_bios | ft -AutoSize Manufacturer,Version,Name
    Get-CimInstance -ClassName WIN32_DiskDrive -ComputerName $server
    # Get-CimInstance -ClassName Win32_Networkadapter | ft -AutoSize DeviceID,Name,ServiceName
}

# Show Windows Version
function ver {
    $name = (Get-CimInstance -ClassName Win32_OperatingSystem).caption
    $bit = (Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture
    $ver = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx
    Write-Host $name, $bit, " Version:", $ver, "- Build:", $build
}


function envs {gci env:* | sort-object name }  # -Description "displays all environment variables"
Set-Alias printenv envs


# Lock the computer
function lock{
    c:\windows\system32\rundll32.exe user32.dll, LockWorkStation
}


# Create a file association for a filetype.
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


function ShowConfigSSH {
    # "Show a brief ssh-config summary."
    Write-Host "Show SSH-Config"
}
Set-Alias -Name showssh -Value ShowConfigSSH -Description "Show a brief ssh-config summary."


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


function AssurePython {
    if (Test-Path "python.exe") {
        return $true
    }
    else {
        Write-Host "Python not found"
        return $false
    }
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


function GeneratePassword ([int]$pass_length = 50) {
    $Password =  ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | sort {Get-Random})[0..$pass_length] -join ''
}

# Restart a hung up printer.
function spool { . $env:DOTFILES\scripts\batch\printer_restart.bat }


# TODO: implement write-to-log(message, logtype) function
