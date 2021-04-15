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


__version__ = '0.4'  # updateable youtube.lua
__author__ = 'oryon/dominik'
__date__ = 'November 28, 2018'
__updated__ = 'April 10, 2021'


import subprocess
import os

from argparse import ArgumentParser, RawTextHelpFormatter
from pathlib import Path

try:
    import httpx
    from dotenv import load_dotenv
    import numpy as np
    from googleapiclient.discovery import build
    from googleapiclient.errors import HttpError

except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install google-api-python-client numpy httpx python-dotenv'.")


CUSTOM_DOTENV_PATH = None  # modify this (pathlib-style), if you want to use your own dotenvs-location


def get_google_api_key(custom_dotenv_path=None):
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


def get_search_results_from_youtube(search, api_key, youtube_api_service_name="youtube", youtube_api_version="v3"):
    """ returns actual data of results from SearchString """
    try:
        youtube = build(
            youtube_api_service_name,
            youtube_api_version,
            developerKey=api_key,
        )
    except Exception as error:
        raise SystemExit(f'{error}\nYoutube API-setup failed.')

    search_request = youtube.search().list(
        q=search,
        part='id,snippet',
        maxResults=10
    )
    try:
        response = search_request.execute()
    except HttpError as error:
        raise SystemExit(f'{error}\nConnection failed.')

    return response


def choose(results):
    """ chooses the video randomly """
    probabilities = [.3, .25, .2, .1, .05, .025, .025, .025, .0125, .0125]

    try:
        assert 'items' in results, 'No items found in search result'

        matches = [
            match for match in results['items']
            if 'id' in match and 'snippet' in match and 'videoId' in match['id'] and 'title' in match['snippet']
        ]
        hits = {}
        for match in matches:
            ident = match['id']['videoId']
            title = match['snippet']['title']
            hits.update({
                f'{ident}': title
            })

        # these are the Videos concerned:
        # import json
        # print(json.dumps(hits, indent=4))

        videos = [f'https://www.youtube.com/watch?v={hit}' for hit in hits]
        assert videos, "No results for searchTerm"

        if len(videos) >= 10:
            choice_url = np.random.choice(videos, p=probabilities)
        else:
            choice_url = np.random.choice(videos)
    except AssertionError as e:
        print(e)
        choice_url = ""

    try:
        hit = choice_url.split('watch?v=')[-1]
    except IndexError:
        hit = ""
    name = hits.get(hit, '')
    return choice_url, name


def play(url, name):
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.wShowWindow = 4  # this sends the window into the background on windows
    try:
        subprocess.Popen(["vlc", f"{url}"], startupinfo=startupinfo)
    except FileNotFoundError:
        raise SystemExit(f"Could not find VLC on Path")
    raise SystemExit(f"Playing {name}\n{url}")


def update():
    """update vlc youtube.lua from github"""
    lua_url =  "https://raw.githubusercontent.com/videolan/vlc/master/share/lua/playlist/youtube.lua"
    vlc_path = Path("C:\Program Files\VideoLAN\VLC")
    playlist_path = vlc_path / "lua" / "playlist"
    lua_path = playlist_path / "youtube.lua"

    try:
        response = httpx.get(lua_url)
        response.raise_for_status()
    except httpx.RequestError as exc:
        raise SystemExit(f"An error occurred while requesting a new 'youtube.lua' from github.")
    except httpx.HTTPStatusError as exc:
        raise SystemExit(f"Error response {exc.response.status_code} while requesting a new 'youtube.lua' from github.")

    if not vlc_path.exists():
        raise SystemExit(f"Can't find VLC (expected to be in: {vlc_path.resolve()}).")

    playlist_path.mkdir(parents=True, exist_ok=True)
    try:
        with open(lua_path, 'wb') as lua:
            lua.write(response.content)
    except OSError as exc:
        raise SystemExit(f"An error occurred while writing to {lua_path.resolve()}: {exc}.")


# handling the arguments
parser = ArgumentParser(
    description=__doc__, prog='cliTube',
    epilog='Have fun tubing!',
    formatter_class=RawTextHelpFormatter,
    )

parser.add_argument('--version', action='version', version=__version__)
parser.add_argument('search', metavar='Searchterm', help='the searchstring (Artist & Title) you are looking for', nargs='*')
parser.add_argument('--update', action="store_true", default=False)


if __name__ == '__main__':
    args = parser.parse_args()

    if args.update:
        update()
        raise SystemExit(f"Successfully updated 'youtube.lua'.")

    if not args.search:
        parser.print_help()
        raise SystemExit(f'')

    # play
    api_key = get_google_api_key(custom_dotenv_path=CUSTOM_DOTENV_PATH)
    search = stringify(args)
    results = get_search_results_from_youtube(search, api_key)
    url, name = choose(results)
    if url:
        play(url, name)
