#!/usr/bin/env python3
# coding: utf-8

"""
Timer - for pomodore-sessions and meetings - for Windows
plays "church.wav" from your preconfigured files-repo
"""

__version__ = "0.1.0"
__author__ = "oryon/dominik"
__date__ = "April 12, 2019"
__updated__ = "May 21, 2019"

from argparse import ArgumentParser, RawTextHelpFormatter
import time
import winsound
from pathlib import Path
import os

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
parser.add_argument("soundfile", nargs="?", default="church")

if __name__ == "__main__":

    args = parser.parse_args()

    timer = args.time[0]

    time_left = int(timer) * 60
    while time_left:
        minutes, seconds = divmod(time_left, 60)
        print(f"Time left: - {minutes:02d}:{seconds:02d}", end="\r")
        time.sleep(1)
        time_left -= 1

    if os.getenv("DEN_ROOT"):
        cfg_root = Path(os.getenv("DEN_ROOT"))
        filename = f"{args.soundfile}.wav"
        soundfile = cfg_root / "files" / "systemsounds" / filename
    else:
        soundfile = Path("")

    if soundfile.is_file():
        winsound.PlaySound(str(soundfile), winsound.SND_FILENAME)

