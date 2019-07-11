# Fedora Linux Installation

[![SOILA](http://www.soila.de/wp-content/uploads/2017/10/soila_analytics_logo_signet_32px.png)](http://www.soila.de)

$~$
**Ein Projekt von oryon-dominik@soila - smart opportunities in leveraging analytics**

> How-to install fedora linux

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#markdown-header-preparations)
- [Installation](#markdown-header-installation)

---

## Preparations

Set environment variables to your needs.
$your_hostname
$your_username
$your_password

// TODO: create installation script
// TODO: make tutorial howto use it with fedora-shell (e.g: wget install-script and settings.json from the config-repo)
// TODO: make script versatile with its options:

- partition sizes etc..
- partition names
- language used
- keyboard locales
- bootmanager
- be flexible to use either kde/gnome/xfce UIs
- list of packages to install in packages.json

## Installation

```shell

sudo dnf upgrade
reboot

dnf install htop

# dnf install fortune - for the fish-greeting  # TODO look up the correct package name
```

### fish

in ~/.config/fish/config.fish insert:

```config.fish
set fish_color_cwd cyan
set fish_greeting "Hello Commander"
set -U EDITOR vim
function fish_greeting
      fortune -a
end
```

choose dracula from "$ fish_config" and classic prompt
the color for commands is third line second column

install fish-aliases

autocomplete:

```fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fisher add jethrokuan/fzf
```

activate last command as sudo with `!!!` (is copy of bash-script..)

```fish
function !!!
   eval sudo $history[1]
end

funcsave !!!
```

reload the fish_config # TODO: look path/name up

activate fish for the user at login with `usermod -s /usr/bin/fish username` or `chsh -s /usr/bin/fish`  # TODO: look up difference

add sbin tou your path!
`set -U fish_user_paths /sbin $fish_user_paths`

## bootsplash

copy your background to `/usr/share/backgrounds/elementary/<filename>`
change the default-wallpaper in `/etc/lightdm/pantheon-greeter.conf`

`dnf install plymouth-plugin-script`

copy your theme # TODO description and example-theme

`sudo plymouth-set-default-theme <theme-name> -R`

## keyring

because chrome and other applications keep asking to unlock your keyring, you
can change your password-store to basic to prevent that message. ATTENTION
your password may be stored unencrypted and be possibly exposed

`cp /usr/share/applications/google-chrome.desktop ~/.local/share/applications`

Find each of the lines that begin with Exec and add `--password-store=basic`
like so
`Exec=/usr/bin/google-chrome-stable --password-store=basic %U`
