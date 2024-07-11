import os
import json
import platform
from dataclasses import dataclass
from pathlib import Path

try:
    from rich import print
except ImportError:
    print = print


df = os.environ.get("DOTFILES")
assert df is not None, "DOTFILES environment variable not set"

df = Path(df)
assert df.exists(), f"DOTFILES path {df} does not exist"

shared = df / "shared"
assert shared.exists(), f"Shared path {shared} does not exist"

repos = shared / "repositories"
assert repos.exists(), f"Repositories path {repos} does not exist"

global_repositories = repos / "global.json"
assert global_repositories.exists(), f"Global repositories file {global_repositories} does not exist"

data = json.loads(global_repositories.read_text())
assert (objs := data.get("repositories")) is not None, "No repositories key in global.json"


@dataclass
class Repository:
    name: str
    url: str
    paths: dict
    fix_remote: bool = False


repositories = [Repository(**repo) for repo in objs]

for r in repositories:
    # print(f"Adding repository [bold]{r.name}[/bold] from [bold]{r.url}[/bold]")

    path = r.paths.get(platform.system().lower())
    assert path is not None, f"Path for {platform.system()} not found in {r.paths}"
    if path.startswith("$env"):
        name = path.split("/")[0][5:]
        path = path.replace(f"$env:{name}", os.environ.get(path[5:]))
    print(f"  Cloning to {path}")
    os.system(f"git clone {r.url} {path}")
    wd = Path.cwd()
    if r.fix_remote:
        os.chdir(path)
        os.system(f"git remote set-url origin {r.url}")
        os.chdir(wd.resolve())
