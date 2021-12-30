
# TODO: pretty print (maybe as rust-module?! or python rich?!)
function CmdTutorial {

    Write-Host "================================== TUTORIAL ======================================================"
    Write-Host "Available Commands"
    Write-Host ""
    Write-Host "    tldr                via tealdeer - modern man page - use this on any command to quickly understand it's usage"  # https://github.com/dbrgn/tealdeer
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
    Write-Host "    exa                 Modern ls replacement"  # https://github.com/ogham/exa

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

    Write-Host "    xh                  Friendly and fast tool for sending HTTP requests"  # https://github.com/ducaale/xh
    Write-Host "    broot               A new way to see and navigate directory trees"  # https://github.com/Canop/broot
    Write-Host "    grex                generating regular expressions from user-provided test cases"  # https://github.com/pemistahl/grex
    Write-Host "    bandwhich           Terminal bandwidth utilization tool"  # https://github.com/imsnif/bandwhich
    Write-Host "    tokei               Count your code, quickly."  # https://github.com/XAMPPRocky/tokei
    Write-Host "    choose              fast alternative to cut and (sometimes) awk"  # https://github.com/theryangeary/choose

    Write-Host ""
    Write-Host "Python:"
    Write-Host ""
    Write-Host "    pyenv               manage your different python versions"
    Write-Host "    poetry              manage your projects dependencies and package"
    Write-Host "    pipx                manage external binaries"
    Write-Host ""

    Write-Host "System:"
    Write-Host ""
    Write-Host "    ip                  current ip address"
    Write-Host "    sysinfo             infos on your hardware"
    Write-Host "    ver                 windows version"
    Write-Host "    envs                show all envs set"
    Write-Host ""
    Write-Host "    off                 power off"
    Write-Host "    hib                 hibernate"
    Write-Host "    reb                 reboot"
    Write-Host "    lock                lock the screen"
    Write-Host ""


    # TODO: sort, pretty-print  +clean up + add section for
    # generate_password
    # speedtest
    # weather
    # cliTube
    # restic-backups
    # functions defined in scripts/powershell/System.ps1
    # showssh

}
Set-Alias -Name tut -Value CmdTutorial -Description "Show a short introductory tutorial for this CLI configuration."
