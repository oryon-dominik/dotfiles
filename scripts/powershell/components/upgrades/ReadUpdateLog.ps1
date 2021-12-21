# Reads the update log

if (("{0}" -f $env:DOTFILES) -eq "") {
    Write-Host "DOTFILES environment variable not set. Can't find the logfiles."
    return
}

$update_machine_path = (Join-Path -Path $env:DOTFILES -ChildPath "shared\logs\$env:computername\")
if(!(test-path $update_machine_path)) {
    New-Item -ItemType Directory -Force -Path $update_machine_path
}
$update_log_path = (Join-Path -Path $env:DOTFILES -ChildPath "shared\logs\$env:computername\updates.log")
if (!(Test-Path -Path $update_log_path -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $update_log_path
}
$log_last_entry = Get-Content -Path $update_log_path -Tail 1
$log_string = $log_last_entry -replace ".$"
$log = $log_string | ConvertFrom-Json
$now = "{0:yyyy-MM-dd} {0:HH:mm:ss}" -f (Get-Date)
$update_span = New-TimeSpan -Start ($log.timestamp | Get-Date) -End ($now | Get-Date)
#$not_updated_since = [int]($update_span.days)
if ($update_span.days -gt 14) {
    Write-Host "Last" $log.message "on:" $log.timestamp ", please 'upgrade' now"
}
