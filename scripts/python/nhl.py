#!/usr/bin/env python3
# coding: utf-8


REQUIREMENTS = "google-api-python-client numpy httpx python-dotenv rich"

__doc__ = f'''
A simple CLI Interface to play Highlight Videos from the official NHL-Channel.
Watch Games with the single CLI command `nhl`.
(With preinstalled VLC)

requires a GOOGLE_API_KEY set as dotenv or environment variable

required modules:
    python -m pip install {REQUIREMENTS}

to build as exe:
    python -m pip install pyinstaller
    pyinstaller.exe --onefile nhl.py --distpath . --clean
    # have to clean up the mess manually..
    rm nhl.spec; rm build
'''

__version__ = '0.2'  # from playing hawks only to the whole NHL
__author__ = 'oryon/dominik'
__date__ = 'October 03, 2021'
__updated__ = 'October 14, 2021'


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
    from rich.console import Console
    from rich.table import Table

except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")


CUSTOM_DOTENV_PATH = None  # modify this (pathlib-style), if you want to use your own dotenvs-location (-> for the GOOGLE_API_KEY)
TEAMS = (
    "Bruins", "Sabres", "Red Wings", "Panthers", "Canadiens", "Senators", "Lightning", "Maple Leafs",  # Atlantic
    "Hurricanes", "Blue Jackets", "Devils", "Islanders", "Rangers", "Flyers", "Penguins", "Capitals",  # Metropolitan
    "Coyotes", "Blackhawks", "Avalanche", "Stars", "Wild", "Predators", "Blues", "Jets",  # Central
    "Ducks", "Flames", "Oilers", "Kings", "Sharks", "Kraken", "Canucks", "Golden Knights",  # Pacific
)
PLAYLIST_URL = "https://www.youtube.com/playlist?list=PL1NbHSfosBuHInmjsLcBuqeSV256FqlOO"
REQUEST_ATLEAST_X_GAMES = 20
NETWORK_CACHING = 10000  # ms VLC-buffer
INSTANT_PLAY = False

console = Console()


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

def get_channel_id(playlist_url=PLAYLIST_URL):
    """
    returns the channel id of the playlist
    """
    # get the channel id from the playlist url
    try:
        channel_id = playlist_url.split('=')[-1]
    except IndexError:
        raise SystemExit('Malformed PLAYLIST_URL.')
    return channel_id

def get_hits_from_response(response, request_atleast_x_games, team=None) -> dict:
    teams = [team] if team is not None else TEAMS
    hits = {}
    items: list = response.get('items', [])
    matches = [
        match for match in items
        if 'id' in match and 'snippet' in match and 'videoId' in match['snippet']['resourceId'] and 'title' in match['snippet']
    ]
    for match in matches:
        ident = match['snippet']['resourceId']['videoId']
        title = match['snippet']['title']
        if any([team in title for team in teams]):
            hits.update({
                f'{ident}': title
            })
        if len(hits) >= request_atleast_x_games:
            break
    return hits
    
def get_nhl_highlights_from_youtube(
    api_key,
    request_atleast_x_games,
    team=None,
    youtube_api_service_name="youtube",
    youtube_api_version="v3"
):
    """
    returns actual hits from results from playlist

    docs on all available APIs:
    https://github.com/googleapis/google-api-python-client/blob/main/docs/dyn/index.md
    docs on the YouTube API:
    https://googleapis.github.io/google-api-python-client/docs/dyn/youtube_v3.html
    """
    try:
        youtube = build(
            youtube_api_service_name,
            youtube_api_version,
            developerKey=api_key,
        )
    except Exception as error:
        raise SystemExit(f'{error}\nYoutube API-setup failed.')

    channel_id = get_channel_id()
    page_one = youtube.playlistItems().list(
        playlistId=channel_id,
        part='id,snippet',
        maxResults=100
    )

    try:
        response = page_one.execute()
    except HttpError as error:
        raise SystemExit(f'{error}\nConnection failed.')

    hits = get_hits_from_response(response, request_atleast_x_games, team=team)

    while next_page_token := response.get('nextPageToken'):
        if len(hits) >= request_atleast_x_games:
            break
        
        next_page = youtube.playlistItems().list(
            playlistId=channel_id,
            pageToken=next_page_token,
            part='id,snippet',
            maxResults=100
        )
        response = next_page.execute()

        hits.update(get_hits_from_response(response, request_atleast_x_games, team=team))

    youtube.close()
    
    return hits

