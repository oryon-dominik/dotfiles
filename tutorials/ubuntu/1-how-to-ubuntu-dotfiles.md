# ubuntu-dotfile-environment

> This is about: How-to configure your own dotfile repository

We just curl and run the install script. The repo get's cloned into `~/.dotfiles`.
To modify feel free to fork your own version ;-)

ATTENTION. THIS SCRIPT WILL REPLACE THE FOLLOWING FILES WITHOUT ASKING

```bash
# and even more.. I forget to care for this list ocassionally.. 
# anyway they are all mentioned inside the scripts symlink_dotfiles.sh or the install.sh .. have a look.
/etc/motd
~/.vimrc
~/.pyenv
~/.bash_profile
~/.bash_aliases
~/.bash_logout
~/.bash_profile
~/.bashrc
~/.profile
~/.gitconfig
~/.config/htoprc
~/.config/starship.toml
~/.config/fish/config.fish
~/.config/fish/functions/fish_prompt.fish
~/.config/fish/functions/last_command_as_sudo.fish
~/.config/fish/functions/wsl_config.fish
~/.config/fish/functions/pyenv.fish
~/.config/alacritty/*
~/.config/vim/*
```

Install.

```bash
curl -s https://raw.githubusercontent.com/oryon-dominik/dotfiles/master/install/ubuntu/install.sh | bash -i
```

The script will clone the dotfiles via https, to use ssh add your key and change the origin.
