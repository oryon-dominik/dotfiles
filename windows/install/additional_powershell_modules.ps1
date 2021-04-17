# Install-Module -Name Pscx -Scope CurrentUser
Install-Module -Name PowerShellGet -Force -Scope CurrentUser
Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
Install-Module -Name PowerBash -Force -Scope CurrentUser
Install-Module -Name Find-String -Force -Scope CurrentUser
Install-Module -Name DockerCompletion -Force -Scope CurrentUser
Install-Module -Name PSReadLine -Force -Scope CurrentUser
Install-Module -Name Get-ChildItemColor -Force -AllowClobber -Scope CurrentUser
# Install-Module -Name GoogleCloud -Force -Scope CurrentUser
Install-Module -Name lolcat -Force -Scope CurrentUser
Install-Module -Name PSFzf  -Force -Scope CurrentUser
Install-Script -Name Speedtest -Force -Scope CurrentUser

# FzF options
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