def get_team_color(name) -> str:
    colors = {
        "Bruins": "gold3",
        "Sabres": "blue",
        "Red Wings": "red3",
        "Panthers": "red3",
        "Canadiens": "red",
        "Senators": "tan",
        "Lightning": "dark_blue",
        "Maple Leafs": "royal_blue1",
        "Hurricanes": "bright_red",
        "Blue Jackets": "blue",
        "Devils": "indian_red",
        "Islanders": "light_slate_blue",
        "Rangers": "dodger_blue3",
        "Flyers": "dark_orange3",
        "Penguins": "yellow",
        "Capitals": "white",
        "Coyotes": "magenta",
        "Blackhawks": "red3",
        "Avalanche": "orchid",
        "Stars": "white",
        "Wild": "dark_sea_green1",
        "Predators": "yellow1",
        "Blues": "blue",
        "Jets": "blue",
        "Ducks": "aquamarine1",
        "Flames": "red",
        "navajo_white1": "white",
        "Kings": "grey82",
        "Sharks": "pale_turquoise4",
        "Kraken": "bright_cyan",
        "Canucks": "steel_blue1",
        "Golden Knights": "gold3",
    }
    return colors.get(name, "white")

def print_hits_available(hits):
    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Date", style="dim", width=12)
    table.add_column("Index", style="dim", width=5)
    table.add_column("Game", justify="center")

    console.print('Available Highlights:')
    ix = 0
    for key, value in hits.items():
        modern_pairing = value.split('|')[0]
        pairs = modern_pairing.split('@')
        home_date = pairs[-1].strip().split(' ')
        away = pairs[0].strip()
        playoffs = " "
        if "Gm" in away:
            playoffs = f" {' '.join(away.split()[:-1])} "
            away = away.split(' ')[-1].strip()
        date = home_date[-1]
        home = " ".join(home_date[0:-1]).strip()
        home_color = get_team_color(home)
        away_color = get_team_color(away)
        link = f"https://www.youtube.com/watch?v={key}"
        table.add_row(date, f"{ix}", f'[link={link}][{home_color}]{home}[/{home_color}] @{playoffs}[{away_color}]{away}[/{away_color}][/link]')
        ix += 1
    console.print(table)

def choose(hits: dict, index: int):
    """Chooses the video from index"""
    try:
        # these are the Videos concerned:
        # import json
        # print(f'>>> DEBUG: {json.dumps(hits, indent=4)}')

        videos = [f'https://www.youtube.com/watch?v={hit}' for hit in hits]
        assert videos, "No highlights found."

        try:
            choice_url = videos[index]
        except IndexError:
            hitlenght = len(hits)
            raise SystemExit(f"Index invalid. Could not find a highlight video for index {index} in {hitlenght} videos found.\nIndex should be in range {0}..{hitlenght - 1}.\nTo request more videos set REQUEST_ATLEAST_X_GAMES={REQUEST_ATLEAST_X_GAMES} to a higher value.")

    except AssertionError as e:
        print(e)
        choice_url = ""

    print_hits_available(hits)

    try:
        hit = choice_url.split('watch?v=')[-1]
    except IndexError:
        hit = ""
    name = hits.get(hit, '')
    return choice_url, name


def play(url, name, cache=False):
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.wShowWindow = 4  # this sends the window into the background on windows
    try:
        command = f"vlc {url}"
        if cache:
            command += f" --network-caching={NETWORK_CACHING}"
        subprocess.Popen(command.split(), startupinfo=startupinfo)
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
    description=__doc__, prog='nhl',
    epilog='Have fun watching NHL games!',
    formatter_class=RawTextHelpFormatter,
    )

parser.add_argument('--version', action='version', version=__version__)
parser.add_argument('index', metavar='Index', help='the result index of the video you want to play', nargs='?', type=int, default=0)
parser.add_argument('--update', action="store_true", default=False, help='update the youtube.lua file')
parser.add_argument('--cache', action="store_true", default=False)
parser.add_argument('--play', action="store_true", default=False, help='instantly stream the selected video with VLC')
parser.add_argument('--team', dest="team",  nargs='?', default=None, help='the team you want to filter for')

if __name__ == '__main__':
    args = parser.parse_args()

    if args.update:
        update()
        raise SystemExit(f"Successfully updated 'youtube.lua'.")

    team = args.team if args.team in TEAMS else None

    # play
    api_key = get_google_api_key(custom_dotenv_path=CUSTOM_DOTENV_PATH)
    hits = get_nhl_highlights_from_youtube(api_key, REQUEST_ATLEAST_X_GAMES, team=team)
    url, name = choose(hits=hits, index=args.index)
    if url and (args.play or INSTANT_PLAY):
        play(url, name, cache=args.cache)
