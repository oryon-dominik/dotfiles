# custom prompt
# requires: Modules: posh-git, PSReadline; $settings.cloud set to cloud-directory

# colors
$Host.UI.RawUI.ForegroundColor = "White"
# powershell-error-colors
$Host.PrivateData.ErrorForegroundColor    = "DarkRed"
$Host.PrivateData.ErrorBackgroundColor    = "White"
$Host.PrivateData.WarningForegroundColor  = "DarkMagenta"
$Host.PrivateData.WarningBackgroundColor  = "Black"
$Host.PrivateData.DebugForegroundColor    = "Magenta"
$Host.PrivateData.DebugBackgroundColor    = "Black"
$Host.PrivateData.VerboseForegroundColor  = "Cyan"
$Host.PrivateData.VerboseBackgroundColor  = "Black"
$Host.PrivateData.ProgressForegroundColor = "Yellow"
$Host.PrivateData.ProgressBackgroundColor = "DarkCyan"


# dracula colors
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::White
    "Parameter" = [ConsoleColor]::Magenta
    "Operator" = [ConsoleColor]::Green
    "Variable" = [ConsoleColor]::Red
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}

# prompt
function Prompt
{
	$realLASTEXITCODE = $LASTEXITCODE
	$is_admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
	$promptPre = "PS "
	
	$currentTime = (Get-Date -UFormat '%T')
	$currentFolder = $(Get-Location)
	$currentFolder = [string]$currentFolder
	$currentFolder = $currentFolder.Replace($settings.cloud,'☁')
	$currentFolder = $currentFolder.Replace($home,'~')
	
	$promptEnd = " >"

    if($is_admin -eq "True")
		{Write-Host $promptPre -NoNewline -ForegroundColor magenta}
	else{Write-Host $promptPre -NoNewline -ForegroundColor blue}
	
	Write-Host $env:UserName -NoNewline -ForegroundColor white
	Write-Host "@" -NoNewline -ForegroundColor red
	Write-Host $env:ComputerName -NoNewline -ForegroundColor white
	Write-Host " " -NoNewline
	
	Write-Host "[" -NoNewline -ForegroundColor blue
	Write-Host $currentTime -NoNewline -ForegroundColor white
	Write-Host "] " -NoNewline -ForegroundColor blue
	Write-Host $currentFolder -NoNewline -ForegroundColor yellow
	Write-Host -NoNewline -ForegroundColor yellow
	Write-VcsStatus  # posh-git status, alternative: #& $GitPromptScriptBlock
	Write-Host -NoNewline -ForegroundColor magenta
	Write-Host $promptEnd -NoNewline -ForegroundColor magenta
	Write-Host "" -NoNewline -ForegroundColor yellow
	
	$global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

