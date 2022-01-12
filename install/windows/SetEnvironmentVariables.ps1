# Set neccessary environment variables.

# vim
[Environment]::SetEnvironmentVariable("VIM", "$env:USERPROFILE/.config/vim", "User")
# If installed via chocolatey
[Environment]::SetEnvironmentVariable("VIMRUNTIME", "$env:SystemDrive\tools\vim\vim82", "User")

# bat
[Environment]::SetEnvironmentVariable("BAT_PAGER", "", "User")
[Environment]::SetEnvironmentVariable("BAT_THEME", "Dracula", "User")
