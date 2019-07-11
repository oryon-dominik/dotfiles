# custom prompt
# requires: posh-git, $settings.cloud set to cloud-directory

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
	
	$global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}
