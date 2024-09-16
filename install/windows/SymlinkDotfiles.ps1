#!/usr/bin/env pwsh


function SymlinkDotfiles {
    param (
        [bool]$powershell = $false,
        [bool]$gitconfig = $false,
        [bool]$starship = $true,
        [bool]$uv = $true,
        [bool]$vim = $false,
        [bool]$alacritty = $false,
        [bool]$micro = $false,
        [string]$UserPath = $env:USERPROFILE
    )
    # Installs the symbolic links for the programs that come with these dotfiles on windows.
    if ($powershell -eq $true) {
        # Classic powershell and the powershell 7 profile
        # ! This should have been already linked via the tutorial / install script, so no need for duplication here.
        # TBD: does this require elevation?
        . "$env:DOTFILES/install/windows/SymlinkPowershell.ps1"
        SymlinkPowershell
    }

    if ($gitconfig -eq $true) {
        # gitconfig
        . "$env:DOTFILES/install/windows/SetupGit.ps1"
        SymlinkGitConfigFromDotfiles
    }

    if ($starship -eq $true) {
        # starship
        Remove-Item -path "$UserPath/.config/starship.toml" -recurse -force -ErrorAction SilentlyContinue
        New-Item -Path "$UserPath/.config/starship.toml" -ItemType SymbolicLink -Value "$env:DOTFILES/common/starship/starship.toml"
    }

    if ($uv -eq $true) {
        # uv
        Remove-Item -path "$UserPath/.config/uv.toml" -recurse -force -ErrorAction SilentlyContinue
        New-Item -Path "$UserPath/.config/uv.toml" -ItemType SymbolicLink -Value "$env:DOTFILES/common/python/uv.toml"
    }

    if ($vim -eq $true) {
        # vim
        # TODO: find out the new location after a 'scoop install vim'
        # Move-Item -Path "$env:SystemDrive/tools/vim/_vimrc" -Destination "$env:SystemDrive/tools/vim/_backup_vimrc"
        # New-Item -Path "$env:SystemDrive/tools/vim/.vimrc" -ItemType SymbolicLink -Value "$env:DOTFILES/common/vim/.vimrc"
        Remove-Item -path "$UserPath/.config/vim" -recurse -force -ErrorAction SilentlyContinue
        New-Item -Path "$UserPath/.config/vim" -ItemType Junction -Value "$env:DOTFILES/common/vim/vimfiles"
        New-Item -Path "$UserPath/.config/vim" -Name "cache" -ItemType "directory" -Force
    }

    if ($alacritty -eq $true) {
        # alacritty
        Remove-Item -path "$env:APPDATA/alacritty" -recurse -force -ErrorAction SilentlyContinue
        New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"
    }

    if ($micro -eq $true) {
        # micro
        Remove-Item -path "$UserPath/.config/micro" -recurse -force -ErrorAction SilentlyContinue
        New-Item -Path "$UserPath/.config" -Name "micro" -ItemType "directory" -Force
        New-Item -Path "$UserPath/.config/micro/colorschemes" -ItemType Junction -Value "$env:DOTFILES/common/micro/colorschemes"
        New-Item -Path "$UserPath/.config/micro/settings.json" -ItemType SymbolicLink -Value "$env:DOTFILES/common/micro/settings.json"
    }
}
