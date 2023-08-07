#!/usr/bin/env python3
# coding: utf-8


"""
CREATE a NEW PROJECT

this script creates a 'full work ready' project from command line, including:
    - directory structure inside your $PROJECT_DIR
    - creation of the virtual-environment
    - first draft of common files like README.md, .gitignore & .env
    - .code-workspace & settings for vscode
    - complete git project initialisation & configuration
    - git flow initialisation, including first feature and release branches
    - pushing the repository to your GITHUB-Account
    
required:
    - installed & available on your command-line: [GIT, curl]
    - virtualenvwrapper powershell (https://github.com/regisf/virtualenvwrapper-powershell)
    - a setup of your ENVIRONMENT-variables or a project_settings.json inside script-dir
      set at least:
              "PROJECTS_DIR"  to your absolute project-path  # ! deprecated
              "TOKEN"         to your GITHUB-CLI-Access-Token
"""

"""
TODO:
    - check if required conditions are met / substitute curl with requests
    - add install of custom projects & requirements, folders, files
    - add other repo-services accounts (AZURE, bitbucket..)
"""

__version__ = "0.3.0"
__author__ = "oryon/dominik"
__date__ = "April 01, 2019"
__updated__ = "December 09, 2020"

import warnings
warnings.warn("This is a very old approach on how to create a project and should be heavily refactored before using it again", DeprecationWarning)

# the name of the command alias in your shell - used to start this script
CMD = "newproject"


# from argparse import ArgumentParser, RawTextHelpFormatter, SUPPRESS
# from pathlib import Path
# import os
# import sys
# import subprocess
# import textwrap
# from datetime import datetime
# import getpass
# import time
# import shutil
# from json import load
# import re
# import requests


# DEFAULTS = {
#     "PROJECTS_DIR": "x:\\Meine Ablage\\_projects",  # ! deprectated
#     "REPO": "GITHUB",
#     "RELEASE": "0.1",  # starting-release number
#     "FEATURE": "Initial_Structure",  # first feature_name
#     "GIT_USER": None,
#     "GIT_EMAIL": None,
# }


# class ArgParser(ArgumentParser):
#     """overwriting the parsers error-method to display help as error-default"""

#     def error(self, message):
#         self.print_help()
#         sys.stderr.write(f"\nERROR: {message}\n")
#         sys.exit(2)


# def cmds_available():
#     """checks if required commands are installed"""
#     if shutil.which("git") is None:
#         return False
#     # TODO: add checks for virtualenvwrapper
#     return True


# def read_settings(filename="project_settings.json", settings=DEFAULTS):
#     """ reads settings file from disk """
#     script_path = Path(__file__).resolve().parent
#     settings_path = Path(script_path, filename)
#     # TODO: get settings from ENVS and/or local directory
#     if not settings_path.exists():
#         return settings
#     else:
#         with open(settings_path, "r") as file:
#             try:
#                 loaded = load(file)  # json.load
#                 for key in settings:
#                     if key not in loaded:
#                         loaded[key] = settings[key]
#                 return loaded
#             except Exception as err:
#                 return settings


# def print_status(message):
#     """prints status-messages **centered with dashes** while processing project-creation"""
#     dashes = ((80 - len(message)) // 2) * "-"
#     line = f"{dashes}{message}{dashes}"
#     if len(line) % 2 != 0:
#         line += "-"
#     print(line)
#     print()


# def create(structure="basic"):
#     """creating and filling all the basic files inside the working diretory"""

#     def bedrock():
#         README = textwrap.dedent(
#             f"""\
#             # {NEW}
            
#             {NEW} was created by {GIT_USER}({GIT_EMAIL}) at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
            
#             """
#         )

#         DOTENV = textwrap.dedent(
#             """\
#             PYTHONPATH=.
#             """
#         )

#         GITIGNORE = textwrap.dedent(
#             f"""\
#             ## GIT is ignoring... (# Created by {GIT_USER})

