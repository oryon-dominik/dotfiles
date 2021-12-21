#!/usr/bin/env python3
# coding: utf-8

"""
Timer - for pomodore-sessions and meetings - for Windows
plays waves from your preconfigured files-repo
"""

__version__ = "0.1.1"
__author__ = "oryon/dominik"
__date__ = "April 12, 2019"
__updated__ = "July 27, 2019"

from argparse import ArgumentParser, RawTextHelpFormatter
import time
import winsound
from pathlib import Path
import os

try:
    import win32com.client as wincl
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install pywin32'.")


# handling the arguments
parser = ArgumentParser(
    description=__doc__,
    prog="Timer",
    epilog=f'Example usage: "timer 15"',
    formatter_class=RawTextHelpFormatter,
)

parser.add_argument("--version", action="version", version=__version__)
parser.add_argument(
    "time",
    metavar="minutes",
    type=int,
    help="time in minutes till alarm clock",
    nargs=1,
)
parser.add_argument("soundfile", nargs="?", default=None, help="soundfile to play from files/systemsounds")

if __name__ == "__main__":

    args = parser.parse_args()
    filename = f"{args.soundfile}.wav" if args.soundfile else None
    timer = args.time[0]

    time_left = int(timer) * 60
    while time_left:
        minutes, seconds = divmod(time_left, 60)
        print(f"Time left: - {minutes:02d}:{seconds:02d}", end="\r")
        time.sleep(1)
        time_left -= 1
    else:
        minutes, seconds = divmod(time_left, 60)
        print(f"Time left: - {minutes:02d}:{seconds:02d}", end="\n")

    if os.getenv("DOTFILES") and filename:
        cfg_root = Path(os.getenv("DOTFILES"))
        soundfile = cfg_root / "shared" / "files" / "systemsounds" / filename
    elif filename:
        cwd = Path(".")
        soundfile = cwd / filename
    else:
        soundfile = Path("")

    if soundfile.is_file():
        winsound.PlaySound(str(soundfile), winsound.SND_FILENAME)
    else:        
        voice = wincl.Dispatch("SAPI.SpVoice")
        voice.Speak("The timer has finished")
