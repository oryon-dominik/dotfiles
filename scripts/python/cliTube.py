#!/usr/bin/env python3
# coding: utf-8


'''
cliTube plays Internet-Music from CLI on Windows with preinstalled VLC
It builds Tube-URLS from artist & title arguments

requires a GOOGLE_API_KEY set as dotenv or environment variable

required modules:
    python -m pip install google-api-python-client numpy

to build as exe:
    python -m pip install pyinstaller
    pyinstaller.exe --onefile cliTube.py --distpath . --clean
    # have to clean up the mess manually..
    rm clitube.spec; rm build
'''


__version__ = '0.1.5' # api-fix
__author__ = 'oryon/dominik'
__date__ = 'November 28, 2018'
__updated__ = 'April 10, 2021'


import subprocess
import os

from argparse import ArgumentParser, RawTextHelpFormatter
from pathlib import Path

try:
    from dotenv import load_dotenv
    import numpy as np
    from googleapiclient.discovery import build
    from googleapiclient.errors import HttpError
    
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install google-api-python-client numpy python-dotenv'.")

YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'


def get_key(custom_dotenv_path=None):
    """precedence: 1. os 2. .env"""
    # get the key from os
    developer_key = os.environ.get('GOOGLE_API_KEY')
    if developer_key is not None:
        return developer_key

    # get it from dotfiles instead
    dotfiles_path = os.environ.get('DOTFILES')
    if dotfiles_path is None:
        raise SystemExit('Did neither find environment variables DOTFILES nor GOOGLE_API_KEY. Setup failed.')

    # read .env
    if custom_dotenv_path is not None:
        envs = Path(custom_dotenv_path)
    else:
        envs = Path(dotfiles_path) / "local" / ".env"
    if not envs.exists():
        raise SystemExit('.env not found')
    load_dotenv(envs)
    developer_key = os.environ.get('GOOGLE_API_KEY')
    if developer_key is None:
        raise SystemExit('Did not find GOOGLE_API_KEY in .env')
    return developer_key

def stringify(args):
    return ' '.join(args.search)

def get_search_results_from_youtube(search):
    """ returns actual data of results from SearchString """

    youtube = build(
        YOUTUBE_API_SERVICE_NAME,
        YOUTUBE_API_VERSION,
        developerKey=DEVELOPER_KEY
    )

    search_response = youtube.search().list(
        q=search,
        part='id,snippet',
        maxResults=10
    ).execute()

    return search_response

def choose(results, choice=""):
    """ chooses the video randomly """
    probabilities = [.3, .25, .2, .1, .05, .025, .025, .025, .0125, .0125]
    hits = {f"{match.get('id', {}).get('videoId')}" : match.get('snippet', {}).get('title') for match in results.get('items', [])}
    if not hits:
        print('No items found in search result')
        return choice
    videos = [f'https://www.youtube.com/watch?v={hit}' for hit in hits]
    if videos:
        if len(videos) >= 10:
            choice = np.random.choice(videos, p=probabilities)
        else:
            choice = np.random.choice(videos)
    else:
        print('No results for searchTerm')
    return choice

def play(url):
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.wShowWindow = 4  # this sends the window into the background on windows
    subprocess.Popen(["vlc", f"{url}"], startupinfo=startupinfo)


parser = ArgumentParser(
    description=__doc__, prog='cliTube',
    epilog='Have fun tubing!',
    formatter_class=RawTextHelpFormatter,
    )
parser.add_argument('--version', action='version', version=__version__)
parser.add_argument('search', metavar='Searchterm', help='the searchstring (Artist & Title) you are looking for', nargs='*')


if __name__ == '__main__':
    args = parser.parse_args()

    DEVELOPER_KEY = get_key()

    if not args.search:
        parser.print_help()

    else:  # play
        search = stringify(args)
        results = get_search_results_from_youtube(search)
        match = choose(results)
        if match:
            play(match)
