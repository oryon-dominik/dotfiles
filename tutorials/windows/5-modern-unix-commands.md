# Modern unix commands on Windows 10

Pretending you have installed cargo (`choco install rust`). Just install via cargo.

    # (btm) graphical system/process monitor - https://github.com/ClementTsang/bottom
    cargo install bottom --locked

    # Replacement for ps - https://github.com/dalance/procs
    cargo install procs --locked

    # instant overview of which directories are using disk - https://github.com/bootandy/dust
    cargo install du-dust --locked

    # CLI benchmarks - https://github.com/sharkdp/hyperfine
    cargo install hyperfine --locked

    # send HTTP requests - https://github.com/ducaale/xh
    cargo install xh --locked

    # grahpical directory trees - https://github.com/Canop/broot
    cargo install broot --locked

    # (tldr) Help pages for command-line tools, rust implementation of tldr - https://github.com/dbrgn/tealdeer
    cargo install tealdeer --locked

    # build regexes from CLI-tests https://github.com/pemistahl/grex
    cargo install grex --locked

    # current network utilization - https://github.com/imsnif/bandwhich
    cargo install bandwhich --locked

    # statistics about your code - https://github.com/XAMPPRocky/tokei
    cargo install tokei --locked

    # field selection from content - https://github.com/theryangeary/choose
    cargo install choose --locked

    # simple, fast and user-friendly alternative to 'find' - https://github.com/sharkdp/fd
    cargo install fd-find --locked

    # recursively searches directories for a regex pattern - https://github.com/BurntSushi/ripgrep
    cargo install ripgrep --locked

    # smarter cd command - https://github.com/ajeetdsouza/zoxide
    cargo install zoxide --locked

    # cat clone with syntax highlighting and Git integration - https://github.com/sharkdp/bat
    cargo install bat --locked

    # highlighting for diff - https://github.com/dandavison/delta
    cargo install git-delta --locked

    # Ping, but with a graph - https://github.com/orf/gping
    cargo install gping --locked

    # find & replace - https://github.com/chmln/sd
    cargo install sd --locked


## Additional packages.

Create the (gitignored) `.dotfiles/bin` directory if it doesn't exist

    mkdir "$env:DOTFILES/bin" -ErrorAction SilentlyContinue


### exa

A modern replacement for ls - https://github.com/ogham/exa  
Manually adding the windows-branch.

    git clone https://github.com/ogham/exa "$env:DOTFILES/bin/exa"
    # cherry pick the windows fix
    cd "$env:DOTFILES/bin/exa"
    git fetch origin pull/820/head:chesterliu/dev/win-support
    git checkout chesterliu/dev/win-support
    cargo install --path . --force
    cd -


### dogdns

Dog - command-line DNS client - https://github.com/ogham/dog  
Compile from source.

    git clone https://github.com/ogham/dog "$env:DOTFILES/bin/dog"
    cd "$env:DOTFILES/bin/dog"
    cargo install --path . --force
    cd -


### curlie

Download tarball from https://github.com/rs/curlie/releases/tag/v1.6.7
unzip twice.. put into your `"$env:DOTFILES/bin"`.

### jq

Command-line JSON processor.  
Put the latest version from https://github.com/stedolan/jq/releases into your `"$env:DOTFILES/bin"`.


### cheat

    go install github.com/cheat/cheat/cmd/cheat@latest


### gtop

    npm install gtop -g


TODO: add a windows-working version for 'mcfly' https://github.com/cantino/mcfly
