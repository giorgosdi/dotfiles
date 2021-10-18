call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support "
    Plug 'sheerun/vim-polyglot'
    " Auto pairs for '(' '[' '{' "
    Plug 'jiangmiao/auto-pairs'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'hashivim/vim-terraform'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'fatih/vim-go'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'lewis6991/gitsigns.nvim', {'branch': 'release'}
    " Checkout branch with a prompted box
    Plug 'stsewd/fzf-checkout.vim'
    Plug 'junegunn/fzf',  { 'do': { -> fzf#install() } }
    """"""""""""""""""""""""""""""""""""""
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-surround'
    " Colourschemes
    Plug 'flazz/vim-colorschemes'
    Plug 'morhetz/gruvbox'
    Plug 'folke/tokyonight.nvim'
    """"YAML""""
    Plug 'pedrohdz/vim-yaml-folds'
    Plug 'Yggdroot/indentLine'
    Plug 'dense-analysis/ale'
    """ autocomplete """
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'glidenote/memolist.vim'

    " Vim Script
    Plug 'folke/todo-comments.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'folke/trouble.nvim'
    Plug 'BurntSushi/ripgrep'

call plug#end()

lua << EOF
  require("trouble").setup {}
  require("todo-comments").setup {}
EOF
