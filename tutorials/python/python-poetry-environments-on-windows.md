# Installation and Setup of python poetry on windows with powershell

1. Install [poetry](https://python-poetry.org/)

    ```powershell
        (Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python
    ```

2. `refreshenv`

3. For a fit to my dotfiles-settings, change the virtualenvs-directory setting

    ```powershell
        poetry config virtualenvs.path $env:USERPROFILE\Envs
    ```

## commands

```powershell
    poetry --version            # show the version
    poetry config --list        # show the config
    poetry env info             # show info about the env you're in
    poetry init                 # interactively initializes a new poetry project
    poetry install              # installs dependencies from `pyproject.toml` and creates a `poetry.lock`
    poetry update               # latest version of dependencies
    poetry add <name>           # adds a package to pyproject.toml
    poetry remove <name>        # removes a package
```

## migrate an existing project

Switch to your preferred python-version\
I'm using pyenv.\
You can use your existing virtual enviroments too.

```powershell
    pyenv local <version>
```

1. init a poetry project

    ```powershell
        poetry init
    ```

2. initialize the lock

    ```powershell
        poetry lock
    ```

3. to install from old `requirements.txt`

    ```powershell
    foreach($requirement in (Get-Content "$pwd\requirements.txt")) {iex "poetry add $requirement"}
    ```

    Add dev-requirements:

    ```powershell
    foreach($requirement in (Get-Content "$pwd\requirements\dev.txt")) {iex "poetry add $requirement --dev"}
    ```
