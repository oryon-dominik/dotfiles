# Development with Python, vscode & WSL (Ubuntu) on Windows 10

> How-to install and configure WSL by the example of Ubuntu

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#markdown-header-preparations)
- [Installation](#markdown-header-installation)

---

## Preparations

1. Open an admin powershell and type `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`

2. Install ubuntu from windows- store (or from chocolatey via powershell : `choco install wsl-ubuntu-<version>`)
    You can list available distributions on your system with `wslconfig /l` and set the default with `wslconfig /setdefault <name>`

3. (Optional) Install vscode remote- & wsl-extensions (right now [19.06.2019] these are available only in the insiders-edition, not yet in stable releases)

4. (Optional) Install a X-server for windows, I recommend [vcxsrv](https://sourceforge.net/projects/vcxsrv/) (`choco install vcxsrv`) and configure Display and OpenGL in `.bashrc` (see below)

5. start distro from powershell: `wsl -d ubuntu`

## Installation

Inside wsl:

- install updates `sudo apt update`

- and upgrade the preinstalled software `sudo apt upgrade`

- install a desktop environment `sudo apt install xfce4`

### `~/.bashrc`

For the X-server

```.bashrc
export DISPLAY=:0.0
export LIBGL_ALWAYS_INDIRECT=1
```

Aliases

```.bashrc
alias ..="cd .."
alias cd..="cd .."

```

The prompt

  (Colors):
        purple \[\033[35m\]
        red \[\033[31m\]
        white \[\033[37m\]
        blue \[\033[34m\]
        yellow \[\033[33m\]

```.bashrc
PS1="${debian_chroot:+($debian_chroot)}\[\033[35m\]\v \[\033[01;37m\]\u\[\033[31m\]@\[\033[37m\]\h \[\033[34m\][\[\033[37m\]\t\[\033[34m\]] \[\033[01;33m\]\w \[\033[37m\]git \[\033[35m\]> \[\033[37m\]"
```

Config-settings for the virtual environments

```.bashrc
export WORKON_HOME=~/Envs
source $HOME/.local/bin/virtualenvwrapper.sh
```

Finally `source ~/.bashrc`

## Install Modules for Development

```bash
sudo apt install git-flow
sudo apt install python-pip


pip install virtualenv
pip install virtualenvwrapper
sudo apt install virtualenvwrapper
```

`sudo apt install python3 python3-pip ipython3`
`sudo apt install python3.7`

`mkvirtualenv -p /usr/bin/python3.7 <venvname>`

don't forget to install the development building compiler libraries

`sudo apt-get install python-dev python3-dev sudo apt install python3.7-dev build-essential python-pip`
`sudo apt install leptonica-dev`
`sudo apt install tesseract-ocr`

to get the full package of open-ssh-server (minimal is preinstalled)
`sudo apt-get remove  openssh-server`
`sudo apt-get install  openssh-server`

## [Docker setup](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly)

Download and add Docker's official public PGP key.
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

Verify the fingerprint.
`sudo apt-key fingerprint 0EBFCD88`

Add the `stable` channel's Docker upstream repository.

If you want to live on the edge, you can change "stable" below to "test" or
"nightly". I highly recommend sticking with stable!

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Update the apt package list (for the new apt repo).
`sudo apt-get update -y`

Install the latest version of Docker CE.
`sudo apt-get install -y docker-ce`

Allow your user to access the Docker CLI without needing root access.
`sudo usermod -aG docker $USER`

`pip install --user docker-compose`

Set general setting to expose the docker-deamon on your windows-client to tcp://localhost:2375 without TLS

create the file `/etc/wsl.conf` on your wsl with the following contents

```wsl.conf
[automount]
root = /
options = "metadata"
```

now reboot (full-reboot!) your windows machine

## setup SSH

in your windows-powershell dir into ~/.ssh

```powershell
ssh-keygen -t rsa -C <email>
Set-Service ssh-agent -StartupType Manual
ssh-agent
ssh-add <KEYNAME>
```

TODO: sync wsl over several machines, write a config-script (fish/aliases etc) for that
