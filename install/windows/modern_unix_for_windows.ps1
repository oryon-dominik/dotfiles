
# TODO: check git + cargo + go + npm on path

Write-Host "Installing modern unix cli-commands to powershell..."

# Rust modules

# (btm) graphical system/process monitor - https://github.com/ClementTsang/bottom
cargo install bottom

# Replacement for ps - https://github.com/dalance/procs
cargo install procs

# instant overview of which directories are using disk - https://github.com/bootandy/dust
cargo install du-dust

# CLI benchmarks - https://github.com/sharkdp/hyperfine
cargo install hyperfine

# send HTTP requests - https://github.com/ducaale/xh
cargo install xh

# grahpical directory trees - https://github.com/Canop/broot
cargo install broot

# (tldr) Help pages for command-line tools, rust implementation of tldr - https://github.com/dbrgn/tealdeer
cargo install tealdeer

# build regexes from CLI-tests https://github.com/pemistahl/grex
cargo install grex

# current network utilization - https://github.com/imsnif/bandwhich
cargo install bandwhich

# statistics about your code - https://github.com/XAMPPRocky/tokei
cargo install tokei

# field selection from content - https://github.com/theryangeary/choose
cargo install choose

# create the 
mkdir $env:DOTFILES/bin -ErrorAction SilentlyContinue

# command-line DNS client - https://github.com/ogham/dog
# cargo install dog

# git clone https://github.com/ogham/dog $env:DOTFILES/bin/dog
# cd $env:DOTFILES/bin/dog
# cargo install --path . --force
# cd -

git clone https://github.com/ogham/exa $env:DOTFILES/bin/exa
cd $env:DOTFILES/bin/exa
git fetch origin pull/820/head:chesterliu/dev/win-support
git checkout chesterliu/dev/win-support
cargo install --path . --force
cd -


Write-Host "Pick the latest windows executable for these additional packages from github."
Write-Host "Save them to $(Join-Path -Path $env:USERPROFILE -ChildPath '\.cargo\bin\')."
Write-Host ""
Write-Host "dog - dns lookup"
Write-Host "https://github.com/ogham/dog/releases"
Write-Host ""
Write-Host "jq - Command-line JSON processor"
Write-Host "https://github.com/stedolan/jq/releases"
Write-Host ""
Write-Host "curlie - The power of curl, the ease of use of httpie."
Write-Host "https://github.com/rs/curlie/releases"

## cheat
go install github.com/cheat/cheat/cmd/cheat@latest

# gtop (process/system visualization)
npm install gtop -g
