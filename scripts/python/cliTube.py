#!/usr/bin/env python3
# coding: utf-8


'''
cliTube plays Internet-Music from CLI on Windows with preinstalled VLC
It builds Tube-URLS from artist & title arguments
'''


__version__ = '0.1.4' # refactored
__author__ = 'oryon/dominik'
__date__ = 'November 28, 2018'
__updated__ = 'Dezember 10, 2020'


import numpy as np
import subprocess
import os

from argparse import ArgumentParser, RawTextHelpFormatter
from pathlib import Path

from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'


def get_key():
    return os.environ.get('DEVELOPER_KEY') # TODO: get from .env or env

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
    if not DEVELOPER_KEY:
        raise SystemExit('Did not find environment variable DEVELOPER_KEY')

    if not args.search:
        parser.print_help()

    else:  # play
        search = stringify(args)
        results = get_search_results_from_youtube(search)
        match = choose(results)
        if match:
            play(match)
