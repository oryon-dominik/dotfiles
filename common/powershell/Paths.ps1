#!/usr/bin/env pwsh


# TODO: Check if envs exist or throw errors.
$env:path += ";$env:Programfiles\VideoLAN\VLC\vlc.exe"
$env:path += ";$env:Programfiles\NASM"  # netwide-assembler
$env:path += ";$env:Programfiles\GTK3-Runtime Win64\bin"  # gtk3 (used for weasyprint)
$env:path += ";$env:DOTFILES\bin"  # local binaries
$env:path += ";$script_location\batch"
$env:path += ";$env:USERPROFILE\.cargo\bin\"  # rust commands
$env:path += ";$env:PYENV_HOME\versions\$env:GLOBAL_PYTHON_VERSION\scripts\"  # python scripts
$env:path += ";$env:USERPROFILE\go\bin\"  # go commands
$env:path += ";$env:POETRY_HOME\bin"  # python poetry
$env:path += ";$env:SCOOP\apps\scoop\current\bin\;$env:SCOOP\shims\"
$env:path += ";$env:YARN_GLOBAL_HOME\bin"
