$env:path += ";$env:Programfiles\VideoLAN\VLC\vlc.exe"
$env:path += ";$env:Programfiles\NASM"  # netwide-assembler
$env:path += ";$env:Programfiles\GTK3-Runtime Win64\bin"  # gtk3 (used for weasyprint)
$env:path += ";$(Join-Path -Path "$env:DOTFILES" -ChildPath "\bin")"  # local binaries
$env:path += ";$(Join-Path -Path "$script_location" -ChildPath "\batch")"
$env:path += ";$(Join-Path -Path "$env:USERPROFILE" -ChildPath "\.cargo\bin\")"  # rust commands
$env:path += ";$(Join-Path -Path "$env:PYENV_HOME" -ChildPath "\versions\$env:GLOBAL_PYTHON_VERSION\scripts\")"  # python scripts
$env:path += ";$(Join-Path -Path "$env:USERPROFILE" -ChildPath "\go\bin\")"  # go commands
$env:path += ";$(Join-Path -Path "$env:POETRY_HOME" -ChildPath "\bin")"  # python poetry
# $env:path += ";$(Join-Path -Path "$env:USERPROFILE" -ChildPath "\AppData\Roaming\npm\")"  # npm
if ($env:DOTFILES_SKIP_YARN -eq $false) {
    $env:path += ";$(yarn global bin)"
}
$env:path += ";$env:SCOOP\apps\scoop\current\bin\;$env:SCOOP\shims\"
