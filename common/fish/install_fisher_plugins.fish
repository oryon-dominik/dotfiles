#!/usr/bin/env fish

# add fisher and fish plugins
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# install extensions
fisher install edc/bass         # Use bash utilities in fish
fisher install dracula/fish     # Dracula theme for fish

# pyenv support for fish
rm $HOME/.config/fish/functions/pyenv.fish
fisher install daenney/pyenv
# we have to fix it, since it's a little deprecated
rm $HOME/.config/fish/functions/pyenv.fish
ln -sfv $HOME/.dotfiles/common/fish/functions/pyenv.fish $HOME/.config/fish/functions/
