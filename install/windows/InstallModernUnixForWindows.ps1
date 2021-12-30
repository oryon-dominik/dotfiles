#!/usr/bin/env pwsh

Write-Host "Installing modern unix cli-commands to powershell..."

if (Test-Path "cargo") {
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

    # simple, fast and user-friendly alternative to 'find' - https://github.com/sharkdp/fd
    cargo install fd-find

    # recursively searches directories for a regex pattern - https://github.com/BurntSushi/ripgrep
    cargo install ripgrep

    # smarter cd command - https://github.com/ajeetdsouza/zoxide
    cargo install zoxide

    # cat clone with syntax highlighting and Git integration - https://github.com/sharkdp/bat
    cargo install bat

    # highlighting for diff - https://github.com/dandavison/delta
    cargo install git-delta

    # Ping, but with a graph - https://github.com/orf/gping
    cargo install gping

    # find & replace - https://github.com/chmln/sd
    cargo install sd

    if (Test-Path "git") {
        # create the (gitignored) .dotfiles/bin directory if it doesn't exist
        mkdir $env:DOTFILES/bin -ErrorAction SilentlyContinue

        # A modern replacement for ls - https://github.com/ogham/exa
        # cargo install exa
        git clone https://github.com/ogham/exa $env:DOTFILES/bin/exa
        cd $env:DOTFILES/bin/exa
        # cherry pick the windows fix
        git fetch origin pull/820/head:chesterliu/dev/win-support
        git checkout chesterliu/dev/win-support
        cargo install --path . --force
        cd -

        # command-line DNS client - https://github.com/ogham/dog
        # cargo install dog
        git clone https://github.com/ogham/dog $env:DOTFILES/bin/dog
        cd $env:DOTFILES/bin/dog
        cargo install --path . --force
        cd -

    } else {
        Write-Host "git not found on PATH... skipping exa & dog"
    }
    

} else {
    Write-Host "cargo not found on PATH... skipping rust modules"
}

if (Test-Path "go") {
    ## cheat
    go install github.com/cheat/cheat/cmd/cheat@latest
} else {
    Write-Host "go not found on PATH... skipping cheat"
}

if (Test-Path "npm") {
    # gtop (process/system visualization)
    npm install gtop -g
} else {
    Write-Host "node not found on PATH... skipping gtop"
}

Write-Host "Pick the latest windows executable for these additional packages from github."
Write-Host "Save them to $(Join-Path -Path $env:USERPROFILE -ChildPath '\.cargo\bin\')."
Write-Host ""
# Write-Host "dog - dns lookup"
# Write-Host "https://github.com/ogham/dog/releases"
Write-Host ""
Write-Host "jq - Command-line JSON processor"
Write-Host "https://github.com/stedolan/jq/releases"
Write-Host ""
Write-Host "curlie - The power of curl, the ease of use of httpie."
Write-Host "https://github.com/rs/curlie/releases"
# TODO: add a windows-working version for 'mcfly' https://github.com/cantino/mcfly
