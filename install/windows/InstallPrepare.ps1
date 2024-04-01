#!/usr/bin/env pwsh

$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = [bool]$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if ($isAdmin -eq $true) {
    Write-Host "This script should not be run with administrative privileges. Please run as unprivileged user."
    return
}

# Check if the DOTFILES directory is set.
if (($env:DOTFILES -eq $null) -or ($env:DOTFILES -eq "")) {
    Write-Host "env:DOTFILES is not defined. Can't continue."
    return
}

# Touch a dotenv to store your custom environment variables - valid for powershell sessions only.
$dotenv_path = (Join-Path -Path "$env:DOTFILES" -ChildPath ".env");
if (!(Test-Path -Path $dotenv_path -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $dotenv_path
}

Write-Host "Hopefully you've setup your build-tools (manual download) already."
Write-Host "Selected & installed the C++ toolchain for your architecture (x64/x86)."
Write-Host "If not, you can run the following commands to download and install the build tools."
Write-Host "Invoke-WebRequest https://aka.ms/vs/17/release/vs_BuildTools.exe -OutFile ~\Downloads\vs_BuildTools.exe"
Write-Host "Start-Process ~\Downloads\vs_BuildTools.exe -Verb RunAs"
Write-Host
Write-Host "--- DO IT NOW! ---"
Write-Host

Write-Host "If you want to activate MCFLY by default, you can set the env MCFLY_ISACTIVE to true"
Write-Host 'AddToDotenv -path "$env:DOTFILES\.env" -key "MCFLY_ISACTIVE" -value "true" -overwrite $true -warn $false'
Write-Host

# Fill initial .env
. "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"

# Set the SCOOP directory.
if (($env:SCOOP -eq $null) -or ($env:SCOOP -eq "")) {
    $env:SCOOP = "$env:USERPROFILE\scoop\"
}
Write-Host "Setting scoop directory to $env:SCOOP."
AddToDotenv -path "$env:DOTFILES\.env" -key "SCOOP" -value "$env:SCOOP" -overwrite $false -warn $false
Write-Host

# Set the DOTFILES_SHARED directory.
if (($env:DOTFILES_SHARED -eq $null) -or ($env:DOTFILES_SHARED -eq "")) {
    $env:DOTFILES_SHARED = "$env:DOTFILES\shared\"
}
Write-Host "Setting DOTFILES_SHARED directory to $env:DOTFILES_SHARED."
AddToDotenv -path "$env:DOTFILES\.env" -key "DOTFILES_SHARED" -value "$env:DOTFILES_SHARED" -overwrite $false -warn $false
Write-Host

# Set the SHELL to pwsh.
if (($env:SHELL -eq $null) -or ($env:SHELL -eq "")) {
    $env:SHELL = "C:\Program Files\PowerShell\7\pwsh.exe"
}
Write-Host "Setting shell to pwsh."
AddToDotenv -path "$env:DOTFILES\.env" -key "SHELL" -value $env:SHELL -overwrite $false -warn $false
Write-Host

# Disable virtualenv prompt to use my custom prompt.
Write-Host "Disabling virtualenv default prompt to use starship's prompt."
AddToDotenv -path "$env:DOTFILES\.env" -key "VIRTUAL_ENV_DISABLE_PROMPT" -value "1" -overwrite $false -warn $false
Write-Host

# Mcfly/powershell history.
Write-Host "Set up powershell/MCFLY history location."
AddToDotenv -path "$env:DOTFILES\.env" -key "HISTFILE" -value "$($env:DOTFILES)\.history" -overwrite $false -warn $false
Write-Host

# Git test debug unsafe.
Write-Host "Git outputs more vebose test debug for unsafe directories."
AddToDotenv -path "$env:DOTFILES\.env" -key "GIT_TEST_DEBUG_UNSAFE_DIRECTORIES" -value "true" -overwrite $false -warn $false
Write-Host

# We want to add the devices location occassionally by default.
Write-Host "Dotfiles may know where you are."
AddToDotenv -path "$env:DOTFILES\.env" -key "DOTFILES_SKIP_DEVICE_LOCATION" -value "false" -overwrite $false -warn $false
Write-Host

# Yarn should be installed (soon).
Write-Host "Yarn should be installed."
AddToDotenv -path "$env:DOTFILES\.env" -key "DOTFILES_SKIP_YARN" -value "false" -overwrite $false -warn $false
Write-Host

# Set the editor to 'code -w' by default.
Write-Host "Setting the editor to 'code -w' by default."
if (($env:EDITOR -eq $null) -or ($env:EDITOR -eq "")) {
    $env:EDITOR = "code -w"
}
AddToDotenv -path "$env:DOTFILES\.env" -key "EDITOR" -value $env:EDITOR -overwrite $false -warn $false
Write-Host

# Cloud storage mount point is empty by default.
Write-Host "Cloud storage mount point is empty by default. Example:"
Write-Host 'AddToDotenv -path "$env:DOTFILES\.env" -key "CLOUD_MOINT_POINT" -value "X:/Meine Ablage/" -overwrite $true -warn $false'
AddToDotenv -path "$env:DOTFILES\.env" -key "CLOUD_MOINT_POINT" -value "" -overwrite $false -warn $false
Write-Host

# Projects directory is empty by default.
Write-Host "Projects directory is 'C:/dev' by default. Example:"
Write-Host 'AddToDotenv -path "$env:DOTFILES\.env" -key "PROJECTS" -value "C:/yourplace" -overwrite $true -warn $false'
AddToDotenv -path "$env:DOTFILES\.env" -key "PROJECTS" -value "C:/dev" -overwrite $false -warn $false
Write-Host

Write-Host "$env:PROJECTS will be created now if it does not exist. Delete, if you want to change the location."
# Create projects directory.
if (($env:PROJECTS -ne $null) -and !(Test-Path $env:PROJECTS -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $env:PROJECTS
}
Write-Host

# Create shared global logs directory and the file the global log will be written to.
if (($env:DOTFILES_SHARED -ne $null) -and !(Test-Path "$env:DOTFILES_SHARED" -PathType Container)) {
    New-Item -ItemType Directory -Force -Path "$env:DOTFILES_SHARED"
    # This is a workaround to work on systems that do not have access to the 'shared' repo.
    # Will create an empty git repository in the shared directory (git force clone
    # will overwrite this "mocked shared dir" later, if access is granted).
    cd "$env:DOTFILES_SHARED"
    git init
    cd -
    New-Item -ItemType Directory -Force -Path "$env:DOTFILES_SHARED\logs\global"
    New-Item -ItemType File -Force -Path "$env:DOTFILES_SHARED\logs\global\auto-gitevents.log"
}

Write-Host "Done :)"

Write-Host "Re-open a shell as admin and run the admin-installation script."
Write-Host '(as admin) iex "$env:DOTFILES/install/windows/InstallAsAdmin.ps1"'
Write-Host
Write-Host "When that finished you can run the user-installation scripts for adding all software in a NEW shell-instance.."
Write-Host '. "$env:DOTFILES/install/windows/InstallAllSoftware.ps1"'
Write-Host 'EasyInstall -use_defaults $true'
Write-Host
