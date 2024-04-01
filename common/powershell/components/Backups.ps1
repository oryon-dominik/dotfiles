
# TODO: setup backups on new machine function, to set envs (or .env) - replace hardcoded paths

# restic backups
function restic-apollon {
    $is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if (-not $is_elevated) {
        Write-Warning "Please run backups as root"
    }
    else {
        $REPOSITORY = "G:\backups"
        restic -r $REPOSITORY -p $env:HOME/.secrets/backups $args
    }
}

function backup() {
    if (!$args) { 
        Write-Warning "Please provide a valid path to backup"
        return
    }
    if ( $(Try { Test-Path -Path $args } Catch { $false }) ) {
        restic-apollon --tag custom backup $args
    }
    else {
        Write-Warning "Invalid path. Please provide a valid path to backup"
    }
}

function backups {
    $is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if (-not $is_elevated) {
        Write-Warning "Please run backups as root"
    }
    else {
        Write-Host --------------------------------------------
        Write-Host starting backup at (Get-Date)
        Write-Host --------------------------------------------

        restic-apollon --tag apollon --exclude-file $env:DOTFILES_SHARED\backup\restic-excludefile backup c:\dev d:\keep
        restic-apollon forget --prune --keep-last=7 --keep-daily=30 --keep-weekly=52 --keep-monthly=24 --keep-yearly=10
    }
}
