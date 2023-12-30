#!/usr/bin/env python3
# coding: utf-8
import json
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


commands = json.loads((Path(__file__).parent.parent.parent / "docs" / "commands.json").read_text())
console = Console()
console.print(Rule(title="CLI TUTORIAL", characters="="))
table = generate_table()

categories = []
for reference in sorted(commands.get("shell-commands"), key=lambda c: c.get("category")):
    cmd = ShellCommand(**reference)
    if cmd.category not in categories:
        table.add_row("", "", "", "")
        table.add_row(cmd.category, "", "", "")
    table.add_row("", cmd.command, cmd.description, cmd.link)
    categories.append(cmd.category)

# TODO: add restic-backups
# TODO: add functions defined in scripts/powershell/System.ps1

console.print(table)
