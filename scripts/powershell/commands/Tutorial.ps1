

function Tutorial {
    Write-Host "================================== TUTORIAL ======================================================"
    Write-Host "Available Commands"
    Write-Host ""
    Write-Host "    tldr                modern man page - use this on any command to quickly understand it's usage"  # https://github.com/tldr-pages/tldr
    Write-Host ""
    Write-Host "    sudo                execute a command in a new elevated Powershell on a Windows-Terminal"
    Write-Host "    choco               Chocolatey - your package-manager."
    Write-Host "    git                 version control"
    Write-Host ""
    Write-Host "'Modern Unix':"
    Write-Host ""
    Write-Host "    CTRL + R            Fzf: general-purpose command-line fuzzy finder"  # https://github.com/junegunn/fzf
    Write-Host ""
    Write-Host "    bat                 Like cat"  # https://github.com/sharkdp/bat
    Write-Host "    delta               diff files"  # https://github.com/dandavison/delta
    Write-Host "    duf                 Disk usage"  # https://github.com/muesli/duf
    Write-Host "    fd                  Find entries in the filesystem"  # https://github.com/sharkdp/fd
    Write-Host "    lsd                 LSDeluxe"  # https://github.com/Peltoche/lsd

    Write-Host "    rg                  'ripgrep' recursively searches the current directory for a regex pattern"  # https://github.com/BurntSushi/ripgrep
    Write-Host "    sd                  s[earch] & d[isplace]"  # https://github.com/chmln/sd
    Write-Host "    btm                 Bottom: process/system visualization"  # https://github.com/ClementTsang/bottom
    Write-Host "    gtop                Gtop: process/system visualization"  # https://github.com/aksakalli/gtop
    Write-Host "    gping               Ping, but with a graph"  # https://github.com/orf/gping
    Write-Host "    procs               procs is a replacement for ps"  # https://github.com/dalance/procs
    Write-Host "    httpie              web requests in API-age"  # https://github.com/httpie/httpie
    Write-Host "    z                   zoxide is a smarter cd command"  # https://github.com/ajeetdsouza/zoxide
    Write-Host "    dust                A more intuitive version of du"  # https://github.com/bootandy/dust
    Write-Host "    ag                  The silver searcher. A code searching tool similar to ack, with a focus on speed."  # https://github.com/ggreer/the_silver_searcher
    Write-Host "    jq                  command-line JSON processor."  # https://github.com/stedolan/jq/releases
    Write-Host "    hyperfine           A command-line benchmarking tool"  # https://github.com/sharkdp/hyperfine
    Write-Host "    dog                 command-line DNS client."  # https://github.com/ogham/dog
    Write-Host ""
    Write-Host "Python:"
    Write-Host ""
    Write-Host "    pyenv               manage your different python versions"
    Write-Host "    poetry              manage your projects dependencies and package"
    Write-Host "    pipx                manage external binaries"
    Write-Host ""
    # TODO: sort, pretty-print  +clean up + add section for
    # generate_password
    # speedtest
    # weather
    # cliTube
    # restic-backups
}
Set-Alias -Name tut -Value Tutorial -Description "Show a short introductory tutorial for this CLI configuration."