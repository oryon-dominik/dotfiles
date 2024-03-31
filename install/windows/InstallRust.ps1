#!/usr/bin/env pwsh

# Windows installations could install manually
# https://win.rustup.rs/x86_64
# other installations have to rustup.rs and install 
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

. "$env:DOTFILES\common\powershell\components\DotEnvs.ps1"


function InstallRustToolchain {

    param (
        [string]$cargo_home = $($env:CARGO_HOME),
        [string]$rustup_home = $($env:RUSTUP_HOME)
    )

    $installed = @()
    Write-Host "Installing Rust Toolchain... (rustup, cargo, cargo-edit, cargo-expand.) https://www.rust-lang.org/"

    if ($cargo_home -eq $null) {
        $cargo_home = "$(Join-Path -Path $env:SCOOP -ChildPath 'apps\rustup\current\.cargo\')"
        Write-Host "No 'env:CARGO_HOME' path given. Using default: '$cargo_home'."
    }
    if ($rustup_home -eq $null) {
        $rustup_home = "$(Join-Path -Path $env:SCOOP -ChildPath 'apps\rustup\current\.rustup\')"
        Write-Host "No 'env:CARGO_HOME' path given. Using default: '$rustup_home'."
    }

    # Install using scoop.
    scoop install main/rustup
    $installed += "rustup"
    scoop update rustup

    AddToDotenv -path "$env:DOTFILES\.env" -key "CARGO_HOME" -value "$cargo_home" -overwrite $false -warn $false
    AddToDotenv -path "$env:DOTFILES\.env" -key "RUSTUP_HOME" -value "$rustup_home" -overwrite $false -warn $false

    # Ensure latest rust/cargo.
    rustup update

    # --- Additional cargo tools and commands. ---

    # [cargo-edit - A utility for managing cargo dependencies from CLI.](https://github.com/killercup/cargo-edit)
    cargo install cargo-edit
    $installed += "cargo-edit"
    # or use the vendored version to provide openssl out of the box
    # cargo install cargo-edit --features vendored-openssl
    # [cargo-expand - Subcommand to show result of macro expansion.](https://github.com/dtolnay/cargo-expand)
    cargo install cargo-expand
    $installed += "cargo-expand"

    # [cargo-cache - manage $CARGO_HOME, print and remove selectively](https://github.com/matthiaskrgr/cargo-cache)
    cargo install cargo-cache
    $installed += "cargo-cache"
    cargo-cache --remove-dir all

    return $installed
}
