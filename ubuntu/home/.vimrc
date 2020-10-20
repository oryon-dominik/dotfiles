set nocompatible

set nu              " show line numbers

set t_Co=256        " force terminal colors
syntax enable

set tabstop=4       " tab spacing

set shiftround      " always indent/outdent to the nearest tabstop
set expandtab       " use spaces instead of tabs

set nobackup        " no backup of files
set nowritebackup   " no backup while editing
set noswapfile      " no swap files
set noundofile      " no undofile


call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'junegunn/vim-plug'
call plug#end()

colo dracula
