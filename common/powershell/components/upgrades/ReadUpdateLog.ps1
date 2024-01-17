

function ReadUpdateLog {
    # Reads the update log and informs if necessary.
    param (
        [int]$span = 14  #  (recommended default timespan for updates)
    )

    # Validations..

    if (("{0}" -f $env:DOTFILES) -eq "") {
        Write-Host "DOTFILES environment variable not set. Can't find the logfiles."
        return
    }

    # Create the shared update path to the machine name if it doesn't exist.
    $update_machine_path = (Join-Path -Path $env:DOTFILES -ChildPath "shared\logs\$env:computername\")
    if(!(test-path $update_machine_path)) {
        New-Item -ItemType Directory -Force -Path $update_machine_path
    }

    # Touch the updates.log update path to the machine name if it doesn't exist.
    $update_log_path = (Join-Path -Path $env:DOTFILES -ChildPath "shared\logs\$env:computername\updates.log")
    if (!(Test-Path -Path $update_log_path -PathType Leaf)) {
        New-Item -ItemType File -Force -Path $update_log_path
    }
    If ((Get-Content -Path $update_log_path) -eq $Null) {
        Write-Host "No updates have been logged yet."
        Write-Host "Type 'upgrade' to start."
        return
    }

    # Read the last entry of the updates.log file.
    $log_last_entry = Get-Content -Path $update_log_path -Tail 1
    $log_entry_date, $log_entry_time, $log_level, $log_entry_message = $log_last_entry -split " "

    Write-Host "Date: $log_entry_date"
    Write-Host "Time: $log_entry_time"
    Write-Host "Level: $log_level"
    Write-Host "Message: $log_entry_message"
    $log = "$log_entry_date $log_entry_time"
    $now = "{0:yyyy-MM-dd} {0:HH:mm:ss}" -f (Get-Date)
    $update_span = New-TimeSpan -Start ($log | Get-Date) -End ($now | Get-Date)
    #$not_updated_since = [int]($update_span.days)
    if ($update_span.days -gt $span) {
        Write-Host "$log_entry_message, please 'upgrade' now."
    }
}
