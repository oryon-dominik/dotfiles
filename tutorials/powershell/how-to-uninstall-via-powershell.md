# uninstall via powershell

Check which objects to uninstall
`Get-WmiObject -Class win32_product -ComputerName $env:computername`

Filter by Name
`Get-WmiObject -Class win32_product -ComputerName $env:computername -Filter "Name like '%YOURSEARCHCRITERIA%'"`

Uninstall
`Get-WmiObject -Class win32_product -ComputerName $env:computername -Filter "Name like '%YOURSEARCHCRITERIA%'" | ForEach-Object { $_.Uninstall()}`
