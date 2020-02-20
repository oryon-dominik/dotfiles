# Installation and Setup of python pyenv on windows with powershell

1. Install `pyenv-win`

    I strongly recommend cloning the official `pyenv-win` git-repository to have the latest python-versions available.\
    I also recommend to previously remove all other python-versions installed by [chocolatey](https://chocolatey.org/).\
    Otherwise your `PATH` may get messed up. but if you're keen on fixing this yourself you may choose to install pyenv
    with `choco install pyenv-win` or as pypi-package with `pip install pyenv-win --target $env:USERPROFILE/.pyenv`\
    Drawback: You won't get automatic updates on python anymore.\
    *Dont' forget to delete the old python shim when using chocolatey* (in `C:\ProgramData\chocolatey\bin` or the pyenv won't get recognized correctly,
    because the `chocolatey PATH` has precedence over the local `PATH` pyenv uses.

    ```powershell
    git clone https://github.com/pyenv-win/pyenv-win.git $env:USERPROFILE\.pyenv
    ```

2. Set the ennvironment variable `PYENV`

    ```powershell
        [Environment]::SetEnvironmentVariable("PYENV", "$env:USERPROFILE\.pyenv\pyenv-win", "Machine")
    ```

3. `refreshenv`

4. Add `$env:PYENV\bin` and `$env:PYENV\shims` to PATH

    ```powershell
        $path = [Environment]::GetEnvironmentVariable("PATH", "User")
        [Environment]::SetEnvironmentVariable("PATH", "$path;$env:PYENV\bin;$env:PYENV\shims", "User")
    ```

5. `refreshenv`

6. Install your prefered python(s) (On Windows-64 bit you have to add `-amd64`)

    ```powershell
        pyenv install --list  # lists all installable versions
        pyenv install 3.8.1-amd64  # this is the newest version on 20-02-2020
    ```

7. `pyenv rehash`

8. re-setup your project-interpreters

    If you want to keep your 'old' (e.g. virtualenvwrapper) environments, you have switch to your Envs directory
    (`~\Envs`) and edit `home` and `version` in `pyvenv.cfg` for every enviroment.

    Example `pyvenv.cfg`:

    ```pyvenv.cfg
        home = C:\Users\oryon\.pyenv\pyenv-win\versions\3.8.1-amd64
        include-system-site-packages = false
        version = 3.8.1
    ```

9. (if your using my dotfiles-den) add the repository to the the repository update-list

    ```powershell
        Add-Content $env:DEN_ROOT\.local\repository_updates.txt "$env:USERPROFILE\.pyenv"
    ```

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
