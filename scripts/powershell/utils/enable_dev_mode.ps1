param([Switch]$WaitForKey)

if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10)
{
    Write-Host -ForegroundColor Red "The DeveloperMode is only supported on Windows 10"
    Break
}

# Get the ID and security principal of the current user account
$WindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$WindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($WindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($WindowsPrincipal.IsInRole($adminRole))
{
    $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    if (! (Test-Path -Path $RegistryKeyPath)) 
    {
        New-Item -Path $RegistryKeyPath -ItemType Directory -Force
    }

    if (! (Get-ItemProperty -Path $RegistryKeyPath | Select -ExpandProperty AllowDevelopmentWithoutDevLicense))
    {
        # Add registry value to enable Developer Mode
        New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
    }
}
else {
    Write-Host -ForegroundColor Red "Administrator elevation needed to activate development mode"
    Break
}
