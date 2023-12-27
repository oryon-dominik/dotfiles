#!/usr/bin/env python3
# coding: utf-8

REQUIREMENTS = "rich httpx typer selectolax"


__doc__ = f'''
Show a linux commands manpage from linux.die.net

required modules:
    python -m pip install {REQUIREMENTS}
'''

import sys
from pathlib import Path

try:
    from rich.markdown import Markdown
    from rich.console import Console
    from rich.table import Table
    from rich import box
    import httpx
    import typer
    from selectolax.parser import HTMLParser
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")

console = Console()
cli = typer.Typer()

table = Table(
    show_header=True,
    highlight=True,
    header_style="deep_pink4",
    box=box.SIMPLE_HEAVY 
)


@cli.command()
def man(command: str):
    """The command to lookup on the manpages from 'linux.die.net'"""
    begins_with = command[0]
    begins_with = begins_with.lower() if begins_with.lower() in "abcdefghijklmnopqrstuvwxyz" else "other"
    url = f"https://linux.die.net/man/{begins_with}.html"
    r = httpx.get(url)
    if not r.status_code == 200:
        console.print("Connection failed.", style="red")
        return

    tree = HTMLParser(r.content)
    node = tree.css(f"div")
    contents = [n for n in node if n.attributes['id'] == "content"]
    items = contents[0].css(f"dt")
    
    results = [c for c in items if c.text().startswith(f"{command}(")]
    try:
        result = results[0]
    except IndexError:
        console.print(f"No manpage found for command {command}.", style="red")
        return
    link = result.css(f"a")[0].attributes['href']
    url = f"https://linux.die.net/man/{link}"
    
    r = httpx.get(url)
    if not r.status_code == 200:
        console.print("Connection to detail manpage failed.", style="red")
        return
    
    try:
        tree = HTMLParser(r.content)
        node = tree.css(f"div")
        content = [n for n in node if n.attributes['id'] == "content"][0]
        
        name = content.css_first(f"p")
        synopsis = content.css(f"p")[1]
        description = content.css(f"p")[2]
        parameters = content.css_first(f"dl")

        table.add_column(f"Manpage for '{command}'.", width=12, style="bold yellow")
        table.add_column("", width=21, style="blue")
        table.add_column(f"({url})", width=86)
        table.add_row()
        table.add_row("Description:", "", "")
        table.add_row("", "", name.text())
        table.add_row()
        table.add_row("", "", synopsis.text())
        table.add_row()
        table.add_row("", "", " ".join([t.strip() for t in description.text().split(" ")]))
        table.add_row()
        table.add_row("Arguments:", "")

        commands = parameters.css(f"dt")
        descriptions = parameters.css(f"dd")
        for command, description in zip(commands, descriptions):
            table.add_row("", command.text(), description.text())  # type: ignore

        console.print(table)
    except Exception:
        console.print("Something went wrong.", style="red")


if __name__ == "__main__":
    cli()
