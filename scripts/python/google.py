#!/usr/bin/env python3
# coding: utf-8


REQUIREMENTS = "httpx typer rich"


__doc__ = "google search in CLI, using the custom search json-API"  # https://developers.google.com/custom-search/v1/overview
__version__ = '0.1'  # initial release
__author__ = 'oryon/dominik'
__date__ = 'January 09, 2022'
__updated__ = 'January 09, 2022'


import os
from typing import NamedTuple
try:
    import httpx
    import typer
    import rich
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")


API_KEY = os.environ['GOOGLE_SEARCH_API_KEY']
CX = os.environ['GOOGLE_PROGRAMMABLE_SEARCH_ENGINE_ID']


console = rich.console.Console()
cli = typer.Typer()


class SearchResult(NamedTuple):
    title: str
    link: str
    snippet: str


@cli.command()
def search(query: str, sort: str = '', oldest: bool = False, newest: bool = False):
    """
    Searching for a query on google.

    Using the custom programmable search engine ID (cx):
        https://programmablesearchengine.google.com/controlpanel/all

    Parameter reference query: https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list

    Parameter reference sort: https://developers.google.com/custom-search/docs/structured_search#sort-by-attribute
    
    Example:
        --sort date:a -> ascending
        --sort date:d -> descending
    """
    if not sort:
        if oldest:
            sort = 'date:a'
        if newest:
            sort = 'date:d'

    url = f"https://www.googleapis.com/customsearch/v1?key={API_KEY}&cx={CX}&q={query}&sort={sort}"

    response = httpx.get(url)

    if not response.status_code == 200:
        console.print(f"Request failed: {response.status_code}")
        return

    results = [
        SearchResult(title=item['title'], link=item['link'], snippet=item['snippet'])
        for item in response.json()['items']
    ]

    table = rich.table.Table(
        show_header=True,
        highlight=True,
        header_style="deep_pink4",
        box=rich.box.ROUNDED
    )

    table.add_column(f"Title", width=25, style="bold yellow")
    table.add_column("Snippet", width=86)
    table.add_column(f"Link", width=72, style="dark_blue", justify='left', overflow='fold')
    for result in results:
        table.add_row(f"{result.title}" , f"{result.snippet}", f"{result.link}")
        table.add_row()
    console.print(table)


if __name__ == "__main__":
    cli()
