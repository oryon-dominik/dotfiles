
# is python installed?
$python_on_path_error_message = (&{python -V}).Exception.Message
if ($python_on_path_error_message -ne $null) {
    Write-Host "Could not find a python version Installed."
    Write-Host $python_on_path_error_message
    return
}
# is pyenv used? (we're manually buílding the python-path here)
if (-not (Test-Path env:PYENV_HOME)) {
    Write-Host "No PYENV_HOME environment variable set."
    Write-Host "Python versions outside of pyenv are not supported yet."
    Write-Host "Feel free to file a pull-request though :)."
    return
}

# get the correct path from active python
$python_version = (&{python -V})
$_, $version = $python_version -split ' '
$version_path = Join-Path $env:PYENV_HOME -ChildPath "versions" | Join-Path -ChildPath $version

# is the speedtest-cli available?
$speedtest_module_path = Join-Path $version_path -ChildPath "Lib\site-packages\speedtest.py"
if (-not (Test-Path $speedtest_module_path)) {
    Write-Host "Python Module for Speedtest not found"
    Write-Host "Install with: 'pip install speedtest-cli'"
    return
}

# is the executable available in python's script path
$speedtest_script_path = Join-Path $version_path -ChildPath "Scripts\speedtest.exe"
if (-not (Test-Path $speedtest_script_path)) {
    Write-Host "Python Script for Speedtest not found"
    Write-Host "Install with: 'pip install speedtest-cli'"
    return
}

# run the speedtest
& $speedtest_script_path
