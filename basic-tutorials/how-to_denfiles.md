# dotfile-repository

> This is about: How-to configure your own dotfile repository, I call it my `DEN`

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

Make sure you have installed a [powershell](https://github.com/PowerShell/PowerShell#get-powershell) (This tutorial assumes, youre using `powershell7`)

1. Set up your `ssh-key` and your `git config` (you can read how-to do it in the preparations part of my [git-repo-tutorial](how-to_init_a_git_repo.md#preparations))

2. I suggest, setting an environment variable (`$env:DEN_ROOT`) to the location you want to install your config to. Suggested example: `$env:userprofile\ + '.den'`

    ```powershell
    $den_loc = Join-Path -Path $env:userprofile -ChildPath "\.den"
    [Environment]::SetEnvironmentVariable("DEN_ROOT", "$den_loc", "User")
    ```

3. clone the dotfile-den repo into `$DEN_ROOT` with `git clone git@github.com:oryon-dominik/dotfiles-den $ENV:DEN_ROOT`

4. edit the `env_settings_example.json` in the `.local`-directory to your needs and and save it to `env_settings.json`\
    TODO: get it from private settings-repo\
    TODO: explain how to get GEO coordinates (to work with weather scripts and location specific sync scripts)\
    TODO: explain values\

5. Create an empty logfile for your updates `New-Item -ItemType file $ENV:DEN_ROOT/.local/logs/updates.log`
    TODO: put into install script

6. If you do not have a file-repository: I suggest to create another repository for your shared system files (system-images, shared icons and so on..).\

    We create a sub-repository for that (If you keep your dotfiles private, you could just sync them with the dotfiles and skip this step..)

    Init a new or clone an existing repository into the `files`-directory you specified in the `env_settings` (you could use [new_project.py](../scripts/python/new_project.py) for that or manually set it up over the website)

    Init example:

    ```powershell
    echo "# files" >> README.md
    echo "\n\n" >> README.md
    echo "Private Repository for your System-Files" >> README.md

    git init
    git add README.md
    git commit -m "initializing files"
    git remote add origin git@github.com:<username>/<repo>.git
    git push -u origin master
    ```

    or create it with a powershell-`curl` (if you have a git_token already)

    ```powershell
    $GIT_TOKEN = <insert your token here>
    $NAME = <insert the file-repos name here, suggested: 'files'>
    curl -Uri https://api.github.com/user/repos?access_token=$GIT_TOKEN -Method POST -Body (@{private="true";name=$NAME} | ConvertTo-Json)
    ```

7. If you already have a file-repository: Add your file-repo as submodule to `files`

    ```powershell
    git submodule add git@github.com:<username>/<files-repo> files
    git commit -m 'Added files as submodule'
    ```

8. If the submodul is correctly setup in your git-repo ..

    ```powershell
    git submodule init
    git submodule update

    # to update submodules later:
    git submodule update
    # don't forget to checkout a branch BEFORE a commit (git checkout -b added) inside the submodules or the header will get messed up!
    ```

9. delete the old folders and make some system links (don't forget to backup your old Powershell configs, if you need them!)

    ```powershell
    $ps_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\WindowsPowerShell'
    $ps7_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\PowerShell'
    $den_loc = Join-Path -Path $env:DEN_ROOT -ChildPath 'scripts\powershell'
    Remove-Item -path $ps_path -recurse
    Remove-Item -path $ps7_path -recurse
    cmd /c mklink /j "$ps_path" "$den_loc"
    cmd /c mklink /j "$ps7_path" "$den_loc"
    ```

10. check if everything runs as expected (install powershell-modules, etc.)\

    TODO: link to win-install tutorial
    TODO: add an example `locations.ps1` and `projetcs.ps1`

11. put your program-links into .local/shortcuts and add them to your desktop or taskbar via script

TODO: write install-script following this tutorial
TODO: expand to private settings & how-to-hold-secrets
