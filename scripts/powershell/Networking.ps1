function rust_scan { docker run -it --rm --name rustscan rustscan/rustscan:latest $args }
Set-Alias -Name rustscan -Value rust_scan -Description  "Scan ip address open ports <arguments> <ip address to scan>"
