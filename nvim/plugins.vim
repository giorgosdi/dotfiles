call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support "
    Plug 'sheerun/vim-polyglot'
    " Auto pairs for '(' '[' '{' "
    Plug 'jiangmiao/auto-pairs'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'hashivim/vim-terraform'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-rhubarb'
    Plug 'fatih/vim-go'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nvim-lua/plenary.nvim' " Gitsings/telescope dependency
    Plug 'lewis6991/gitsigns.nvim', {'branch': 'release'}
    " Telescope deps
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
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

    " Disable arrows
    Plug 'wikitopian/hardmode'

    call plug#end()

lua << EOF
  require("trouble").setup {}
  require("todo-comments").setup {}
  require("telescope").setup {
      defaults = {
            file_sorter = require('telescope.sorters').get_fzy_sorter,
             prompt_prefix = ' 🔍',
             
             file_previewer =require('telescope.previewers').vim_buffer_cat.new
      },
      extenstions = {
          fzy_native ={
            override_generic_sorter = false,
            override_file_sorter = true,
          }
      }
  }
  require("gitsigns").setup {
      sign_priority = 10,
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
      current_line_blame = true,
      current_line_blame_opts = {
            delay = 200,
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1,
            virt_text_pos = 'eol'
          },
      preview_config = {
          border='single'
          },
    }
EOF
