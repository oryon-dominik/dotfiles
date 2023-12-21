#!/bin/sh

# assumes rust-toolchain and jq installed
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# sudo apt-get install jq

$cratesPath="$DOTFILES/install/crates/cargo-tools.json"
$cratesJsonContent=$(cat "$cratesPath")
$crates=$(echo "$cratesJsonContent" | jq -c '.crates[]')
IFS=$'\n' # Set Internal Field Separator to newline for iteration
for element in $crates; do
    echo ""
    crate=$(echo "$element" | jq -r '.crate')
    os=$(echo "$element" | jq -r '.os')
    if [ -z "$os" ] || [ "$os" = "posix" ]; then
        echo "Installing $crate..."
        cargo install "$crate"
    else
        echo "Skipping installation of $crate on posix operating system."
    fi
done
