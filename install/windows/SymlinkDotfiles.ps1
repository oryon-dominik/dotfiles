#!/usr/bin/env pwsh

# Installs the symbolic links for the programs that come with these dotfiles on windows.

# Classic powershell and the powershell 7 profile
# ! This should have been already linked via the tutorial, so no need for duplication here.
# Comment in, if you're using these script as a standalone.
# Remove-Item -path "$env:USERPROFILE/Documents/WindowsPowerShell" -recurse
# Remove-Item -path "$env:USERPROFILE/Documents/PowerShell" -recurse
# New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
# New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"

# gitconfig
New-Item -Path $HOME/.gitconfig -ItemType SymbolicLink -Value "$env:DOTFILES/common/git/.gitconfig"
# vimrc
Move-Item -Path "$env:SystemDrive/tools/vim/_vimrc" -Destination "$env:SystemDrive/tools/vim/_backup_vimrc"
New-Item -Path "$env:SystemDrive/tools/vim/.vimrc" -ItemType SymbolicLink -Value "$env:DOTFILES/common/vim/.vimrc"
New-Item -Path "$env:USERPROFILE/.config/vim" -ItemType Junction -Value "$env:DOTFILES/common/vim/vimfiles"
New-Item -Path "$env:USERPROFILE/.config/vim" -Name "cache" -ItemType "directory" -Force
# alacritty
New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"
# starship
New-Item -Path $HOME/.config/starship.toml -ItemType SymbolicLink -Value "$env:DOTFILES/common/starship/starship.toml"

# geany
New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/geany.conf" -ItemType SymbolicLink -Value "$env:DOTFILES/common/geany/geany.conf"
New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/geany/colorschemes"

New-Item -Path "$env:USERPROFILE/.config/micro/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/micro/colorschemes"
New-Item -Path "$env:USERPROFILE/.config/micro/settings.json" -ItemType SymbolicLink -Value "$env:DOTFILES/common/micro/settings.json"
