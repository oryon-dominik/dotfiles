# reads the update log

# requirements:
# $env:DEN_ROOT has to be set to your configs location
# the path below may be customized
$update_logs = "\local\logs\$env:computername\updates.log"

$log_path = Join-Path -Path $env:DEN_ROOT -ChildPath $update_logs
if (Test-Path $log_path) { 
    $log_last_entry = Get-Content -Path $log_path -Tail 1 
    $log_string = $log_last_entry -replace ".$"    
    $log = $log_string | ConvertFrom-Json
    $now = "{0:yyyy-MM-dd} {0:HH:mm:ss}" -f (Get-Date)
    $update_span = New-TimeSpan -Start ($log.timestamp | Get-Date) -End ($now | Get-Date)
    #$not_updated_since = [int]($update_span.days)
    if ($update_span.days -gt 14) {
        Write-Host "Last" $log.message "on:" $log.timestamp ", please 'upgrade' now"
    }
}
else{
    Write-Host "Update log not found @ $log_path - you should create it"
}
