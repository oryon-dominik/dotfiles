#!/usr/bin/env fish

# add fisher and fish plugins
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# install extensions
fisher install edc/bass         # Use bash utilities in fish
fisher install dracula/fish     # Dracula theme for fish
fisher install daenney/pyenv    # pyenv support for fish
