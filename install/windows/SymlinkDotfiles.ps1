#!/usr/bin/env pwsh

# Installs the symbolic links for the dotfiles on windows.

# Elevated powershell
$is_elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$is_elevated) { Write-Host "Can't install symbolic links as unprivileged user."; return }

# classic powershell and the powershell 7 profile
Remove-Item -path "$env:USERPROFILE/Documents/WindowsPowerShell" -recurse
Remove-Item -path "$env:USERPROFILE/Documents/PowerShell" -recurse
New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"

# gitconfig
New-Item -Path $HOME/.gitconfig -ItemType SymbolicLink -Value "$env:DOTFILES/common/git/.gitconfig"
# vimrc
New-Item -Path $HOME/.vimrc -ItemType SymbolicLink -Value "$env:DOTFILES/common/vim/.vimrc"
# alacritty
New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"
# starship
New-Item -Path $HOME/.config/starship.toml -ItemType SymbolicLink -Value "$env:DOTFILES/common/starship/starship.toml"

# geany
New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/geany.conf" -ItemType SymbolicLink -Value "$env:DOTFILES/common/geany/geany.conf"
New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/geany/colorschemes"

New-Item -Path "$env:USERPROFILE/.config/micro/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/micro/colorschemes"
New-Item -Path "$env:USERPROFILE/.config/micro/settings.json" -ItemType SymbolicLink -Value "$env:DOTFILES/common/micro/settings.json"