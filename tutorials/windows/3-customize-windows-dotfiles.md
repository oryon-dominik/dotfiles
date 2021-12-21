# dotfiles customization

#### UNDER HEAVY CONSTRUCTION USE AT YOUR OWN RISK ########

## THIS IS BROKEN FOR NOW -  DON'T USE

Start with customizing your local settings.

Create the missing-files  # TODO: create the missing files when checking for them

```powershell
mkdir $env:DOTFILES/scripts/powershell/machines
New-Item -ItemType file $env:DOTFILES/scripts/powershell/machines/$env:computername.ps1
New-Item -ItemType file $env:DOTFILES/scripts/powershell/limbs/locations.ps1
```

Install Additional packages & powershell Modules, place additional symlinks

Customize scripts & aliases

# TODO: group aliases logically

# examples
echo "function dev { set-location (Join-Path -Path $settings.cloud -ChildPath '\Development') }" >> $ENV:DOTFILES/scripts/powershell/limbs/locations.ps1

TODO: create an empty .env


TODO: Symlink all the other programs. (after installing them)
example:
```powershell
Remove-Item -path $env:APPDATA/alacritty -recurse
mkdir $env:APPDATA/alacritty
New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"
```


TODO: 12. put your program-links into shared/$env:computername/shortcuts and add them to your desktop or taskbar via script\
TODO: link to windows-installation tutorial\
TODO: write install-script following this tutorial

TODO: expand to private settings & how-to-hold-secrets

Create and extend:

.repositories.txt
locals/git_too_big_to_prompt


6. If you do not have a file-repository: I suggest to create another repository for your shared system files (system-images, shared icons and so on..).

    We create a sub-repository for that (If you keep your dotfiles private, you could just sync them with the dotfiles and skip this step..)

    Init a new or clone an existing repository into the `shared`-directory (you could use [new_project.py](../scripts/python/new_project.py) for that or manually set it up over the website)

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



7. If you already have a file-repository: Add your file-repo as submodule to `files`

        git submodule add git@github.com:<username>/<files-repo> files
        git commit -m 'Added files as submodule'


8. If the submodul is correctly setup in your git-repo ..

        git submodule init
        git submodule update

        # to update submodules later:
        git submodule update
        # don't forget to checkout a branch BEFORE a commit (git checkout -b added) inside the submodules or the header will get messed up!


9. check if everything runs as expected (install more powershell-modules, etc.)\

10. customize

    - edit `aliases.ps1`, `functions.ps1`, `intro.ps1` & `prompt_colors.ps1` in `scripts/powershell/limbs/` to your taste\
    - customize installed modules & scripts\
    - share your thoughts with me