#             # git itself
#             /.git/*

#             # all logs
#             *.log

#             # vscode/settings
#             /.vscode/*
#             {NEW}.code-workspace

#             # local-config
#             /.env

#             ### Python ###
#             # precompiled
#             __pycache__/
#             *.py[cod]
#             """
#         )

#         VSCODE = textwrap.dedent(
#             f"""\
#             {{
#                 "folders": [
#                     {{
#                         "path": "."
#                     }}
#                 ],
#                 "settings": {{
#                     "files.autoSave": "onFocusChange",
#                     "python.venvPath": "~/venvs",
#                     "python.envFile": "${{workspaceFolder}}/.env",
#                     "python.terminal.activateEnvironment": true,
#                     "python.pythonPath": "C:\\\\Users\\\\{getpass.getuser()}\\\\envs\\\\{NEW}\\\\Scripts\\\\python.exe",}}
#             }}
#             """
#         )

#         with open(".gitignore", "w") as gitignore:
#             gitignore.writelines(GITIGNORE)

#         with open("README.md", "w") as readme:
#             readme.writelines(README)

#         with open(f"{NEW}.code-workspace", "w") as vscode:
#             vscode.writelines(VSCODE)

#         with open(".env", "w") as dotenv:
#             dotenv.writelines(DOTENV)

#     if structure == "basic":
#         bedrock()
#     elif structure == "flask":
#         bedrock()
#         print("structure for flask-application is not implemented yet")
#         """
#         # best imported from python-submodule... new_flask_project.py
#         import new_flask_project
        
#         # see: https://www.digitalocean.com/community/tutorials/how-to-structure-large-flask-applications
        
#         ~/LargeApp
#             |-- run.py
#             |-- config.py
#             |__ /env             # Virtual Environment
#             |__ /app             # Our Application Module
#                 |-- __init__.py
#                 |-- /module_one
#                     |-- __init__.py
#                     |-- controllers.py
#                     |-- models.py                
#                 |__ /templates
#                     |__ /module_one
#                         |-- hello.html
#                 |__ /static
#                 |__ ..
#                 |__ .
#             |__ ..
#             |__ .
        
#         mkdir ~/LargeApp
#         mkdir ~/LargeApp/app
#         mkdir ~/LargeApp/app/templates
#         mkdir ~/LargeApp/app/static
#         touch ~/LargeApp/run.py
#         touch ~/LargeApp/config.py
#         touch ~/LargeApp/app/__init__.py
        
#         # install requirements inside the virtualenv..: pip install flask flask-sqlalchemy flask-wtf
        
#         # fill run.py & config.py
#         # etc ...
        
#         new_flask_project.create()
        
#         """
#     else:
#         print(f"structure for {structure} is not implemented yet")


# def init_project(structure="basic"):
#     """processing all the shell-commands neccessary for the creation of a new-project"""
#     # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#     print_status(f"Creating {NEW}")

#     # TODO: create error-catching & rollbacks

#     projects = Path(PROJECTS_DIR)

#     # switch to projects-directory
#     os.chdir(str(projects))

#     # $ mkdir <DIR>
#     os.makedirs(NEW, exist_ok=True)
#     new_project_path = projects / NEW

#     # switch inside new_dir
#     os.chdir(str(new_project_path))

#     # mkvirtualenv <name>
#     subprocess.call(["powershell.exe", "mkvirtualenv", NEW], shell=True)

#     ## creating basic file & directory structure
#     print_status("Creating Project-Structure")
#     create(structure)

#     ## git init
#     print_status("Initializing GIT")
#     subprocess.call("git init", shell=True)
#     subprocess.call(f'git config --local user.email "{GIT_EMAIL}"', shell=True)
#     subprocess.call(f'git config --local user.name "{GIT_USER}"', shell=True)
#     subprocess.call(
#         f'git config --local core.sshCommand "ssh -i ~/.ssh/id_rsa_{REPO}"', shell=True
#     )

