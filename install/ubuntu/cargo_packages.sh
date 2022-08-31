#!/bin/sh

# TODO: generate from https://github.com/oryon-dominik/ansible-ubuntu-desktop/blob/trunk/roles/rust/vars/main/crates.yml
cargo install \
 exa         \  # A modern replacement for ls - https://github.com/ogham/exa
 bat         \  # cat clone with syntax highlighting and Git integration - https://github.com/sharkdp/bat
 git-delta   \  # highlighting for diff - https://github.com/dandavison/delta
 mcfly       \  # Fly through your shell history - https://github.com/cantino/mcfly
 zoxide      \  # smarter cd command - https://github.com/ajeetdsouza/zoxide
 procs       \  # Replacement for ps - https://github.com/dalance/procs
 bottom      \  # (btm) graphical system/process monitor - https://github.com/ClementTsang/bottom
 broot       \  # grahpical directory trees - https://github.com/Canop/broot
 du-dust     \  # instant overview of which directories are using disk - https://github.com/bootandy/dust
 ripgrep     \  # (rg) grep on steroids - https://github.com/BurntSushi/ripgrep
 fd-find     \  # simple, fast and user-friendly alternative to 'find' - https://github.com/sharkdp/fd
 hyperfine   \  # CLI benchmarks - https://github.com/sharkdp/hyperfine
 sd          \  # find & replace - https://github.com/chmln/sd
 choose      \  # field selection from content - https://github.com/theryangeary/choose
 grex        \  # build regexes from CLI-tests https://github.com/pemistahl/grex
 tokei       \  # statistics about your code - https://github.com/XAMPPRocky/tokei
 gping       \  # Ping, but with a graph - https://github.com/orf/gping
 dog         \  # command-line DNS client - https://github.com/ogham/dog
 xh          \  # send HTTP requests - https://github.com/ducaale/xh
 bandwhich   \  # current network utilization - https://github.com/imsnif/bandwhich
 tealdeer    \  # (tldr) Help pages for command-line tools, rust implementation of tldr - https://github.com/dbrgn/tealdeer
 alacritty   \  # Terminal emulator. - https://github.com/alacritty/alacritty
 jless          # Fast json parser - https://github.com/PaulJuliusMartinez/jless
 