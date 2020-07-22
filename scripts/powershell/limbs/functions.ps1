# TODO: implement write-to-log(message, logtype) function

# custom function-commands
$tray_open = $false
function cdrom{
    try {
        $Diskmaster = New-Object -ComObject IMAPI2.MsftDiscMaster2
        $DiskRecorder = New-Object -ComObject IMAPI2.MsftDiscRecorder2
        $DiskRecorder.InitializeDiscRecorder($DiskMaster)

        if (-Not $tray_open) {
            $DiskRecorder.EjectMedia()
            $global:tray_open = $true
            }
        elseif($tray_open) {
            $DiskRecorder.CloseTray()
            $global:tray_open = $false
            }

    } catch {
        Write-Error "Failed to operate the disk. Details : $_"
    }
}

function download{  # download <url> <destination_file_name>
	Param(
		[Parameter(Mandatory=$false)] [string]$url, [Parameter(Mandatory=$false)] [string]$filename)
		if($url){
			if($filename){
				$current_path = $(Get-Location)
				$request = New-Object System.Net.WebClient
				$target = "$current_path\$filename"
				$request.DownloadFile($url, $target)
			}
			else{
				Write-Host "Specify output filename"
			}
		}
		else{
			Write-Host "No URL specified"
		}
}

function sudo{  # TODO fix BUGs for complicated args (stringify or whatever..)
	Param(
		[Parameter(Mandatory=$false)] [String]$sudo_command)
		if($sudo_command){
			if($args){
				start-process -verb runAs $sudo_command -argumentlist $args
			}
			else{
				start-process -verb runAs $sudo_command
			}
		}
		else{
			Write-Host "No command specified"
		}
}

function lock{
	c:\windows\system32\rundll32.exe user32.dll, LockWorkStation
}

