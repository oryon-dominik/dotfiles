#!/usr/bin/env pwsh

# Installs the symbolic links for the dotfiles on windows.

# classic powershell and the powershell 7 profile
Remove-Item -path "$env:USERPROFILE/Documents/WindowsPowerShell" -recurse
Remove-Item -path "$env:USERPROFILE/Documents/PowerShell" -recurse
New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"

# gitconfig
New-Item -Path $HOME/.gitconfig -ItemType SymbolicLink -Value $HOME/.dotfiles/common/git/.gitconfig
# alacritty
New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"
# starship
New-Item -Path $HOME/.config/starship.toml -ItemType SymbolicLink -Value $HOME/.dotfiles/common/starship/starship.toml
