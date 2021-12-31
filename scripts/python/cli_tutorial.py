#!/usr/bin/env python3
# coding: utf-8

REQUIREMENTS = "rich"

__doc__ = f"""
Pretty print available cli programs.
Has to be updated manually for changes and is obviously always deprecated..
Still.. a nice first overview.
"""


try:
    from rich.table import Table
    from rich.console import Console
    from rich.rule import Rule
    from rich import box
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")


console = Console()

console.print(Rule(title="CLI TUTORIAL", characters="="))

grid = Table.grid(expand=True)

table = Table(
    show_header=True,
    highlight=True,
    header_style="deep_pink4",
    box=box.SIMPLE_HEAVY 
)
table.add_column("Category", width=20, style="bold magenta", justify="right")
table.add_column("Command", width=10, style="bright_yellow")
table.add_column("Description")
table.add_column("URL")

table.add_row("Available Commands:", "", "", "")
table.add_row("", "tldr", "modern man pages - use this on any command to quickly understand it's usage, via 'tealdeer'", "https://github.com/dbrgn/tealdeer")
table.add_row()
table.add_row("", "sudo", "execute a command in a new 'elevated Powershell' on a Windows-Terminal", "")
table.add_row("", "choco", "Chocolatey - your 'package-manager'.", "https://chocolatey.org/")
table.add_row("", "git", "version control", "https://git-scm.com/")
table.add_row()
table.add_row("Modern Unix:", "", "", "")
table.add_row()
table.add_row("", "CTRL + R", "Fzf: general-purpose command-line fuzzy finder", "https://github.com/junegunn/fzf")
table.add_row()
table.add_row("", "bat", "Like cat", "https://github.com/sharkdp/bat")
table.add_row("", "delta", "diff files", "https://github.com/dandavison/delta")
table.add_row("", "duf", "Disk usage", "https://github.com/muesli/duf")
table.add_row("", "fd", "Find entries in the filesystem", "https://github.com/sharkdp/fd")
table.add_row("", "exa", "Modern ls replacement", "https://github.com/ogham/exa")
table.add_row()
table.add_row("", "rg",  "'ripgrep' recursively searches the current directory for a regex pattern", "https://github.com/BurntSushi/ripgrep")
table.add_row("", "sd", "s[earch] & d[isplace]", "https://github.com/chmln/sd")
table.add_row("", "btm", "Bottom: process/system visualization", "https://github.com/ClementTsang/bottom")
table.add_row("", "gtop", "Gtop: process/system visualization", "https://github.com/aksakalli/gtop")
table.add_row("", "gping", "Ping, but with a graph", "https://github.com/orf/gping")
table.add_row("", "procs", "procs is a replacement for ps", "https://github.com/dalance/procs")
table.add_row("", "httpie", "web requests in API-age", "https://github.com/httpie/httpie")
table.add_row("", "z", "zoxide is a smarter cd command", "https://github.com/ajeetdsouza/zoxide")
table.add_row("", "dust", "A more intuitive version of du", "https://github.com/bootandy/dust")
table.add_row("", "ag", "The silver searcher. A code searching tool similar to ack, with a focus on speed.", "https://github.com/ggreer/the_silver_searcher")
table.add_row("", "jq", "command-line JSON processor.", "https://github.com/stedolan/jq/releases")
table.add_row("", "hyperfine", "A command-line benchmarking tool", "https://github.com/sharkdp/hyperfine")
table.add_row("", "dog", "command-line DNS client.", "https://github.com/ogham/dog")
table.add_row()
table.add_row("", "xh", "Friendly and fast tool for sending HTTP requests", "https://github.com/ducaale/xh")
table.add_row("", "broot", "A new way to see and navigate directory trees", "https://github.com/Canop/broot")
table.add_row("", "grex", "generating regular expressions from user-provided test cases", "https://github.com/pemistahl/grex")
table.add_row("", "bandwhich", "Terminal bandwidth utilization tool", "https://github.com/imsnif/bandwhich")
table.add_row("", "tokei", "Count your code, quickly.", "https://github.com/XAMPPRocky/tokei")
table.add_row("", "choose", "fast alternative to cut and (sometimes) awk", "https://github.com/theryangeary/choose")
table.add_row()
table.add_row()
table.add_row("Python:" , "", "", "")
table.add_row()
table.add_row("", "pyenv" , "manage your different python versions", "https://github.com/pyenv/pyenv")
table.add_row("", "poetry" , "manage your projects dependencies and package", "https://python-poetry.org/")
table.add_row("", "pipx" , "manage external binaries", "https://pypa.github.io/pipx/")
table.add_row()
table.add_row()
table.add_row("System:" , "", "", "")
table.add_row()
table.add_row("", "ip", "current ip address", "")
table.add_row("", "sysinfo", "infos on your hardware", "")
table.add_row("", "ver", "windows version", "")
table.add_row("", "envs / printenv", "show all envs set", "")
table.add_row()
table.add_row("", "off", "power off", "")
table.add_row("", "hib", "hibernate", "")
table.add_row("", "reb", "reboot", "")
table.add_row("", "lock", "lock the screen", "")
table.add_row()

# # TODO: sort, pretty-print  +clean up + add sections for
# # generate_password
# # speedtest
# # weather
# # cliTube
# # restic-backups
# # functions defined in scripts/powershell/System.ps1
# # showssh
console.print(table)