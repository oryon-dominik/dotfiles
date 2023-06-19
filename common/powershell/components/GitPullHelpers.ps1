# Pull the obisdian journal on demand to avoid merge conflicts every single day..
function pullJournal {
    $journalDir = $env:JOURNAL_HOME
    if (-not (Test-Path $journalDir)) {
        Write-Host "env:JOURNAL_HOME is not defined."
        return
    }
    GitPullfromDirectory -directory $journalDir
}

function pullDotfiles {
    $dotfilesDir = $env:DOTFILES
    if (-not (Test-Path $dotfilesDir)) {
        Write-Host "env:DOTFILES is not defined."
        return
    }
    GitPullfromDirectory -directory $dotfilesDir
}

function GitPullfromDirectory {
    param(
        [Parameter(Mandatory=$true)]
        [string]$directory
    )

    if (Test-Path -Path $directory) {
        Write-Host "Pulling from $directory"
        cd $directory
        git pull
        cd -
    } else {
        Write-Host "No repository found in $directory"
    }
}

function GitPullOnceADayAndWorkingMachine {
    if (-not (Test-Path $env:DOTFILES)) {
        Write-Host "env:DOTFILES is not defined."
        return
    }
    $computerName = [System.Environment]::MachineName
    $eventslog = "$env:DOTFILES/shared/logs/global/auto-gitevents.log"
    if (-not (Test-Path $eventslog)) {
        New-Item -Path $eventslog -ItemType File
    }
    $today = Get-Date -Format "yyyy-MM-dd"
    $message = "$today 'once-a-day' git pull on $computerName"
    $lastExecutionDate = Get-Content -Path $eventslog -ErrorAction SilentlyContinue | Select-Object -Last 1
    if ($message -ne $lastExecutionDate) {
        # Pulling the "daily" repositories
        pullDotfiles
        pullJournal
        # Store the current date as the last execution date, silently
        Add-Content -Path $eventslog -Value $message | Out-Null
    } else {
        # "Already pulled today"
    }
}
