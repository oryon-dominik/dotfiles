import argparse
import os
import sys
from pathlib import Path

"change your venv color"

AVAILABLE_COLORS = [
    'black', 'darkBlue', 'darkGreen', 'darkCyan', 'darkRed', 'darkMagenta', 'darkYellow',
    'gray', 'darkGray', 'blue', 'green', 'cyan', 'red', 'magenta', 'yellow', 'white'
    ]

def get_env_name():    
    return os.environ.get('VIRTUAL_ENV')

parser = argparse.ArgumentParser()
parser.add_argument('color', help="the env-color")
args = parser.parse_args()

env_name = get_env_name()

if env_name is None:
    print("You have to activate the env first")
    sys.exit(0)
    
if not args.color:
    print(f'Color is required')
    sys.exit(0)
    
if not args.color.lower() in AVAILABLE_COLORS:
    print("The available colors are", AVAILABLE_COLORS)
    sys.exit(0)

activate_script_path = Path(env_name) / "Scripts" / "Activate.ps1"

if not activate_script_path.exists():
    print(f'Activation Script not found ({activate_script_path.resolve()})')
    sys.exit(0)
    
with open(activate_script_path, 'r+') as f:
    lines = f.readlines()
    for i, l in enumerate(lines):
        if "Write-Host -NoNewline -ForegroundColor" in l and '"($_PYTHON_VENV_PROMPT_PREFIX) "' in l:
            old_color = l.split()[3]
            color = args.color.lower().capitalize()
            print(f'Current color is {old_color}, switching to {color}')
            lines[i] = f'        Write-Host -NoNewline -ForegroundColor {color} "($_PYTHON_VENV_PROMPT_PREFIX) "\n'
    f.seek(0)
    f.write(''.join(lines))
