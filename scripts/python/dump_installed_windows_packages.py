#!/usr/bin/env python3
# coding: utf-8


"""
dumps installed packages to the windows install-directory

requirements: set 'DOTFILES' environment variable to the directory containing
all the dotfile-settings (should be setup via your dotfile-repo installation,
if you've used: https://github.com/oryon-dominik/dotfiles-den)
"""


import re
import os
import socket
import subprocess
from pathlib import Path

# getting the result from choco
result = subprocess.run(["choco", "list", "--local-only"], stdout=subprocess.PIPE)

# transforming the result
packet_list = result.stdout.decode('utf-8').splitlines()
packets = [p.split()[0] for p in packet_list if (
    p != "" and
    not re.match(r".*\bpackages installed\..*", p) and
    not re.match(r"Chocolatey\sv\d*\..*", p) and
    not re.match(r"Did you know Pro /.*", p) and
    not re.match(r".*Features\? Learn more about.*", p)
    )
]

# preparing the directory containing the file
dotfile_directory = os.environ["DOTFILES"]
target_directory = Path(dotfile_directory) / "install" / "windows"
file_path = target_directory / f"choco_installed_packages_{socket.gethostname()}.config"

# writing the packages
with open(file_path, 'w') as file:
    file.write('<?xml version="1.0" encoding="utf-8"?>\n')
    file.write("    <packages>\n")
    for p in packets:
        file.write(f'        <package id="{p}" />\n')
    file.write("    </packages>\n")
