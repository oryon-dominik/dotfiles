#!/usr/bin/env python3
# coding: utf-8


REQUIREMENTS = "rich sshconf"


__doc__ = f'''
pretty print ssh config

required modules:
    python -m pip install {REQUIREMENTS}
'''

import sys
from pathlib import Path
try:
    from rich.table import Table
    from rich.console import Console
    from sshconf import read_ssh_config
except ImportError as error:
    raise SystemExit(f"Import failed. {error}. 'python -m pip install {REQUIREMENTS}'.")


ssh_config_path = Path.home() / ".ssh" / "config"
if not ssh_config_path.exists():
    sys.exit("No ssh config found.")

console = Console()

table = Table(show_header=True, header_style="bold magenta")
table.add_column("Host", width=20)
table.add_column("User", style="dim", width=12)
table.add_column("IP", justify="right")


config = read_ssh_config(ssh_config_path)
for host in sorted(config.hosts()):
    values = config.host(host)
    if "hostname" not in values:
        continue
    ip = values['hostname']
    user = values.get('user')
    table.add_row(host, user, ip)

console.print(table)
