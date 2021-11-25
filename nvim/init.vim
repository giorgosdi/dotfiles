source ~/.config/nvim/vim-plug/plugins.vim

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

augroup NoArrows
	let g:HardMode_level = 'wannabe'
	let g:HardMode_hardmodeMsg = 'Don''t use this!'
	autocmd VimEnter,BufNewFile,BufReadPost * :call HardMode()
augroup END

function! SubRef(r)
	let ref = substitute(a:r, "/", ":", "")
 return ref
endfunction

function! SplitRef(r, delimeter, pos)
	let ref = split(a:r, a:delimeter)
	return ref[a:pos]
endfunction

function! GetCurrentRef(path)
	let remove1 = SplitRef(a:path, ":", 1)
	let remove1 = SplitRef(remove1, ".git", 0)
	let yum = SubRef(remove1)
	return yum
endfunction

function! s:createPr()
	let remote = execute("Git remote get-url origin")
	let head = GetCurrentRef(remote)
	echo "!gh pr create -f --head " . head
endfunction

command! Createpr call <SID>createPr()

set scrolloff=8
set lazyredraw
set noswapfile
set incsearch
set ignorecase
set autoread
set rtp+=/usr/local/opt/fzf
set cursorline
set signcolumn=yes
set statusline+=%{get(b:,'gitsigns_status','')}

augroup CursorLine
	au VimEnter,WinEnter,BufEnter * :highlight CursorLineNr cterm=NONE guibg=DarkGrey guifg=DarkMagenta
	au VimEnter,WinEnter,BufEnter * :highlight LineNr guifg=Orange
	au VimEnter,WinEnter,BufEnter * :hi Comment guifg=Blue guibg=DarkGrey
	au VimEnter,WinEnter,BufEnter * :hi GitSignsAdd guifg=LightGreen 
	au VimEnter,WinEnter,BufEnter * :hi GitSignsDelete guifg=LightRed 
	au VimEnter,WinEnter,BufEnter * :hi GitSignsChange guifg=Navy 
	au VimEnter,WinEnter,BufEnter * :hi GitSignsAddNr guifg=White guibg=Green
	au VimEnter,WinEnter,BufEnter * :hi GitSignsDeleteNr guifg=White guibg=Red
	au VimEnter,WinEnter,BufEnter * :hi GitSignsChangeNr guifg=White guibg=Navy
augroup END

tnoremap <Esc> <C-\><C-n>

noremap <leader>b :CocCommand fzf-preview.Buffers<CR>
noremap gst :CocCommand fzf-preview.GitStatus<CR>
noremap gnb :Git checkout -b  
"noremap gpr :!gh pr create --fill<CR>
noremap gpr :Createpr<CR>
nmap gbcurrent :Git branch --show-current
nnoremap gcp :Git push -u origin :gbcurrent



colorscheme tokyonight

" source current file
nnoremap <C-space>s :source %<CR>

" edit/create a file
nmap <leader>e :e 
" NERDtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> NERDTree<CR>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let NERDTreeShowHidden=1
nn <leader>r :NERDTreeRefreshRoot<CR>

""""""
" TABS
""""""

"" Navigate tabs
nn <C-a> :tabp<CR>
nn <C-s> :tabn<CR>
"" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

"" Create  tabs
"add new tab and move it in the first pos
map <leader>I :tabe<CR>\|:tabmove 0<CR>
" add new tab next to the current one
map <leader>t :tabe<CR>
" add new tab and move it in the last pos
map <leader>A :tabe<CR>\|:tabmove $<CR> 

"" Close tab
nnoremap <leader>c :tabclose<CR>

"" Focus on current tab
map <leader>f <C-w>\|<CR>\|<C-w>_<CR>
map <leader>r <C-w>=<CR>


""""""""""""""""""
" PANE NAVIGATION
""""""""""""""""""
nn <C-S-Right> <C-w>l<CR>
nn <C-l> <C-w>l<CR>
nn <C-S-Left> <C-w>h<CR>
nn <C-h> <C-w>h<CR>
nn <C-S-Up> <C-w>k<CR>
nn <C-k> <C-w>k<CR>
nn <C-S-Down> <C-w>j<CR>
nn <C-j> <C-w>j<CR>

"""""""""
" SPLITS
"""""""""
nn <leader>s :split<CR>
nn <leader>v :vs<CR>
nn <leader>q :close<CR>

"" Resize splits horizontal
map <leader><Left> :vertical resize -5<CR>
map <leader><Right> :vertical resize +5<CR>      
map <leader><Up> :res +5<CR>
map <leader><Down> :res -5<CR>
""""""
" COPY TO CLIPBOARD
""""""
" Cope the entire line
map <leader>cc "*yy
" Copy just the word
map <leader>cw "*yiw

map <leader>cp "*p

"""""
"FUGITIVE
"""""
nnoremap gcb :GBranches<CR>
map gb :Git blame<CR>

nnoremap  <space>s :w<CR>
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set autochdir
set number

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_highlight_functions = 1
let g:go_auto_type_info = 1

"""""
" SYNTASTIC & YAMLLINT
"""""

""""""
" CtrlP
""""""
let g:ctrlp_working_path_mode = 'ra'


"""""
" YAML
"""""
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_enabled = 1
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set foldlevelstart=20

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'


" memolist
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>mg  :MemoGrep<CR>


" CoC
nnoremap <leader>ml :CocCommand fzf-preview.MemoList

"""""
" CURSOR
"""""
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"


let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=1x7"
let &t_EI = "\<Esc>]50;CursorShape=1\x7"

" Telescope remaps
nnoremap <Leader>pp :lua require'telescope.builtin'.planets{}<CR>
nnoremap <C-p> :lua require'telescope.builtin'.git_files{}<CR>
nnoremap <leader>gr :lua require'telescope.builtin'.live_grep{}<CR>
nnoremap gst :lua require'telescope.builtin'.git_status{}<CR>
nnoremap <leader>td :TodoTelescope<CR>
