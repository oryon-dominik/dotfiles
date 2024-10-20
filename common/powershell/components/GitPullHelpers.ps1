# Pull the obisdian journal on demand to avoid merge conflicts every single day..
function pullJournal {
    $journalDir = $env:JOURNAL_HOME
    if (($journalDir -eq $null) -or (-not (Test-Path $journalDir))) {
        Write-Host "env:JOURNAL_HOME is not defined. Can't sync the journal."
        Write-Host "You can define it in your .env file."
        Write-Host 'AddToDotenv -path "$env:DOTFILES\.env" -key "JOURNAL_HOME" -value "C:\dev\journal" -overwrite $false -warn $false'
        return
    }
    GitPullfromDirectory -directory $journalDir
}

function pullDotfiles {
    $dotfilesDir = $env:DOTFILES
    $sharedDir = $env:DOTFILES_SHARED
    if (($dotfilesDir -eq $null) -or (-not (Test-Path $dotfilesDir))) {
        Write-Host "env:DOTFILES is not defined. Can't pull."
        return
    }
    GitPullfromDirectory -directory $dotfilesDir
    if (($sharedDir -eq $null) -or (-not (Test-Path $sharedDir))) {
        Write-Host "env:DOTFILES_SHARED is not defined. Can't pull."
        return
    }
    GitPullfromDirectory -directory $sharedDir
}

function GitPullfromDirectory {
    param(
        [Parameter(Mandatory=$true)]
        [string]$directory
    )

    if (Test-Path -Path $directory) {
        Write-Host "Pulling from '$directory'."
        cd $directory
        try {
            git pull
        } catch {
            Write-Host "Failed to pull from '$directory'."
        }
        cd -
    } else {
        Write-Host "No repository found in '$directory'."
    }
}

function GitPullOnceADayAndWorkingMachine {
    if (-not (Test-Path $env:DOTFILES)) {
        Write-Host "env:DOTFILES is not defined."
        return
    }
    $computerName = [System.Environment]::MachineName
    $eventslogdir = "$env:DOTFILES_SHARED/logs/global"
    $eventslog = "$eventslogdir/auto-gitevents.log"
    if (-not (Test-Path $eventslog)) {
        New-Item -Path $eventslog -ItemType File
    }

    $today = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
    $message = "$today 'once-a-day' git pull on $computerName"
    $lastExecutionMessage = Get-Content -Path $eventslog -ErrorAction SilentlyContinue | Select-Object -Last 1
    $lastExecutionDate = $lastExecutionMessage -split " " | Select-Object -Index 0
    $lastExecutionMachine = $lastExecutionMessage -split " " | Select-Object -Index 6

    if ($message -notlike "$lastExecutionDate* $lastExecutionMachine") {
        # Pulling the "daily" repositories
        pullDotfiles
        pullJournal
        # Sort the log entries by date. (by regexing the first 19 characters of a line, (the dateformat's length))
        $logEntries = (Get-Content -Path $eventslog | Sort-Object {$_ -replace '^(.{19}).*', '$1'})
        $logEntries | Set-Content -Path $eventslog
        # Store the current date as the last execution date, silently
        Add-Content -Path $eventslog -Value $message | Out-Null
        [IO.File]::WriteAllText($eventslog, ([IO.File]::ReadAllText($eventslog) -replace "`r`n","`n"))
        cd $eventslogdir
        git add auto-gitevents.log
        git commit -m "auto-commit: $message"
        cd -
    } else {
        # "Already pulled today"
    }
}