#     subprocess.call("git add .", shell=True)
#     subprocess.call('git commit -m "Initial commit"', shell=True)

#     ## create public or private AZURE or GITHUB repo, set origin on github or azure
#     print_status("Creating Repository")
#     if REPO == "GITHUB":
#         subprocess.call(
#             f'curl https://api.github.com/user/repos?access_token={TOKEN} -d "{{\\"name\\": \\"{NEW}\\", \\"private\\": {str(PRIVATE).lower()}}}"',
#             shell=True,
#         )
#         subprocess.call(
#             f"git remote add origin git@github.com:{GIT_USER}/{NEW}.git", shell=True
#         )
#         subprocess.call("git push -u origin master", shell=True)
#     else:
#         print_status("Only GITHUB Repository Creation supported right now")
#         # POST https://dev.azure.com/{organization}/{project}/_apis/git/repositories
#         # + project json

#     print_status("Initializing GIT FLOW")
#     subprocess.call(["git", "flow", "init", "-d"], shell=True)

#     subprocess.call(f'git config --local gitflow.prefix.feature "feature/"', shell=True)
#     subprocess.call(f'git config --local gitflow.prefix.bugfix "bugfix/"', shell=True)
#     subprocess.call(f'git config --local gitflow.prefix.release "release/"', shell=True)
#     subprocess.call(f'git config --local gitflow.prefix.hotfix "hotfix/"', shell=True)
#     subprocess.call(f'git config --local gitflow.prefix.support "support/"', shell=True)
#     print_status("Set prefixes to feature/, bugfix/, release/, hotfix/, support/")
#     subprocess.call("git push -u origin develop", shell=True)

#     print_status(f"Starting Release/{RELEASE}")
#     subprocess.call(f"git flow release start {RELEASE}", shell=True)
#     subprocess.call(f"git push -u origin release/{RELEASE}", shell=True)

#     print_status(f"Starting Feature/{FEATURE}")
#     subprocess.call(f"git flow feature start {FEATURE}", shell=True)
#     subprocess.call(f"git push -u origin feature/{FEATURE}", shell=True)

#     print_status(f"{NEW} created successfully")
#     print(f"projects;cd {NEW};workon {NEW}")


# # supported structures inside create()
# structures = ["flask", "django"]

# # supported repositories:
# repository_providers = ["azure", "bitbucket", "github"]  # defaults on [-1]

# # set git user & email to git-config-values
# user = (
#     subprocess.check_output(["git", "config", "user.name"])
#     .decode("utf-8")
#     .replace("\n", "")
# )
# email = (
#     subprocess.check_output(["git", "config", "user.email"])
#     .decode("utf-8")
#     .replace("\n", "")
# )
# DEFAULTS["GIT_USER"] = user
# DEFAULTS["GIT_EMAIL"] = email

# # handling the arguments
# parser = ArgParser(
#     description=__doc__,
#     prog=f"{CMD}",
#     epilog=f'Example usage: "{CMD} world-domination --public"\n{" " * 15}"{CMD} largeSecretApplication --app flask --repo azure"',
#     formatter_class=RawTextHelpFormatter,
# )

# parser.add_argument("--version", action="version", version=__version__)
# parser.add_argument(
#     "--public",
#     action="store_true",
#     help="The repository will be visible for anybody on the internet",
# )
# parser.add_argument(
#     "name",
#     metavar="projectname",
#     help="The name of the project you want to create, doesn't accept spaces or underscores",
#     nargs="*",
# )
# parser.add_argument(
#     "--app",
#     metavar=", ".join(structures),
#     default="basic",
#     const="basic",
#     nargs="?",
#     choices=structures,
#     help=f"create prebuild application structure",
# )
# parser.add_argument(
#     "--repo",
#     metavar=", ".join(repository_providers),
#     nargs="?",
#     choices=repository_providers,
#     help=f"choose a provider for your repository (default: {repository_providers[-1]})",
# )
# parser.add_argument(
#     "--user",
#     metavar="name",
#     nargs="?",
#     help=f"provide the username for your repository",
# )
# parser.add_argument(
#     "--email",
#     metavar="address",
#     nargs="?",
#     help=f"provide the email-address for your repository",
# )


