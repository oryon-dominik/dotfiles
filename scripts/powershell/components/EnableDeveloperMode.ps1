# Enables the Developer Mode in Windows 10
param([Switch]$WaitForKey)

if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10)
{
    Write-Host -ForegroundColor Red "The DeveloperMode is only supported on Windows 10."
    return
}

$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if (!$is_elevated) {
    Write-Host -ForegroundColor Red "Adminstrator elevation required to activate development mode."
    return
}

$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (! (Test-Path -Path $RegistryKeyPath)) {
    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}
if (! (Get-ItemProperty -Path $RegistryKeyPath | Select -ExpandProperty AllowDevelopmentWithoutDevLicense)) {
    # Add registry value to enable Developer Mode
    New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
}
