function Reset-Session {
    # store this shell's parent PID for later use
    $parentPID = $PID
    # get the the path of this shell's executable
    $thisExePath = (Get-Process -Id $PID).Path
    # start a new shell, same window
    Start-Process $thisExePath -NoNewWindow
    # stop this shell if it's still alive
    # wait for the new shell to start
    Write-Host "Waiting for new shell to start..."
    Start-Sleep -Seconds 2
    Stop-Process -Id $parentPID -Force
}
