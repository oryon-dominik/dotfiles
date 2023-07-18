

# TODO: Windows installations have to manually get
# https://win.rustup.rs/x86_64
# other installations have to rustup.rs and install 
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
Write-Error "Not Implemented (yet)"


# ensure latest rust/cargo
rustup update

# additional cargo tools and commands

cargo install cargo-edit
# or use the vendored version
cargo install cargo-edit --features vendored-openssl

cargo install cargo-expand
