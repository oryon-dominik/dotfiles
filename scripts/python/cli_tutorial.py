#!/usr/bin/env python3
# coding: utf-8
import json
import platform
from dataclasses import dataclass
from pathlib import Path


REQUIREMENTS = "rich"


__doc__ = """
Pretty print available cli programs.
docs/commands.json Has to be updated manually for changes and is obviously always deprecated..
Still.. a nice first overview.
"""


@dataclass
class ShellCommand:
    category: str
    command: str
    description: str
    os: str | None
    link: str | None = ""


try:
    from rich.table import Table
    from rich.console import Console
    from rich.rule import Rule
    from rich import box
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")


def generate_table() -> Table:
    table = Table(
        show_header=True,
        highlight=True,
        header_style="deep_pink4",
        box=box.SIMPLE_HEAVY
    )
    table.add_column("Category", width=20, style="bold magenta", justify="right")
    table.add_column("Command", width=23, style="bright_yellow")
    table.add_column("Description")
    table.add_column("URL")
    return table


# Geenrate Table and CLI
commands = json.loads((Path(__file__).parent.parent.parent / "docs" / "commands.json").read_text())
console = Console()
console.print(Rule(title="CLI TUTORIAL", characters="="))
table = generate_table()

# Get current OS
system = platform.system()
os = {
    "Darwin": "posix",
    "Linux": "posix",
    "Windows": "windows",
}.get(system, "unknown")

# Build table from categories.
categories = []
for reference in sorted(commands.get("shell-commands"), key=lambda c: c.get("category")):
    cmd = ShellCommand(**reference)
    if cmd.os is None or cmd.os == os:
        if cmd.category not in categories:
            table.add_row("", "", "", "")
            table.add_row(cmd.category, "", "", "")
        table.add_row("", cmd.command, cmd.description, cmd.link)
        categories.append(cmd.category)


# TODO: add restic-backups
# TODO: generate commands.py entries from cargo crates. And enhances their
# datatype with "command" and some more things I need here frequently, to only
# have one truth.

console.print(table)
