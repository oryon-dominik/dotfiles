# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on zoxide's format.
function __zoxide_pwd {
    $__zoxide_pwd = Get-Location
    if ($__zoxide_pwd.Provider.Name -eq "FileSystem") {
        $__zoxide_pwd.ProviderPath
    }
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd($dir) {
    Set-Location $dir -ea Stop
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook {
    $result = __zoxide_pwd
    if ($null -ne $result) {
        zoxide add -- $result
    }
}

# Initialize hook.

$__zoxide_hooked = (Get-Variable __zoxide_hooked -ValueOnly -ErrorAction SilentlyContinue)
if ($__zoxide_hooked -ne 1) {
    $__zoxide_hooked = 1
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $ExecutionContext.InvokeCommand.LocationChangedAction = {
            $null = __zoxide_hook
        }
    }
    else {
        Write-Error ("`n" +
            "zoxide: PWD hooks are not supported below powershell 6.`n" +
            "        Use 'zoxide init powershell --hook prompt' instead.")
    }
}

# =============================================================================
#
# When using zoxide with --no-aliases, alias these internal functions as
# desired.
#

# Jump to a directory using only keywords.
function __zoxide_z {
    if ($args.Length -eq 0) {
        __zoxide_cd ~
    }
    elseif ($args.Length -eq 1 -and $args[0] -eq '-') {
        __zoxide_cd -
    }
    elseif ($args.Length -eq 1 -and (Test-Path $args[0] -PathType Container)) {
        __zoxide_cd $args[0]
    }
    else {
        $result = __zoxide_pwd
        if ($null -ne $result) {
            $result = zoxide query --exclude $result -- @args
        }
        else {
            $result = zoxide query -- @args
        }
        if ($LASTEXITCODE -eq 0) {
            __zoxide_cd $result
        }
    }
}

# Jump to a directory using interactive search.
function __zoxide_zi {
    $result = zoxide query -i -- @args
    if ($LASTEXITCODE -eq 0) {
        __zoxide_cd $result
    }
}

# =============================================================================
#
# Convenient aliases for zoxide. Disable these using --no-aliases.
#

Set-Alias -Name z -Value __zoxide_z -Option AllScope
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope

# =============================================================================
#
# To initialize zoxide, add this to your configuration (find it by running
# `echo $profile` in PowerShell):
#
Invoke-Expression "$env:CARGO_HOME\bin\zoxide.exe init powershell --hook 'pwd'" | out-null
