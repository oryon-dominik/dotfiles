# Installation and Setup of python pipx

If you need a certain python binary, almost always [pipx](https://github.com/pypa/pipx) is your preferred tool at hand.

Install 

    python -m pip install --user pipx
    # ! I'm not ensuring path here, because I manage the path manually with the powershell configs.

List installed binaries.

    python -m pipx list

Only run a binary once, without installing it on your system. No traces!

    python -m pipx run <package>


Upgrade.

    pytohn -m pipx upgrade-all


Example packages.

    poetry
    black
    flake8
    pwntools

    pipx run --spec=chardet chardetect --help

    # posix-only
    asciinema
    ansible
