# Reset the Windows Network Address Translation (NAT) settings (fixes some docker connection issues)
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$is_elevated) { Write-Host "Can't reset Windows NAT as unprivileged user." }
else {
    Write-Host "Resetting Windows NAT driver.."
    net stop winnat
    net start winnat
}
