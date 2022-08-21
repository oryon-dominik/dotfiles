import re
import hashlib
import base64
import sys
import os
import argparse
from pathlib import Path

"Shows the venvname poetry will give your projects."


def encode(string, encodings=None):
    if isinstance(string, bytes):
        return string

    encodings = encodings or ["utf-8", "latin1", "ascii"]

    for encoding in encodings:
        try:
            return string.encode(encoding)
        except (UnicodeEncodeError, UnicodeDecodeError):
            pass

    return string.encode(encodings[0], errors="ignore")


def generate_env_name(name: str, cwd: str, legacy: bool = False) -> str:
    name = name.lower()
    sanitized = re.sub(r'[ $`!*@"\\\r\n\t]', "_", name)[:42]
    if not legacy:  # normalize
        cwd = os.path.normcase(cwd)
    hsh = hashlib.sha256(encode(cwd)).digest()
    hsh = base64.urlsafe_b64encode(hsh).decode()[:8]
    return f"{sanitized}-{hsh}"

def get_env():
    cwd = str(os.getcwd())
    project_path = Path(cwd)
    project_file = project_path / "pyproject.toml"
    if project_file.exists():
        return read_pyproject(project_file), cwd
    for p in project_path.parents:
        wd = str(p.resolve())
        project_file = p / "pyproject.toml"
        if project_file.exists():
            return read_pyproject(project_file), wd
    return None, None

def read_pyproject(file):
    """ read the projectname from pyproject.toml """
    with open(file, "r") as pyproject_file:
        pyproject = pyproject_file.readlines()
        for line in pyproject:
            if re.match(r"\Aname.?=.?['\"](.*?)['\"]", line):
                return str(re.findall(r"['\"](.*?)['\"]", line)[0])



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    
    legacy_help = "Use the legacy venv name calculation method"
    if sys.version_info >= (3, 9):
        parser.add_argument('--legacy', action=argparse.BooleanOptionalAction, help=legacy_help, default=False)
    else:
        parser.add_argument('--legacy', default=False, action='store_true', help=legacy_help)
        parser.add_argument('--no-legacy', dest='legacy', action='store_false', help=legacy_help)

    args = parser.parse_args()

    name, wd = get_env()
    if name:
        env_name = generate_env_name(name, wd, legacy=args.legacy)
        print(f'{env_name}-py{sys.version_info.major}.{sys.version_info.minor}')
    else:
        print(f'No project found')
