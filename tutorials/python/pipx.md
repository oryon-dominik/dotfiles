# Installation and Setup of python pipx

If you need a certain python binary, almost always [pipx](https://github.com/pypa/pipx) is your preferred tool at hand.

Install 

    python -m pip install --user pipx
    pipx ensurepath

List installed binaries.

    pipx list

Only run a binary once, without installing it on your system. No traces!

    pipx run <package>


Upgrade.

    pipx upgrade-all


Example packages.

    poetry
    black
    flake8
    pwntools

    pipx run --spec=chardet chardetect --help

    # posix-only
    asciinema
    ansible
