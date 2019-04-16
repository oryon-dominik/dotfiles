# denfile-repository

> How-to configure your own dotfile-den repository

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

After setting up your [ssh-keys](how_to_init_a_git_repo.md#markdown-header-preparations)..

1. create a file-repository (you could use [new_project.py](../scripts/python/new_project.py) for that or manually set it up over the website )

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

    or create it with a curl (if you have a git_token already)

    ```powershell
    $GIT_TOKEN = <insert your token here>
    $NAME = <insert the file-repos name here, suggested: 'file'>

    TODO: correct CURL code (doesn't work:)
    BROKEN # curl -u $git_username https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"
    BROKEN # curl https://api.github.com/user/repos?access_token=$GIT_TOKEN -d "{\"name\":\"files\", \"private\": true}"
    BROKEN # curl https://api.github.com/user/repos?access_token=$GIT_TOKEN -d "`{`\"name`\": `\"$NAME`\", `\"private`\": true`}"
    ```

2. set `$env:DEN_ROOT` to the location you want to install your config to suggested example: `$env:userprofile\ + '!den'`

    ```powershell
    $den_loc = Join-Path -Path $env:userprofile -ChildPath "\!den"
    [Environment]::SetEnvironmentVariable("DEN_ROOT", "$den_loc", "User")
    ```

3. clone the dotfile-den repo into $DEN_ROOT `git clone git@github.com:oryon-dominik/dotfiles-den $ENV:DEN_ROOT`

4. edit the `env_settings_example.json` to your needs and and save it to `env_settings.json`

5. Add your files as submodule

    ```powershell
    git submodule add git@github.com:<username>/<files-repo> files
    git commit -m 'Added files as submodule'
    ```

    If the submodul is already setup in your git-repo ..

    ```powershell
    git submodule init
    git submodule update

    # to update submodules later:
    git submodule update
    # don't forget to checkout a branch BEFORE a commit (git checkout -b added) inside the submodules or the header will get messed up!
    ```

6. delete the old folders and make the links

    ```powershell
    $ps_path = Join-Path -Path $env:userprofile -ChildPath '\Documents\WindowsPowerShell'
    $den_loc = Join-Path -Path $env:DEN_ROOT -ChildPath 'scripts\powershell'
    Remove-Item -path $ps_path -recurse
    cmd /c mklink /j "$ps_path" "$den_loc"
    ```

TODO: finish this tutorial

- put your program-links into .local/shortcuts and add them to your desktop or taskbar
