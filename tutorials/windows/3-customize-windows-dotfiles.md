# dotfiles customization

> This is under UNDER HEAVY CONSTRUCTION USE AT YOUR OWN RISK

Feel free to customize all scripts & aliases. Share your thoughts with me!

Edit `Aliases.ps1`, or `intro` in `common/powershell/` to your taste. Customize installed modules & scripts.

Some hints on usage below.


## custom dotenv

I hold some custom settings and secrets (API keys and stuff like that) in my `.env` - that is of course not version controlled.
Example: To skip searching for your devices location via the google-api, set `DOTFILES_SKIP_DEVICE_LOCATION=true` inside your `.env`.

For full functionality you need to define:

```.env
# shell (for poetry)
SHELL=C:\Program Files\PowerShell\7\pwsh.exe
# disable virtualenv prompt to use my custom prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
# openweathermap api key - for the 'weather' command to work
OPEN_WEATHERMAP_API_KEY=
# google api key, used for cliTube and my hockey-TV in CLI scripts
GOOGLE_YOUTUBE_API_KEY=
# google api key & cx to use the search json api in CLI
GOOGLE_SEARCH_API_KEY=
GOOGLE_PROGRAMMABLE_SEARCH_ENGINE_ID=
# google geocoding api key for the working geo device locator
GOOGLE_MAPS_API_KEY=
DOTFILES_SKIP_DEVICE_LOCATION=false
# cloud storage mount point & project dir for faster access
CLOUD_MOINT_POINT=K:/
PROJECTS=C:/dev
```


## custom locations

Example:
```powershell
echo "function djangoproject { set-location (Join-Path -Path '$env:PROJECTS' -ChildPath '\djangoproject'); workon (venvName) }" >> "$env:DOTFILES/common/powershell/Locations.ps1"
```

## reproducible program shortcuts

Put your program-shortcuts into a seperate folder `"$env:DOTFILES/shared/$env:computername/shortcuts"` and add them to your desktop or taskbar. # TODO: write a script to automate that.


## custom upgrade

If you have git repositories that should be pulled on an `upgrade`. Put links to the directories into `"$env:DOTFILES/.repositories.txt"`.


## shared files

I'm using another repository for logfiles, private notes and backup stuff, that I mount to the `"$env:DOTFILES/shared"` for easy access.  
If you already have a shared-repository: Clone it into `"$env:DOTFILES/shared"`.
