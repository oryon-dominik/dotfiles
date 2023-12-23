#!/usr/bin/env pwsh

# Windows installations could install manually
# https://win.rustup.rs/x86_64
# other installations have to rustup.rs and install 
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

function InstallRustToolchain {
    $installed = @()
    Write-Host "Installing Rust Toolchain... (rustup, cargo, cargo-edit, cargo-expand.) https://www.rust-lang.org/"

    # Install using scoop.
    scoop install main/rustup
    $installed += "rustup"
    scoop update rustup

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

    return $installed
}
