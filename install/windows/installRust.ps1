Write-Host "Installing Rust Toolchain... (rustup, cargo, cargo-edit, cargo-expand.) https://www.rust-lang.org/"

# Windows installations could install manually
# https://win.rustup.rs/x86_64
# other installations have to rustup.rs and install 
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install using scoop:
scoop install main/rustup
scoop update rustup

# ensure latest rust/cargo
rustup update

# additional cargo tools and commands

cargo install cargo-edit
# or use the vendored version to provide openssl out of the box
# cargo install cargo-edit --features vendored-openssl

cargo install cargo-expand
