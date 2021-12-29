#!/usr/bin/env pwsh

# Set a new hostname
$hostname = Read-Host -Prompt 'Input your hostname'
Rename-Computer -ComputerName $env:computername -NewName $hostname
Restart-Computer
