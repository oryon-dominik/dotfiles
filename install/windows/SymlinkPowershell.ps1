
function SymlinkPowershell {
    # Symlink dotfiles to the old powershell profile
    Remove-Item -path "$env:USERPROFILE/Documents/WindowsPowerShell" -recurse -force -ErrorAction SilentlyContinue
    New-Item -Path "$env:USERPROFILE/Documents/WindowsPowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
    # And the powershell 7 profile
    Remove-Item -path "$env:USERPROFILE/Documents/PowerShell" -recurse -force -ErrorAction SilentlyContinue
    New-Item -Path "$env:USERPROFILE/Documents/PowerShell" -ItemType Junction -Value "$env:DOTFILES/common/powershell"
}
