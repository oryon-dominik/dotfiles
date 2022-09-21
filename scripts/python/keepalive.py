#!/usr/bin/env python3
# coding: utf-8

import time

REQUIREMENTS = "pyautogui"

try:
    import pyautogui
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")

try:
    from rich import print
except ImportError as error:
    pass  # using default print

print("Keeping machine alive until you press CTRL+C.")
while True:
    pyautogui.press('shift')
    time.sleep(240)
