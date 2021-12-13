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

## Rust modules
Write-Host "Installing Rust modules..."
# bottom (process/system visualization)
cargo install bottom
# procs (process/system visualization)
cargo install procs
# lsDeluxe # TODO: add config form local to: %appdata%\lsd\config.yaml
cargo install lsd
# dust - disk usage
cargo install du-dust
# hyperfine - CLI benchmarking
cargo install hyperfine

cargo install xh
cargo install broot
cargo install tealdeer
cargo install grex
cargo install dog
cargo install bandwhich
cargo install tokei
cargo install choose

# git clone https://github.com/ogham/dog
# cd dog
# cargo install --path . --force

## curlie
# download tarball from https://github.com/rs/curlie/releases/tag/v1.6.7
# unzip twice.. put into your users /bin

## cheat
go get -u github.com/cheat/cheat/cmd/cheat


# gtop (process/system visualization)
npm install gtop -g

Write-Host "Install this additional packages from github to cargo binaries:"
Write-Host "$(Join-Path -Path $env:USERPROFILE -ChildPath "\.cargo\bin\")"

Write-Host "dog - dns lookup"
Write-Host "https://github.com/ogham/dog/releases/download/v0.1.0/dog-v0.1.0-x86_64-pc-windows-msvc.zip"
Write-Host ""
Write-Host "jq - "
Write-Host "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe"
