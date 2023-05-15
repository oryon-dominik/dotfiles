function pulljournal {
    $journalDir = $env:JOURNAL_HOME
    if (($journalDir -eq $null) -or ($journalDir -eq "")) {
        Write-Host "env:JOURNAL_HOME is not defined."
        return
    }
    if (Test-Path -Path $journalDir) {
        Write-Host "Pulling journal from $journalDir"
        cd $journalDir
        git pull
        cd -
    } else {
        Write-Host "No journal found in $journalDir"
    }
}
