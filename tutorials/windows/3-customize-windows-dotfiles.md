# dotfiles customization

#### UNDER HEAVY CONSTRUCTION USE AT YOUR OWN RISK ########

## THIS IS BROKEN FOR NOW -  DON'T USE

Start with customizing your local settings.

Create the missing-files  # TODO: create the missing files when checking for them

```powershell
mkdir $env:DOTFILES/scripts/powershell/machines
New-Item -ItemType file $env:DOTFILES/scripts/powershell/machines/$env:computername.ps1
New-Item -ItemType file $env:DOTFILES/scripts/powershell/acronyms/locations.ps1
```

Install Additional packages & powershell Modules, place additional symlinks

Customize scripts & aliases

# TODO: group aliases logically

# examples
echo "function dev { set-location (Join-Path -Path $settings.cloud -ChildPath '\Development') }" >> $ENV:DOTFILES/scripts/powershell/acronyms/locations.ps1

TODO: create an empty .env


TODO: Symlink all the other programs. (after installing them)
example:
```powershell
Remove-Item -path $env:APPDATA/alacritty -recurse
mkdir $env:APPDATA/alacritty
New-Item -Path "$env:APPDATA/alacritty" -ItemType Junction -Value "$env:DOTFILES/common/alacritty"
# TODO: gitconfig, geany, 
```


TODO: 12. put your program-links into shared/$env:computername/shortcuts and add them to your desktop or taskbar via script\
TODO: link to windows-installation tutorial\
TODO: write install-script following this tutorial

TODO: expand to private settings & how-to-hold-secrets

Create and extend:

.repositories.txt
locals/git_too_big_to_prompt


7. If you already have a shared-repository: Clone it.


10. customize

    - edit `aliases.ps1`, `functions.ps1` or `intro` in `scripts/powershell/**` to your taste  
    - customize installed modules & scripts  
    - share your thoughts with me  
