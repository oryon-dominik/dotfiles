#!/bin/sh

# set environment variables
export DOTFILES=~/.dotfiles
export PYTHON_VERSION=3.8.5

## install required software
# update first
sudo apt update
sudo apt upgrade

# htop
sudo apt install htop -y

# Install required packages, including git (for the plugins) and fzf for completion
sudo apt install software-properties-common git hub git-flow fzf -y
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y
# for fish-motd:
sudo apt install fortune-mod fortune-anarchism lolcat

# clone the dotfiles repository
mkdir ~/.dotfiles && git clone https://github.com/oryon-dominik/dotfiles.git ~/.dotfiles

# message of the day
ln -sv ~/.dotfiles/ubuntu/motd/motd /etc/motd
# We don't need the help text
sudo rm /etc/update-motd.d/10-help-text
# And we deactivate the dynamic news
sudo sed -i -e 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news

# setup fish
mkdir ~/.config && mkdir ~/.config/fish && mkdir ~/.config/fish/functions

ln -sv ~/.dotfiles/ubuntu/home/.config/fish/config.fish ~/.config/fish/config.fish
ln -sv ~/.dotfiles/ubuntu/home/.config/fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
ln -sv ~/.dotfiles/ubuntu/home/.config/fish/functions/last_command_as_sudo.fish ~/.config/fish/functions/last_command_as_sudo.fish

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# To add extended command-completion, async prompt, gitnow & dracula theme & pyenv
fisher add jethrokuan/fzf
fisher add acomagu/fish-async-prompt
fisher add joseluisq/gitnow
fisher add dracula/fish
fisher add daenney/pyenv

# create some dirs
mkdir ~/projects
mkdir ~/.virtualenvs

# symlink all the configs from ubuntu/home
ln -sv ~/.dotfiles/ubuntu/home/.bash_profile ~
ln -sv ~/.dotfiles/ubuntu/home/.bash_aliases ~
ln -sv ~/.dotfiles/ubuntu/home/.bash_logout ~
ln -sv ~/.dotfiles/ubuntu/home/.bash_profile ~
ln -sv ~/.dotfiles/ubuntu/home/.bashrc ~
ln -sv ~/.dotfiles/ubuntu/home/.profile ~
# htop
ln -sv ~/.dotfiles/ubuntu/home/.config/htoprc ~/.config/htoprc

## pyenv
# we need a c compiler & other dependencies
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

sudo curl https://pyenv.run | bash
pyenv update

# for fish we already installed the pyenv plugin,
# but we have to fix it, since it's a little deprecated
ln -sv ~/.dotfiles/ubuntu/home/.config/fish/functions/pyenv.fish ~/.config/fish/functions/pyenv.fish

# install vim-plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install python
pyenv update
# then install your desired python (pyenv install --list)
# this may take a while!
pyenv install $PYTHON_VERSION
pyenv rehash
# show if everthing is right
pyenv versions
pyenv global $PYTHON_VERSION
python -m pip install --upgrade pip

# And poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
# set the path inline with virtualfish
poetry config virtualenvs.path ~/.virtualenvs/

python -m pip install virtualenvwrapper
# And virtualfish (virtualenvwrapper for fish), including plugins
python -m pip install virtualfish
# to activate the vf-command
eval (python -m virtualfish)
touch ~/.config/fish/conf.d/virtualfish-loader.fish
vf install compat_aliases

# Install docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# We are changing fish to our standard-shell now
fish
# and add poetry & pyenv to the path
source $HOME/.poetry/env
set -U fish_user_paths $fish_user_paths $HOME/.poetry/bin
set -U PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths /usr/local/bin /sbin $PYENV_ROOT/bin $PYENV_ROOT/shims

# add /bin/fish to /etc/shells
sudo echo "/bin/fish" >> /etc/shells
chsh -s (which fish)
# enter the users password
