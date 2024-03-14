#!/usr/bin/env pwsh


function SymlinkDotfiles {
    param (
        [bool]$powershell = $false,
        [bool]$gitconfig = $false,
        [bool]$starship = $true,
        [bool]$vim = $false,
        [bool]$alacritty = $false,
        [bool]$micro = $false
    )
    # Installs the symbolic links for the programs that come with these dotfiles on windows.
    if ($powershell -eq $true) {
        # Classic powershell and the powershell 7 profile
        # ! This should have been already linked via the tutorial / install script, so no need for duplication here.
        # TBD: does this require elevation?
        . "$env:DOTFILES\install\windows\SymlinkPowershell.ps1"
        SymlinkPowershell
    }

    if ($gitconfig -eq $true) {
        # gitconfig
        . "$env:DOTFILES\install\windows\SetupGit.ps1"
        SymlinkGitConfigFromDotfiles
    }

    if ($starship -eq $true) {
        # starship
        New-Item -Path "$env:USERPROFILE/.config/starship.toml" -ItemType SymbolicLink -Value "$env:DOTFILES\common\starship\starship.toml"
    }

    if ($vim -eq $true) {
        # vim
        # TODO: find out the new location after a 'scoop install vim'
        # Move-Item -Path "$env:SystemDrive/tools/vim/_vimrc" -Destination "$env:SystemDrive/tools/vim/_backup_vimrc"
        # New-Item -Path "$env:SystemDrive/tools/vim/.vimrc" -ItemType SymbolicLink -Value "$env:DOTFILES\common\vim\.vimrc"
        New-Item -Path "$env:USERPROFILE/.config/vim" -ItemType Junction -Value "$env:DOTFILES\common\vim\vimfiles"
        New-Item -Path "$env:USERPROFILE/.config/vim" -Name "cache" -ItemType "directory" -Force
    }

    if ($alacritty -eq $true) {
        # alacritty
        New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES\common/alacritty"
    }

    if ($micro -eq $true) {
        # micro
        New-Item -Path "$env:USERPROFILE/.config/micro/colorschemes" -ItemType Junction -Value "$env:DOTFILES\common/micro/colorschemes"
        New-Item -Path "$env:USERPROFILE/.config/micro/settings.json" -ItemType SymbolicLink -Value "$env:DOTFILES\common/micro/settings.json"
    }

    # proabalby deprecated
    # geany
    # New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/geany.conf" -ItemType SymbolicLink -Value "$env:DOTFILES/common/geany/geany.conf"
    # New-Item -Path "$env:USERPROFILE/AppData/Roaming/geany/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/geany/colorschemes"

}
