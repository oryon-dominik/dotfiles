# ubuntu-dotfile-environment

> This is about: How-to configure your own dotfile repository

We just curl and run the install script. The repo get's cloned into `~/.dotfiles`.
To modify feel free to fork your own version ;-)

ATTENTION. THIS SCRIPT WILL REPLACE THE FOLLOWING FILES WITHOUT ASKING

```bash
/etc/motd
~/.pyenv
~/.bash_profile
~/.bash_aliases
~/.bash_logout
~/.bash_profile
~/.bashrc
~/.profile
~/.config/htoprc
~/.config/fish/config.fish
~/.config/fish/functions/fish_prompt.fish
~/.config/fish/functions/last_command_as_sudo.fish
~/.config/fish/functions/pyenv.fish
```

```bash
curl -s https://raw.githubusercontent.com/oryon-dominik/dotfiles/master/ubuntu/install/install.sh | bash -i
```
