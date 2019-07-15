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


function update{
	Write-Host "'Update' not implemented: Try 'upgrade' (Full System-Upgrade), 'windows-update' or 'script-update' instead"
}

function upgrade{  # update all choco-packages, including windows-update
	$update_message = "Full System Upgrade"
	Write-Host "Starting Full System Upgrade..."
	Write-Host ""
	Write-Output (-join('{"message": "', $($update_message), '", "@timestamp": "', $(Get-TimeStamp), '"},')) | Out-file (Join-Path -Path $env:DEN_ROOT -ChildPath ".local\logs\updates.log") -append
	Write-Host "Updating local Python-Scripts.."
	. (Join-Path -Path $script_location -ChildPath "\python\update_scripts.py")
	Write-Host ""
	Write-Host "Updating installed Software Packages.."
	choco upgrade all
	Write-Host ""
	Write-Host "Installing Windows Updates.."
	Import-Module PSWindowsUpdate
	Get-WUInstall -AcceptAll -IgnoreUserInput -Confirm:$false
	wmic qfe list
	Write-Host ""
	Write-Host "Updates finished"
}

function weather{  # weather <city> <country>
	Param([Parameter(Mandatory=$false)] [String]$city = $position.city, [Parameter(Mandatory=$false)] [String]$country = $position.country) # default-city
	Write-Host ""
	Get-Weather -City $city -Country $country
	Write-Host ""
}
Set-Alias -Name wetter -Value weather -Description "Wetterbericht"

function windows-update{
	$update_message = "Windows Update"
	Write-Host "Installing Windows Updates.."
	Write-Output (-join('{"message": "', $($update_message), '", "@timestamp": "', $(Get-TimeStamp), '"},')) | Out-file (Join-Path -Path $env:DEN_ROOT -ChildPath ".local\logs\updates.log") -append
	Import-Module PSWindowsUpdate
	Get-WUInstall -AcceptAll -IgnoreUserInput -Confirm:$false
	wmic qfe list
}

function script-update{
	. (Join-Path -Path $script_location -ChildPath "\python\update_scripts.py")
}

function Get-TimeStamp {
    return "{0:yyyy-MM-dd} {0:HH:mm:ss}" -f (Get-Date)
}
Set-Alias -Name time -Value Get-TimeStamp -Description "Gets time stamp"

function zen{  # activates zen-mode
	$zen_cmd = "'function prompt {Write-Host \`"\`" -NoNewline -ForegroundColor white;\`"% \`";Write-Host \`" \`" -NoNewline -ForegroundColor white};cls'"
	$zenmode = $powershell_location + "\PowerShell.exe -NoLogo -NoExit -Command " + $zen_cmd + " -new_console:t:zen -new_console:W:'" + $console + "\console_zen.png' -new_console:C:" + $icons + "\zen.ico"
	iex $zenmode
}

function shell{
	$newtab = $powershell_location + "\PowerShell.exe -NoLogo -NoExit -new_console:t:PowerShell -new_console:W:'" + $console + "\console.png' -new_console:C:" + $icons + "\soila.ico"
	iex $newtab
}
Set-Alias -Name newtab -Value shell -Description "opens new tab"

# are you admin [BOOL] ?
function isadmin {[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")}

function cfg { set-location $env:DEN_ROOT }  # config (DEN) folder

function scripts { set-location $env:DEN_ROOT\scripts }

# edit powershell_profile in notepad
function powershell_config { notepad++ "$env:DEN_ROOT\scripts\powershell\Microsoft.PowerShell_profile.ps1" }
Set-Alias -Name config -Value powershell_config -Description "edit Powershell-Profile"

function alias_config { notepad++ "$env:DEN_ROOT\scripts\powershell\limbs\aliases.ps1" }
Set-Alias -Name aliases -Value alias_config -Description "edit Powershell-Aliases"

function sysinfo {
	Get-WmiObject Win32_processor | ft -AutoSize Name,MaxClockSpeed,NumberOfCores
	Get-WMIObject Win32_Physicalmemory | ft -AutoSize Manufacturer,PartNumber,Configuredclockspeed,Capacity
	Get-WmiObject Win32_VideoController | ft -AutoSize Name,AdapterRAM,DriverVersion
	Get-WmiObject Win32_BaseBoard | ft -AutoSize Manufacturer,Product
	Get-WmiObject win32_bios | ft -AutoSize Manufacturer,Version,Name
}

function ver {
	$name = (Get-WmiObject Win32_OperatingSystem).caption
	$bit = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
	$ver = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
	$build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx
	Write-Host $name, $bit, " Version:", $ver, "- Build:", $build
}

# link <destination> <target>               create a junction
function link($destination,$target){New-Item -Path $destination -ItemType Junction -Value $target}

function ip { (Invoke-WebRequest -uri "http://ident.me").Content }

function envs {gci env:* | sort-object name }  # -Description "displays all environment variables"
Set-Alias listenvs envs

function noadmin { . $env:DEN_ROOT\scripts\powershell\commands\shell_no_admin.ps1 }

function restart { . $env:DEN_ROOT\scripts\batch\cmder_restart.bat }

function spool { . $env:DEN_ROOT\scripts\batch\printer_restart.bat }