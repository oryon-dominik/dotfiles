set nocompatible

set number          " show line numbers

set t_Co=256        " force terminal colors
syntax on           " enable syntax highlighting

set tabstop=4       " tab spacing

set shiftround      " always indent/outdent to the nearest tabstop
set expandtab       " use spaces instead of tabs

set nobackup        " no backup of files
set nowritebackup   " no backup while editing
set noswapfile      " no swap files
set noundofile      " no undofile

set hlsearch        " highlight all results
set ignorecase      " ignore case in search
set incsearch       " show search results as you type

call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'junegunn/vim-plug'
call plug#end()

colo dracula

" drop plugins undeR: ~/.vim/pack/pluginfoldername/ start/pluginname

"Remap the ESC Key: Firstly, the <ESC> key for leaving insert mode is—in my 
"opinion—rather antiquated. Vim is about efficiency, and it's hardly efficient
" to leave the home keys if you don't have to. So don't.
"This will make it so that you can type jk instead of pressing ESC, which is much easier since they're home keys!

" inoremap <CAPS> <ESC>   # tODO: lookup teh correct key for caps lock

" Change Your Leader Key: The leader is an activation key for shortcuts, and it's
" quite powerful. So if you are going to do some shortcut with the letter "c", for
" example, then you'd type whatever your leader key is followed by "c". By default
" it's the \ key, which is a bit out of the way, so I like to map it to the "'" key,
" which is right to the right of the "l" key on your right pinky.

" let mapleader = "#"

