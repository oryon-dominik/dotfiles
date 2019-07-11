"""
installs all python modules found inside this folder
"""

from pathlib import Path
import subprocess
import sys

directory = Path('.')

for obj in directory.iterdir():
    if obj.is_file():
        if str(obj) != __file__:
            package = str(obj)
            subprocess.call([sys.executable, "-m", "pip", "install", package])
