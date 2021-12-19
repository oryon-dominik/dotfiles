#!/bin/sh

# set environment variables
export DOTFILES=$HOME/.dotfiles
export PYENV_ROOT=$HOME/.pyenv
export PYTHON_VERSION=3.10.1

## install required software
# update first
sudo apt update
sudo apt upgrade

# htop
sudo apt install -y htop

# Install required packages, including git (for the plugins) and fzf for completion
sudo apt install -y software-properties-common git hub git-flow fzf
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish
# for fish-motd:
sudo apt install -y fortune-mod fortune-anarchism lolcat

# clone the dotfiles repository
mkdir -p $HOME/.dotfiles
git -C $HOME/.dotfiles pull || git clone https://github.com/oryon-dominik/dotfiles.git $HOME/.dotfiles

# message of the day
sudo ln -sfv $HOME/.dotfiles/common/motd/motd /etc/
# We don't need the help text
sudo rm --force /etc/update-motd.d/10-help-text
# And we deactivate the dynamic news
sudo sed -i -e 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news

# setup fish
mkdir -p $HOME/.config && mkdir -p $HOME/.config/fish && mkdir -p $HOME/.config/fish/functions

ln -sfv $HOME/.dotfiles/common/fish/config.fish $HOME/.config/fish/config.fish
ln -sfv $HOME/.dotfiles/common/fish/aliases.fish $HOME/.config/fish/aliases.fish

ln -sfv $HOME/.dotfiles/common/fish/functions/wsl_config.fish $HOME/.config/fish/functions/wsl_config.fish
ln -sfv $HOME/.dotfiles/common/fish/functions/last_command_as_sudo.fish $HOME/.config/fish/functions/last_command_as_sudo.fish


# create some dirs
mkdir -p $HOME/projects
mkdir -p $HOME/.virtualenvs
mkdir -p $HOME/.config/alacritty

# symlink all the configs from ubuntu/home and common
ln -sfv $HOME/.dotfiles/common/bash/.bash_aliases $HOME
ln -sfv $HOME/.dotfiles/common/bash/.bash_logout $HOME
# ln -sfv $HOME/.dotfiles/ubuntu/home/.bash_profile $HOME
# ln -sfv $HOME/.dotfiles/ubuntu/home/.bashrc $HOME
ln -sfv $HOME/.dotfiles/common/git/.gitconfig $HOME
# alacritty
ln -sfv $HOME/.dotfiles/common/alacritty/alacritty.yml $HOME/.config/alacritty/
ln -sfv $HOME/.dotfiles/common/alacritty/bindings.yml $HOME/.config/alacritty/
ln -sfv $HOME/.dotfiles/common/alacritty/dracula.yml $HOME/.config/alacritty/
ln -sfv $HOME/.dotfiles/common/alacritty/hints.yml $HOME/.config/alacritty/
# htop
ln -sfv $HOME/.dotfiles/common/htop/htoprc $HOME/.config/

# install vim-plugins
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install docker
sudo apt install -y docker.io
# sudo systemctl start docker
sudo systemctl enable docker

if grep --quiet microsoft /proc/version; then
    #--WSL----
    :
else
    # "native linux"
    :
fi

## pyenv
# we need a c compiler & other dependencies
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

sudo rm -rf $HOME/.pyenv
sudo curl https://pyenv.run | bash

# Install python
pyenv update
# then install your desired python (pyenv install --list)
# this may take a while!
pyenv install $PYTHON_VERSION
# show if everthing is right
pyenv global $PYTHON_VERSION
pyenv versions
pyenv rehash
python -m pip install --upgrade pip

# And poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
source $HOME/.poetry/env
# set the path inline with virtualfish
poetry config virtualenvs.path $HOME/.virtualenvs/

python -m pip install --user virtualenvwrapper

# install pipx
python -m pip install --user pipx
python -m pipx ensurepath

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# add /bin/fish to /etc/shells
sudo sh -c "echo /bin/fish >> /etc/shells"

# activate fish-shell
fish -i
# and add poetry & pyenv to the path
set -U PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths /usr/local/bin /sbin $HOME/.poetry/bin $HOME/.local/bin $PYENV_ROOT/bin $PYENV_ROOT/shims (yarn global bin) $fish_user_paths

source $HOME/.dotfiles/common/install_fisher_plugins.fish

# for fish we already installed the pyenv plugin,
# but we have to fix it, since it's a little deprecated
ln -sfv $HOME/.dotfiles/common/fish/functions/pyenv.fish $HOME/.config/fish/functions/

# And virtualfish (virtualenvwrapper for fish), including plugins
pipx install virtualfish
# mkdir -p $HOME/.config/fish/conf.d
# touch $HOME/.config/fish/conf.d/virtualfish-loader.fish
# to activate the vf-command
# eval (python -m virtualfish)
vf install
vf addplugins compat_aliases

set -U VIRTUAL_ENV_DISABLE_PROMPT true

# change the shell to fish
sudo chsh --shell /bin/fish "$USER"
