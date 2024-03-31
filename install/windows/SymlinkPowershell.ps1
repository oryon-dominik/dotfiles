
function SymlinkPowershell {
    param(
        [string]$UserPath = $env:USERPROFILE
    )
    # Symlink dotfiles to the old powershell profile
    Remove-Item -path "$UserPath/Documents/WindowsPowerShell" -recurse -force -ErrorAction SilentlyContinue
    New-Item -Path "$UserPath/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
    # And the powershell 7 profile
    Remove-Item -path "$UserPath/Documents/PowerShell" -recurse -force -ErrorAction SilentlyContinue
    New-Item -Path "$UserPath/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
}
