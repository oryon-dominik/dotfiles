#!/usr/bin/env python3
# coding: utf-8


'''
cliTube plays Internet-Music from CLI on Windows with preinstalled VLC
It builds Tube-URLS from artist & title arguments
'''


__version__ = '0.1.3' # github release, added secrets
__author__ = 'oryon/dominik'
__date__ = 'November 28, 2018'
__updated__ = 'April 16, 2019'


import json
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
    secret_path = Path(__file__).resolve().parent / 'secret.py'
    if secret_path.exists():
        from secret import DEVELOPER_KEY
        return DEVELOPER_KEY
    elif os.environ.get('DEVELOPER_KEY'):
        return os.environ['DEVELOPER_KEY']


def stringify(args):
    return ' '.join(args.search)


def get_SearchResults_from_Youtube(search):
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


def choose(results):
    """ chooses the video randomly """
    probabilities = [.3, .25, .2, .1, .05, .025, .025, .025, .0125, .0125]
    hits, videos = {}, []
    choice = ''

    if 'items' in results:
        for match in results['items']:
            if 'id' in match and 'snippet' in match:
                if 'videoId' in match['id'] and 'title' in match['snippet']:
                    ident = match['id']['videoId']
                    title = match['snippet']['title']
                    hits[f'{ident}'] = title

        # print(json.dumps(hits, indent=4))  # these are the Videos concerned

        for hit in hits:
            videoURL = f'https://www.youtube.com/watch?v={hit}'
            videos.append(videoURL)

        if videos:
            if len(videos) >= 10:
                choice = np.random.choice(videos, p=probabilities)
            else:
                choice = np.random.choice(videos)
        else:
            print('No results for searchTerm')
    else:
        print('No items found in search result')

    return choice


def play(url):
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.wShowWindow = 4  # this sends the window into the background on windows
    subprocess.Popen(["vlc", f"{url}"], startupinfo=startupinfo)


# handling the arguments
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

    else:
        search = stringify(args)
        results = get_SearchResults_from_Youtube(search)
        match = choose(results)
        if match:
            play(match)