# if __name__ == "__main__":

#     args = parser.parse_args()
#     settings = read_settings()

#     # check: if used cmds (git etc.) are available
#     if not cmds_available():
#         parser.error("did not find required commands on the commandline")

#     # check: projectname
#     NEW = " ".join(args.name)
#     if not args.name:
#         while not NEW or "_" in NEW or " " in NEW:
#             NEW = input(
#                 "please enter a valid projectname (no spaces, no underscores) > "
#             )
#     if "_" in " ".join(args.name) or " " in " ".join(args.name):
#         parser.error("spaces or underscores are not allowed in projectname")

#     # check: PROJECT_DIRectory
#     PROJECTS_DIR = os.environ.get("PROJECTS_DIR", settings["PROJECTS_DIR"])
#     while not Path(PROJECTS_DIR).exists():
#         sys.stderr.write(f"\nERROR: PROJECT_DIR ({PROJECTS_DIR}) does not exist.\n")
#         PROJECTS_DIR = input("please enter a valid parent directory > ")

#     # publish the repository to the public
#     PRIVATE = not args.public

#     # check: used REPOsitory provider
#     if args.repo:
#         REPO = args.repo.upper()
#     else:
#         REPO = settings["REPO"].upper()
#         if REPO not in [r.upper() for r in repository_providers]:
#             parser.error(
#                 f'the repository provided in the settings ({settings["REPO"]}) is not supported'
#             )

#     # check: user
#     if args.user and args.user != settings["GIT_USER"]:
#         GIT_USER = args.user
#     else:
#         GIT_USER = settings["GIT_USER"]
#     if not re.match(r"^[a-zA-Z0-9]+([_-]?[a-zA-Z0-9])*$", GIT_USER):
#         parser.error(f"the username provided ({GIT_USER}) is invalid")
#     if not GIT_USER:
#         parser.error("no username provided")

#     # check: email
#     if args.email and args.email != settings["GIT_EMAIL"]:
#         GIT_EMAIL = args.email
#     else:
#         GIT_EMAIL = settings["GIT_EMAIL"]
#     if not re.match(r"[^@]+@[^@]+\.[^@]+", GIT_EMAIL):
#         parser.error(f"the email provided ({GIT_EMAIL}) is invalid")
#     if not GIT_EMAIL:
#         parser.error("no e-Mail address provided")

#     # set release & feature branch-names
#     RELEASE = settings["RELEASE"]
#     FEATURE = settings["FEATURE"]

#     # authentification
#     AUTH = False
#     TOKEN = os.environ.get("GITHUB_TOKEN")
#     while not AUTH:
#         if not TOKEN:
#             TOKEN = getpass.getpass(
#                 prompt=f"{GIT_USER} please enter your personal {REPO} access token > "
#             )
#         response = requests.get(
#             "https://api.github.com/", headers={"Authorization": f"token {TOKEN}"}
#         ).json()  # TODO: GITHUB-specific!
#         if "message" in response:
#             if response["message"] == "Bad credentials":
#                 TOKEN = None
#                 parser.error("authentification failed")
#             else:
#                 if os.environ.get("GITHUB_TOKEN"):
#                     parser.error(response)
#                 else:
#                     print(response)
#                     TOKEN = None
#                     print("TOKEN reset")
#                     input("press any key to continue or CTRL-C to quit")
#         else:
#             AUTH = True

#     # TODO: change when features are implemented
#     if args.app != "basic":
#         parser.error(f"structure for {args.app} is not implemented yet")
#     elif args.repo and args.repo != "github":
#         parser.error(f"project creation on {args.repo} is not implemented yet")

#     # starting project initalization
#     init_project(args.app)
