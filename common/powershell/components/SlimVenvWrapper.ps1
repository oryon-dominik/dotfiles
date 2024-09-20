# Virtualenvwrapper aliases for powershell

# https://docs.python.org/3/library/venv.html
# create a new venv
function mkvirtualenv ([parameter(mandatory=$true)] [string] $venvName) {
    $venvDir = "$env:WORKON_HOME/$venvName"
    if (Test-Path -Path $venvDir) {
        Write-Host "Virtualenv $venvName already exists."
    } else {
        $pythonVersion = (python --version)
        Write-Host "Creating $pythonVersion virtualenv '$venvName'..."
        # optional: venv.EnvBuilder.create(env_dir)
        python -m venv $venvDir
    }
}

# activate a venv
# venvName is a powershell-function running a python script and should have been loaded previously
function workon ($venvName, $legacy = $false ) {
    # check local .venv directories first
    $venvDir = ".venv"
    if (Test-Path -Path $venvDir) {
        . (Join-Path -Path "$venvDir" -ChildPath "Scripts/activate.ps1")
        return
    }
    $venvDir = "application/.venv"
    if (Test-Path -Path $venvDir) {
        . (Join-Path -Path "$venvDir" -ChildPath "Scripts/activate.ps1")
        return
    }

    if ($venvName -eq $null) {
        if ($legacy) {
            $venvName = (venvNameLegacy)
        } else {
            $venvName = (venvName)
        }
    } 
    $venvDir = "$env:WORKON_HOME/$venvName"
    if (Test-Path -Path $venvDir) {
        . (Join-Path -Path "$venvDir" -ChildPath "Scripts/activate.ps1")
        return
    }
    Write-Host "Could not find venv: $venvName."
}

# deactivate is not needed, as it is automatically added by the activate.ps1 Script.

# list all venvs
function lsvirtualenv {
    $venvsDir = $env:WORKON_HOME
    if (Test-Path -Path $venvsDir) {
        $venvDirs = Get-ChildItem -Path $venvsDir -Directory
        $venvs = foreach ($venv in $venvDirs) {
            $venvName = $venv.Name
            $pythonVersion = ((Get-Content -Path "$env:WORKON_HOME/$venvName/pyvenv.cfg" -TotalCount 1) -split '\\')[-1]
            @{Name=$venvName;PythonVersion=$pythonVersion}
        }
        $venvs | % { new-object PSObject -Property $_} | Format-Table -AutoSize -Property Name, Version

    } else {
        Write-Host "No virtualenvs found in $venvsDir."
    }
}

# remove a venv
function rmvirtualenv ($venvName) {
    if ($venvName -eq $null) {
        $venvName = (venvName)
    }
    $venvDir = "$env:WORKON_HOME/$venvName"
    if (Test-Path -Path $venvDir) {
        Write-Host "Removing virtualenv $venvName..."
        Remove-Item -Path $venvDir -Recurse -Force
    } else {
        Write-Host "Could not find venv: $venvName."
    }
}
