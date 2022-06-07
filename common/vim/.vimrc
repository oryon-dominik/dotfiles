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
" set backupdir=$HOME/.config/vim/cache//,.
set noswapfile                              " no swap files
" set noundofile                            " no undofile
set undodir=$HOME/.config/vim/cache//,.

" search options
set hlsearch                                " highlight all results
set ignorecase                              " ignore case in search
" set incsearch                               " show search results as you type - already integrated in vim-sensible

set fileformats=unix    " use unix line endings (LF)

" TODO:spellchecking?!
" set spell spelllang=en_us
" set spellfile=$HOME/.config/vim/en.utf-8.add


" Install vim-plug if not found"
if empty(glob('$HOME/.config/vim/autoload/plug.vim'))
    silent !curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

if has('win32')
    " echo "WINDOWS"
else
    " echo "POSIX"
endif

call plug#begin('~/.config/vim/plugged')
    Plug 'junegunn/vim-plug'                " plugin-manager - https://github.com/junegunn/vim-plug/wiki
    
    Plug 'tpope/vim-sensible'               " sensible defaults 'everyone can agree on' - https://github.com/tpope/vim-sensible  # TODO: configure
    Plug 'dracula/vim', { 'as': 'dracula' } " Dracula theme

    Plug 'vim-airline/vim-airline'          " statusbar - https://github.com/vim-airline/vim-airline  # TODO: configure
    Plug 'vim-airline/vim-airline-themes'   " statusbar themes -
    Plug 'tpope/vim-fugitive'               " git plugin - https://github.com/tpope/vim-fugitive  # TODO: configure
    Plug 'tpope/vim-surround'               " surround everything with brackets - https://github.com/tpope/vim-surround  # TODO: configure
    Plug 'tpope/vim-commentary'             " comment in/out lines - https://github.com/tpope/vim-commentary  # TODO: configure

    Plug 'sickill/vim-pasta'                " fix vim-pasting - https://github.com/sickill/vim-pasta  # TODO: configure


    " TODO: add Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

    "TODO: configure: Plug 'vim-syntastic/syntastic'          " syntax checker - https://github.com/vim-syntastic/syntastic
    "TODO: configure: Plug 'ycm-core/YouCompleteMe'           " code completion - https://github.com/ycm-core/YouCompleteMe

call plug#end()

colo dracula


" gvim
set guifont=Consolas:h14
set guioptions-=m                           " no menu bar
set guioptions-=T                           " no toolbar
set guioptions-=r                           " no scrollbar
set langmenu=en_US.UTF-8                    " sets the language of the menu (gvim)


" <ESC> key for leaving insert mode is rather antiquated. Type <CAPSLOCK> instead.
" use the autohotkey-script for windows and remap the esc key to both <ESC> and <CAPSLOCK> on posix:
" setxkbmap -option caps:escape

" Change Your Leader Key: The leader is an activation key for shortcuts, and it's
" quite powerful. So if you are going to do some shortcut with the letter "c", for
" example, then you'd type whatever your leader key is followed by "c". By default
" it's the \ key, which is a bit out of the way on german keys, so I map it to the "#" key,

" let mapleader = "#"

" --extensions--

" vim-airline-statusbar
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_theme='violet'
let g:airline_powerline_fonts = 1
