# Modern unix commands on Windows 10

pretending you have installed cargo (`choco install rust`)

    cargo install xh
    cargo install broot
    cargo install tealdeer
    cargo install grex
    cargo install bandwhich
    cargo install tokei
    cargo install choose

## dogdns

    git clone https://github.com/ogham/dog
    cd dog
    cargo install --path . --force

## curlie

download tarball from https://github.com/rs/curlie/releases/tag/v1.6.7
unzip twice.. put into your users /bin

## cheat

    go get -u github.com/cheat/cheat/cmd/cheat

## exa

manually adding the windows-branch

    git clone https://github.com/ogham/exa
    cd exa
    git fetch origin pull/820/head:chesterliu/dev/win-support
    git checkout chesterliu/dev/win-support


## still not working..

cargo install mcfly
