set nocompatible                            " be ViMproved

set runtimepath=$HOME/.config/vim,$VIMRUNTIME

set number                                  " show line numbers

set t_Co=256                                " force terminal colors
syntax on                                   " enable syntax highlighting
language en                                 " sets the language of the messages

set tabstop=4                               " tab spacing

set shiftround                              " always indent/outdent to the nearest tabstop
set expandtab                               " use spaces instead of tabs

set nobackup                                " no backup of files
set nowritebackup                           " no backup while editing
set noswapfile                              " no swap files
" set noundofile                            " no undofile
set undodir=$HOME/.config/vim/cache//,.

set hlsearch                                " highlight all results
set ignorecase                              " ignore case in search
set incsearch                               " show search results as you type


set fileformats=unix    " use unix line endings (LF)

" set backupdir=$HOME/.config/vim/cache/
" set spell spelllang=en_us
" set spellfile=$HOME/.config/vim/en.utf-8.add


" Install vim-plug if not found"
if empty(glob('$HOME/.config/vim/autoload/plug.vim'))
    silent !curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if !has('win32')
    " Run PlugInstall if there are missing plugins"
    " autocmd VimEnter *
    " \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
    " \|   PlugInstall | q
    " \| endif
    " echo "POSIX"
endif
if has('win32')
    " Run PlugInstall if there are missing plugins"
    " autocmd VimEnter *
    " \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
    " \|   PlugInstall | q
    " \| endif
    " echo "Win"
endif

call plug#begin('~/.config/vim/plugged')
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'junegunn/vim-plug'
call plug#end()



" gvim
set guifont=Consolas:h14
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)



" colo dracula

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

