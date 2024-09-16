#!/bin/sh

# set environment variables
export DOTFILES=$HOME/.dotfiles
export PYTHON_VERSION=3.12.6

# update first
sudo apt update
sudo apt upgrade

# === install packages ========================================================
# TODO: install from ansible-repo


# WARNING: all code below is deprecated, use ansible instead

sudo apt install -y htop
sudo apt install -y software-properties-common git git-flow
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish
# for fish-motd:
sudo apt install -y fortune-mod fortune-anarchism lolcat

# clone the dotfiles repository
mkdir -p $HOME/.dotfiles
git -C $HOME/.dotfiles pull || git clone https://github.com/oryon-dominik/dotfiles.git $HOME/.dotfiles

# === symlinks & configuration ================================================

# message of the day
sudo ln -sfv $HOME/.dotfiles/common/motd/motd /etc/
# We don't need the help text
sudo rm --force /etc/update-motd.d/10-help-text
# And we deactivate the dynamic news
sudo sed -i -e 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news

# setup fish
mkdir -p $HOME/.config && mkdir -p $HOME/.config/fish && mkdir -p $HOME/.config/fish/functions



# create some dirs
mkdir -p $HOME/.virtualenvs
mkdir -p $HOME/.config/alacritty


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

## uv
# we need a c compiler & other dependencies
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

curl -LsSf https://astral.sh/uv/install.sh | sh

# Install python
# then install your desired python (uv python list --all-versions)
# this may take a while!
uv python install $PYTHON_VERSION
# show if everthing is right

python -m pip install --upgrade pip

python -m pip install --user virtualenvwrapper

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# add /bin/fish to /etc/shells
sudo sh -c "echo /bin/fish >> /etc/shells"

# activate fish-shell
fish -i
set -U fish_user_paths /usr/local/bin /sbin $HOME/.local/bin (yarn global bin) $fish_user_paths

source $HOME/.dotfiles/common/fish/install_fisher_plugins.fish

source $HOME/.dotfiles/install/ubuntu/symlink_dotfiles.sh

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


# TODO: run install-cargo-tools.sh
