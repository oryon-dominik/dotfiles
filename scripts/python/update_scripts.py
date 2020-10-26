#!/usr/bin/env python3
# coding: utf-8

"""
deploys new versions from the repos to the scripts
"""

from pathlib import Path
import os
import shutil

clitube_new, clitube_old = Path(""), Path("")

if os.getenv("DOTFILES"):
    root = Path(os.getenv("DOTFILES"))
    clitube_old = root / "scripts" / "python" / "cliTube.py"

if os.getenv("PROJECTS_DIR"):
    projects = Path(os.getenv("PROJECTS_DIR"))
    clitube_new = projects / "cliTube" / "cliTube.py"
    # TODO: check for files online, if projects not present

if clitube_old.is_file() and clitube_new.is_file():
    shutil.copy(clitube_new, clitube_old)

# TODO: add the new youtube.lua to the scripts update..
# TODO: add logic (maybe in ps-scripts) to update periodically
