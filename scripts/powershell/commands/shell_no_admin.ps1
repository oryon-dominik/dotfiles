$shell = "powershell.exe"
$taskname = "Launch $shell"
$action = New-ScheduledTaskAction -Execute $shell
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskname | Out-Null
Start-ScheduledTask -TaskName $taskname
Start-Sleep -s 1
Unregister-ScheduledTask -TaskName $taskname -Confirm:$false
