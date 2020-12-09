"""
installs all python modules found inside this folder
"""

from pathlib import Path
import subprocess
import sys

# TODO: add an argparser

directory = Path('.')

# TODO: check for valid python binaries

for obj in directory.iterdir():
    if obj.is_file() and str(obj) != __file__:
        package = str(obj)
        subprocess.call([sys.executable, "-m", "pip", "install", package])
