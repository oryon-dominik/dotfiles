function pulljournal {
    $journalDir = $env:JOURNAL_HOME
    Write-Host "Pulling journal from $journalDir"
    if ((($journalDir -ne $null) -or ($journalDir -ne "")) -And (Test-Path -Path $journalDir)) {
        cd $journalDir
        git pull
        cd -
    } else {
        Write-Host "No journal found in $journalDir"
    }
}
