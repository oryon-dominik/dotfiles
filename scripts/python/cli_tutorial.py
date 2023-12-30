#!/usr/bin/env python3
# coding: utf-8
import json
import platform
from dataclasses import dataclass
from pathlib import Path


REQUIREMENTS = "rich"


__doc__ = """
Pretty print available cli programs.
Considers commands from
    - install/scoops/scoop-packages.json
    - install/crates/cargo-tools.json
    - install/commands/cli.json
These have to be updated manually for any changes and are obviously always deprecated..
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


def generate_commands() -> list[ShellCommand]:
    """
    Import commands from json files.
    """
    commands = []
    # Get current OS
    system = platform.system()
    os = {
        "Darwin": "posix",
        "Linux": "posix",
        "Windows": "windows",
    }.get(system, "unknown")

    if os == "unknown":
        raise SystemExit(f"Unknown OS: {system}. Cannot generate commands.")
    elif os == "posix":
        # commands += generate_posix_commands()
        ...
    elif os == "windows":
        # Default cli-packages
        cli = json.loads((Path(__file__).parent.parent.parent / "install" / "commands" / "windows-cli.json").read_text())
        commands += [
            ShellCommand(**cmd) for cmd in cli.get("shell-commands", []) if cmd["os"] is None or cmd["os"] == os
        ]

        scoops = json.loads(
            (Path(__file__).parent.parent.parent / "install" / "scoops" / "scoop-packages.json").read_text()
        )
        commands += [
            ShellCommand(
                category=cmd["tags"],
                command=cmd["command"],
                description=cmd["description"],
                os=cmd["os"],
                link=" | ".join(cmd["urls"]),
            )
            for cmd in scoops.get("scoops", []) if cmd["command"] is not None
        ]

    crates = json.loads((Path(__file__).parent.parent.parent / "install" / "crates" / "cargo-tools.json").read_text())
    commands += [
        ShellCommand(
            category=cmd["tags"],
            command=cmd["command"],
            description=cmd["description"],
            os=cmd["os"],
            link=cmd["url"],
        )
        for cmd in crates.get("crates", [])
        if cmd["command"] is not None and (cmd["os"] is None or cmd["os"] == os)
    ]

    return sorted(commands, key=lambda c: c.category)


# Generate Table and CLI
console = Console()
console.print(Rule(title="CLI TUTORIAL", characters="="))
table = generate_table()


# Build table from categories.
categories = []
for cmd in generate_commands():
    if cmd.category not in categories:
        table.add_row("", "", "", "")
        table.add_row(cmd.category, "", "", "")
    table.add_row("", cmd.command, cmd.description, cmd.link)
    categories.append(cmd.category)


# TODO: add restic-backups


console.print(table)
