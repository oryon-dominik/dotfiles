# Tidal-Cycles Windows Installation

> How-to install tidal-cycles on Windows

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Preparation

I am using the package-mananger [chocolaty](https://chocolatey.org), you can install it via an admin-powershell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

And [visual studio code](https://code.visualstudio.com/) (to install type: `choco install vscode`) for live-coding.

Check if:

- Haskell is installed (`choco install haskell-stack`)
- Super-Collider is installed (`choco install supercollider`)
- `sh.exe` is on your path (`$env:path="$env:path;<path_to_sh.exe>"`)

Then install Tidal-Cycless

## Installation

```powershell
cabal update
cabal install tidal
```

Install the vscode tidalcycles plugin

```powershell
code.cmd --install-extension tidalcycles.vscode-tidalcycles
```

Start SuperCollider, choose `Open startup file` from the `file-menu` and in the editor window paste in the following line of code into `startup.scd`:

```SuperCollider
include("SuperDirt")
```

Run the code by clicking on it, to make sure the cursor is on this line, then hold down `<shift>` and press `<enter>`.

It will download SuperDirt and you will see it has completed when the Post Window displays:

```SuperCollider
... the class library may have to be recompiled.
-> SuperDirt
```

Save the file.
Restart SuperCollider.

Voilá
