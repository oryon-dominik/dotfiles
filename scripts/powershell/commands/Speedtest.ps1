# Connection Speedtest using the python module speedtest-cli

# is python installed?
$python_path = whereis python | select -ExpandProperty Source

if ((($python_path).Exception -ne $null) -And ($python_path).Exception.Message.StartsWith("Get-Command: The term '")) {  # is not recognized
    Write-Host "Python is not installed. Please install python and try again."
    exit
}

$pip_path = whereis pip | select -ExpandProperty Source
if ((Split-Path -Path $python_path) -ne (Split-Path -Path $pip_path)) {
    Write-Host "Python and pip paths don't match. Please fix your paths and try again."
    exit
}

$speedtest_Version = pip list | grep speedtest-cli
if ($speedtest_Version -eq "") {
    Write-Host "speedtest-cli is not installed. Please 'pip install speedtest-cli' and try again."
    exit
}

# run the speedtest
& python -W ignore::DeprecationWarning -m speedtest 
