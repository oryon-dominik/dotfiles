# dotfile-repository

> This is about: How-to configure your own dotfile repository, I call it my `DEN`

Make sure you have installed a [powershell](https://github.com/PowerShell/PowerShell#get-powershell) (This tutorial assumes, youre using `powershell7`), [chocolatey](https://chocolatey.org/) & [git](https://git-scm.com/) with [hub](https://hub.github.com/)

## Preparation

0a. Install powershell, chocolatey & git

    Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
    New-Item $PROFILE -Force

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    refreshenv
    choco feature enable -n=allowGlobalConfirmation
    choco install git.install --params /GitAndUnixToolsOnPath
    choco install hub poshgit
    refreshenv

0b. Set up your `ssh-key` and your `git config`

    ssh-keygen -t rsa -C your@email.address -f $env:USERPROFILE/.ssh/id_rsa_GITHUB

    git config --global user.name "Your Name"
    git config --global user.email "your_email@address.domain"
    git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa_GITHUB"
    git config --global core.autocrlf "true"

More on git in my [git-repo-tutorial](how-to_init_a_git_repo.md#preparations))

## Setup your dotfiles

1. Set an environment variable (`$env:DOTFILES`) to the location you want to install your config to. 

    Suggested example: `$env:userprofile\ + 'dotfiles'`

        $dotfiles = Join-Path -Path $env:userprofile -ChildPath "\dotfiles"
        mkdir $dotfiles
        [Environment]::SetEnvironmentVariable("DOTFILES", "$dotfiles", "User")

2. clone the dotfile-den repo into `$DOTFILES` and link the powershell profile

        git clone git@github.com:oryon-dominik/dotfiles-den $ENV:DOTFILES

    This will delete the old folders and make some system links (don't forget to backup your old powershell configs)

        $ps_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\WindowsPowerShell'
        $ps7_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\PowerShell'
        $dotfiles = Join-Path -Path $env:DOTFILES -ChildPath 'scripts\powershell'
        Remove-Item -path $ps_path -recurse
        Remove-Item -path $ps7_path -recurse
        cmd /c mklink /j "$ps_path" "$dotfiles"
        cmd /c mklink /j "$ps7_path" "$dotfiles"

3. edit the `env_settings_example.json` in the `local`-directory to your needs and and save it to `local/env_settings.json`\
    TODO: get it from private settings-repo via install-script\

    example:

        {
            "den_location": "dotfiles",
            "cloud": "<X:\\endpoint_of_your_cloud>",
            "projects": "<path_to_projects>",
            "heap": "<path_to_not_so_important_stuff>",
            "shortcuts": "local\\shortcuts",
            "residence": ["<cityname>", "<country_abbrev_ISO-Alpha-2>"],
            "coordinates": [<latitude>, <longitude>],
            "files_url": "<url_to_your_files_repository",
            "files_location": "files"
        }

4. Create an empty logfile for your updates and your local scripts for locations and projects

        mkdir $ENV:DOTFILES/local/logs/
        mkdir $ENV:DOTFILES/local/.secrets
        New-Item -ItemType file $ENV:DOTFILES/local/logs/$env:computername/updates.log
        New-Item -ItemType file $ENV:DOTFILES/scripts/powershell/limbs/locations.ps1
        New-Item -ItemType file $ENV:DOTFILES/scripts/powershell/limbs/projects.ps1
        New-Item -ItemType file "$ENV:DOTFILES/scripts/powershell/machines/$env:computername.ps1"

        # examples
        echo "function dev { set-location (Join-Path -Path $settings.cloud -ChildPath '\Development') }" >> $ENV:DOTFILES/scripts/powershell/limbs/locations.ps1
        
        echo "function server {ssh serverip}" >> $ENV:DOTFILES/scripts/powershell/limbs/projects.ps1

    From here on you should be good to go and use your config, feel free to customize and follow the rest of my tutorial.

    TODO: put into install script

5. If you do not have a file-repository: I suggest to create another repository for your shared system files (system-images, shared icons and so on..).

    We create a sub-repository for that (If you keep your dotfiles private, you could just sync them with the dotfiles and skip this step..)

    Init a new or clone an existing repository into the `files`-directory you specified in the `env_settings` (you could use [new_project.py](../scripts/python/new_project.py) for that or manually set it up over the website)

    Init example:

        echo "# files" >> README.md
        echo "\n\n" >> README.md
        echo "Private Repository for your System-Files" >> README.md

        git init
        git add README.md
        git commit -m "initializing files"
        git remote add origin git@github.com:<username>/<repo>.git
        git push -u origin master

    or create it with a powershell-`curl` (if you have a git_token already)

        $GIT_TOKEN = <insert your token here>
        $NAME = <insert the file-repos name here, suggested: 'files'>
        curl -Uri https://api.github.com/user/repos -Method POST -Body (@{private="true";name=$NAME} | ConvertTo-Json) -Headers @{Authorization="token $GIT_TOKEN"}

6. If you already have a file-repository: Add your file-repo as submodule to `files`

        git submodule add git@github.com:<username>/<files-repo> files
        git commit -m 'Added files as submodule'

7. If the submodul is correctly setup in your git-repo ..

        git submodule init
        git submodule update

        # to update submodules later:
        git submodule update
        # don't forget to checkout a branch BEFORE a commit (git checkout -b added) inside the submodules or the header will get messed up!

8. check if everything runs as expected (install more powershell-modules, etc.)\

9. customize

    - edit `aliases.ps1`, `functions.ps1`, `intro.ps1` & `prompt_colors.ps1` in `scripts/powershell/limbs/` to your taste\
    - customize installed modules & scripts\
    - share your thoughts with me

\
\
TODO: 12. put your program-links into local/$env:computername/shortcuts and add them to your desktop or taskbar via script\
TODO: link to windows-installation tutorial\
TODO: write install-script following this tutorial\
TODO: expand to private settings & how-to-hold-secrets
