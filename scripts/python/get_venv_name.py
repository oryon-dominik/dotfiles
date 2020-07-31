import re
import hashlib
import base64
import argparse
import os
from pathlib import Path

"unfortunately this is not the same result, as poetry builds :()"


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


def generate_env_name(name: str, cwd: str) -> str:    
    name = name.lower()
    sanitized = re.sub(r'[ $`!*@"\\\r\n\t]', "_", name)[:42]
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

# parser = argparse.ArgumentParser()
# parser.add_argument('name', help="the env-name")
# args = parser.parse_args()

# if not args.name:
#     print(f'>>> DEBUG: Name is required')
# else:
#     cwd = str(os.getcwd())
#     name = generate_env_name(args.name, cwd)
#     print(name)

name, wd = get_env()
if name:
    env_name = generate_env_name(name, wd)
    print(f'{env_name} -- unfortunately this is not the same result, as poetry builds :()')
else:
    print(f'No project found')
