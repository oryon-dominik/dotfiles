# Installation and Setup of python pyenv on windows with powershell

1. Install `pyenv-win`

    I strongly recommend cloning the official `pyenv-win` git-repository to have the latest python-versions available.  
    
    I also heavily recommend to previously CLEAN your `PATH` and remove all other python-versions installed on your system.  
    Python could have been installed by [chocolatey](https://chocolatey.org/), [(mini-)conda](https://docs.conda.io/en/latest/miniconda.html) or any other sources.
    Also clean your `PATH` system & users environment variable from any remains. 
    If you're keen on or perfectly able to fix the `PATH`s issues yourself you may choose to install pyenv
    with `choco install pyenv-win` or as pypi-package with `pip install pyenv-win --target $env:USERPROFILE/.pyenv`  
    Drawback: You won't get automatic updates on python anymore.  
    
    *Dont' forget to delete the old python shim when using chocolatey* (e.g. in `C:\ProgramData\chocolatey\bin` or the 
    pyenv won't get recognized correctly, because the `chocolatey PATH` has precedence over the local `PATH` pyenv uses.

    ```powershell
    git clone https://github.com/pyenv-win/pyenv-win.git $env:USERPROFILE\.pyenv
    ```

2. Set the ennvironment variable `PYENV`

    ```powershell
        [Environment]::SetEnvironmentVariable("PYENV", "$env:USERPROFILE\.pyenv\pyenv-win", "User")
    ```

3. `refreshenv`

4. Add `$env:PYENV\bin` and `$env:PYENV\shims` to PATH

    ```powershell
        $path = [Environment]::GetEnvironmentVariable("PATH", "User")
        [Environment]::SetEnvironmentVariable("PATH", "$path;$env:PYENV\bin;$env:PYENV\shims", "User")
    ```

5. `refreshenv`

6. Install your prefered python(s)

    ```powershell
        pyenv install --list  # lists all installable versions
        pyenv install 3.10.5  # latest: 2022-06-17
        pyenv global 3.10.5  # to set this as your "standard-python" outside of venvs
    ```

7. `pyenv rehash`

9. Optional (if your using my dotfiles) add the repository to the the repository update-list to have pyenv involved in the `upgrade` command.

    ```powershell
        Add-Content $env:DOTFILES\.respositories.txt "$env:USERPROFILE\.pyenv"
    ```

10. Install your indispensable standard-modules to your system-python (e.g: `pip install pywin32`)

These dotfiles use:

    passlib
    python-dotenv
    rich
    httpx
    google-api-python-client
    numpy


## available commands

```pyenv
   commands    List all available pyenv commands
   local       Set or show the local application-specific Python version
   global      Set or show the global Python version
   shell       Set or show the shell-specific Python version
   install     Install a Python version using python-build
   uninstall   Uninstall a specific Python version
   rehash      Rehash pyenv shims (run this after installing executables)
   version     Show the current Python version and its origin
   versions    List all Python versions available to pyenv
   exec        Runs an executable by first preparing PATH so that the selected Python
```
