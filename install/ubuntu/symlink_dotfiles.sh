#!/bin/sh
# symlink all the configs from common applications
# fish
ln -sfv $HOME/.dotfiles/common/fish/config.fish $HOME/.config/fish/config.fish
ln -sfv $HOME/.dotfiles/common/fish/aliases.fish $HOME/.config/fish/aliases.fish
ln -sfv $HOME/.dotfiles/common/fish/functions/wsl_config.fish $HOME/.config/fish/functions/wsl_config.fish
ln -sfv $HOME/.dotfiles/common/fish/functions/last_command_as_sudo.fish $HOME/.config/fish/functions/last_command_as_sudo.fish
# we already installed the pyenv plugin for fish, but we have to fix it, since it's a little deprecated
ln -sfv $HOME/.dotfiles/common/fish/functions/pyenv.fish $HOME/.config/fish/functions/
# bash
ln -sfv $HOME/.dotfiles/common/bash/.bash_aliases $HOME
ln -sfv $HOME/.dotfiles/common/bash/.bash_logout $HOME
# git
ln -sfv $HOME/.dotfiles/common/git/.gitconfig $HOME
# alacritty
ln -sfv $HOME/.dotfiles/common/alacritty/alacritty.yml $HOME/.config/alacritty/
ln -sfv $HOME/.dotfiles/common/alacritty/bindings.yml $HOME/.config/alacritty/
ln -sfv $HOME/.dotfiles/common/alacritty/dracula.yml $HOME/.config/alacritty/
ln -sfv $HOME/.dotfiles/common/alacritty/hints.yml $HOME/.config/alacritty/
# htop
ln -sfv $HOME/.dotfiles/common/htop/htoprc $HOME/.config/
# starship
ln -sfv $HOME/.dotfiles/common/starship/starship.toml $HOME/.config/