function python-update{
	Write-Host "Updating pip.."
	python -m pip install --upgrade pip
	Write-Host ""
	
	Write-Host "Updating pyenv.."
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

function update{
	Write-Host "'Update' not implemented: Try 'upgrade' (Full System-Upgrade), 'windows-update', 'repo-update' or 'script-update' instead"
}

function upgrade{  # update all choco-packages, including windows-update
	. (Join-Path -Path $script_location -ChildPath "\powershell\limbs\system_upgrade.ps1")
}

function windows-update{
	$update_message = "Windows Update"
	Write-Host "Installing Windows Updates.."
	$updates = Start-WUScan
	if($updates.count -gt 0) {
		Write-Host "Updating.."
		Write-Output (-join('{"message": "', $($update_message), '", "timestamp": "', $(Get-TimeStamp), '"},')) | Out-file (Join-Path -Path $env:DEN_ROOT -ChildPath "local\logs\$env:computername\updates.log") -append
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

function script-update{
	Write-Host "Updating local Python-Scripts.."
	. (Join-Path -Path $script_location -ChildPath "\python\update_scripts.py")
}

function python-packages-update{
	Write-Host "Updating python-packages.."
	pip install --upgrade ((pip list -o | Select-Object -Skip 2) | Foreach-Object {$_.Split()[0]})
	Write-Host ""
}

function repo-update{
	Write-Host "Updating local repositories.."
	. (Join-Path -Path $script_location -ChildPath "\powershell\limbs\update_repositories.ps1")
}

function generate_password ([int]$pass_length = 50) {
	python -c "import random; print(''.join([random.choice('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSRTUVWXYZ0123456789!@#$%^&*(-_=+)') for i in range($pass_length)]))"
}

function orga {
	emacs (Join-Path -Path $settings.cloud -ChildPath "\_orga\zeiterfassung.org")
}

function new_project {
	. (Join-Path -Path $script_location -ChildPath "\python\new_project.py")
}

function Get-TimeStamp {
    return "{0:yyyy-MM-dd} {0:HH:mm:ss}" -f (Get-Date)
}
Set-Alias -Name time -Value Get-TimeStamp -Description "Gets time stamp"

function zen{  # activates zen-mode
	$zen_cmd = "'function prompt {Write-Host \`"\`" -NoNewline -ForegroundColor white;\`"% \`";Write-Host \`" \`" -NoNewline -ForegroundColor white};cls'"
	$zenmode = $powershell_location + "\PowerShell.exe -NoLogo -NoExit -Command " + $zen_cmd + " -new_console:t:zen -new_console:W:'" + $console + "\console_zen.png' -new_console:C:" + $icons + "\zen.ico"
	Invoke-Expression $zenmode
}

function weather{  # weather <city> <country>
	Param([Parameter(Mandatory=$false)] [String]$city = $position.city, [Parameter(Mandatory=$false)] [String]$country = $position.country) # default-city
	Write-Host ""
	Get-Weather -City $city -Country $country
	Write-Host ""
}
Set-Alias -Name wetter -Value weather -Description "Wetterbericht"

function shell{
	$newtab = $powershell_location + "\PowerShell.exe -NoLogo -NoExit -new_console:t:PowerShell -new_console:W:'" + $console + "\console.png' -new_console:C:" + $icons + "\cyberise.ico"
	Invoke-Expression $newtab
}
function adminshell{
	$newtab = $powershell_location + "\PowerShell.exe -NoLogo -NoExit -new_console:t:PowerShell -new_console:W:'" + $console + "\console.png' -new_console:C:" + $icons + "\cyberise.ico"
	Invoke-Expression $newtab
}
Set-Alias -Name newtab -Value shell -Description "opens new tab"

# are you admin [BOOL] ?
function isadmin {[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")}

function cfg { set-location $env:DEN_ROOT }  # config (DEN) folder

function scripts { set-location $env:DEN_ROOT\scripts }

# edit powershell_profile in notepad
function powershell_config { notepad++ "$env:DEN_ROOT\scripts\powershell\Microsoft.PowerShell_profile.ps1" }
Set-Alias -Name config -Value powershell_config -Description "edit Powershell-Profile"

function alias_config { notepad++ "$env:DEN_ROOT\scripts\powershell\limbs\locations.ps1" }
Set-Alias -Name aliases -Value alias_config -Description "edit lokal Powershell-location-Aliases"

function sysinfo {
	Get-CimInstance -ClassName Win32_processor | ft -AutoSize Name,MaxClockSpeed,NumberOfCores
	Get-CimInstance -ClassName Win32_Physicalmemory | ft -AutoSize Manufacturer,PartNumber,Configuredclockspeed,Capacity
	Get-CimInstance -ClassName Win32_VideoController | ft -AutoSize Name,AdapterRAM,DriverVersion
	Get-CimInstance -ClassName Win32_BaseBoard | ft -AutoSize Manufacturer,Product
	Get-CimInstance -ClassName win32_bios | ft -AutoSize Manufacturer,Version,Name
	Get-CimInstance -ClassName WIN32_DiskDrive -ComputerName $server
	# Get-CimInstance -ClassName Win32_Networkadapter | ft -AutoSize DeviceID,Name,ServiceName
}

function venv { . .\utils\activate.ps1 }  # TODO: get a more sophisticated location of the next matching activate.ps1

function ver {
	$name = (Get-CimInstance -ClassName Win32_OperatingSystem).caption
	$bit = (Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture
	$ver = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
	$build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx
	Write-Host $name, $bit, " Version:", $ver, "- Build:", $build
}

function lan {
	$networks = Get-CimInstance -ClassName win32_networkadapter | select netconnectionid, name, InterfaceIndex, netconnectionstatus
	Write-Host $networks
}

# link <destination> <target>               create a junction
function link($destination,$target){New-Item -Path $destination -ItemType Junction -Value $target}

function ip { (Invoke-WebRequest -uri "http://ident.me").Content }

function envs {gci env:* | sort-object name }  # -Description "displays all environment variables"
Set-Alias listenvs envs

function noadmin { . $env:DEN_ROOT\scripts\powershell\commands\shell_no_admin.ps1 }

function restart { . $env:DEN_ROOT\scripts\batch\cmder_restart.bat }

function spool { . $env:DEN_ROOT\scripts\batch\printer_restart.bat }

# SpeedTest
function speedtest { . $env:DEN_ROOT\scripts\powershell\commands\SpeedTest.ps1 }
Set-Alias speed speedtest

# python-poetry add requirements.txt
function poetry_add_requirements { foreach($requirement in (Get-Content "$pwd\requirements.txt")) {Invoke-Expression "poetry add $requirement"} }

function CreateAssociation {
	Param(
		[parameter(Mandatory=$true, HelpMessage="File extension name")] [String[]] $extension,
	 	[parameter(Mandatory=$true, HelpMessage="Path to executable")] [String[]] $pathToExecutable)
	
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
	python $env:DEN_ROOT\scripts\python\get_venv_name.py
}

function venvColor($color) {
	python $env:DEN_ROOT\scripts\python\change_venv_color.py $color
}
