#!/usr/bin/env pwsh

# Installs the symbolic links for the programs that come with these dotfiles on windows.

# Classic powershell and the powershell 7 profile
# ! This should have been already linked via the tutorial / install script, so no need for duplication here.
# . "$env:DOTFILES\install\windows\SymlinkPowershell.ps1"
# SymlinkPowershell

# gitconfig
# . "$env:DOTFILES\install\windows\SetupGit.ps1"
# SymlinkGitConfigFromDotfiles

# starship
New-Item -Path $HOME/.config/starship.toml -ItemType SymbolicLink -Value "$env:DOTFILES/common/starship/starship.toml"

# vim
Move-Item -Path "$env:SystemDrive/tools/vim/_vimrc" -Destination "$env:SystemDrive/tools/vim/_backup_vimrc"
New-Item -Path "$env:SystemDrive/tools/vim/.vimrc" -ItemType SymbolicLink -Value "$env:DOTFILES/common/vim/.vimrc"
New-Item -Path "$env:USERPROFILE/.config/vim" -ItemType Junction -Value "$env:DOTFILES/common/vim/vimfiles"
New-Item -Path "$env:USERPROFILE/.config/vim" -Name "cache" -ItemType "directory" -Force

# alacritty
New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"


# TBD: do I use and need geany and micro? I don't think so.
# geany
# New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/geany.conf" -ItemType SymbolicLink -Value "$env:DOTFILES/common/geany/geany.conf"
# New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/geany/colorschemes"

# micro
New-Item -Path "$env:USERPROFILE/.config/micro/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/micro/colorschemes"
New-Item -Path "$env:USERPROFILE/.config/micro/settings.json" -ItemType SymbolicLink -Value "$env:DOTFILES/common/micro/settings.json"
