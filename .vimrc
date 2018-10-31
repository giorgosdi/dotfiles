set nocompatible              " required
filetype off                  " required
call plug#begin('~/.vim/plugged')


Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe'
Plug 'https://github.com/m-kat/aws-vim'
Plug 'kien/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'enricobacis/vim-airline-clock'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'farmergreg/vim-lastplace'
Plug 'wvffle/vimterm'
Plug 'terryma/vim-multiple-cursors' "	https://github.com/terryma/vim-multiple-cursors
Plug 'tpope/vim-fugitive'



call plug#end()

"	Python section
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

let python_highlight_all=1
syntax on

"" Pylint
set makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
set errorformat=%f:%l:\ %m
