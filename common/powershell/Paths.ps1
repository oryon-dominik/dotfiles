#!/usr/bin/env pwsh


# TODO: Check if envs exist or throw errors.
$env:path += ";$env:Programfiles\VideoLAN\VLC\vlc.exe"
$env:path += ";$env:Programfiles\NASM"  # netwide-assembler
$env:path += ";$env:Programfiles\GTK3-Runtime Win64\bin"  # gtk3 (used for weasyprint)
$env:path += ";$env:DOTFILES\bin"  # local binaries
$env:path += ";$script_location\batch"
$env:path += ";$env:CARGO_HOME\bin\"  # rust commands
$env:path += ";$env:UV_PYTHON_INSTALL_DIR\cpython-$env:GLOBAL_PYTHON_VERSION-windows-x86_64-none\"  # global python
$env:path += ";$env:UV_PYTHON_INSTALL_DIR\cpython-$env:GLOBAL_PYTHON_VERSION-windows-x86_64-none\Scripts\"  # global python scripts
$env:path += ";$env:GOPATH\bin\"  # go commands
$env:path += ";$env:SCOOP\apps\scoop\current\bin\;$env:SCOOP\shims\"
$env:path += ";$env:NVM_HOME\nodejs\"
$env:path += ";$env:NVM_HOME\nodejs\nodejs\"
$env:path += ";$env:YARN_GLOBAL_HOME\bin\"
$env:path += ";$env:EDITOR_BASE_DIR\bin\"
