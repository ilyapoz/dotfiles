scriptencoding utf-8

" {{{ plugins
if filereadable(expand("~/.vimrc.plugins"))
  source ~/.vimrc.plugins
endif
" }}}

syntax on           " Syntax highlighting on
set autowrite       " Automatically write on buffer switching
set incsearch       " Incremental search
set hlsearch        " Highlight the search results
set ignorecase      " Ignore case when searching
set smartcase       " Case sensitive when uppercase letters are in the prompt

set tabstop=4       " Tabstop defaults
set shiftwidth=4    " The shiftwidth
set softtabstop=4   " The magic softtabstop that backspaces in one shot
set expandtab       " Expand tabs to spaces. Yes, I've moved to the dark side =)
set shiftround      " round to 'shiftwidth' for '<<' and '>>'

filetype plugin indent off   " Filetype based indentation
set cindent                 " Now, let's try this, C indentation

set wrap            " Wrapping is a good idea
set linebreak       " Break lines on words only (wrap mode! :help wrap)
set display+=lastline       " Display the last line partially
set modeline        " Modelines should be cool TODO: check out the bugs mentioned in vimrc
set modelines=2     " Look for modeline in first/last 2 lines
set backspace=2     " Backspacing everywhere
set showmatch       " Show the matching parenthesis...
set matchtime=2     " for 2 1/10th of a second
set virtualedit=    " No virtualedit nowhere

set title           " Turn on title setting
set wildmenu        " Turn on completion menu
set cpoptions+=$    " Don't redisplay changed line immediately

set showcmd         " Show the command being composed in status
set number          " Turn line numbering on
" the following leads to PRESS enter to continue with Vundle, dunno
set laststatus=2    " Status line every time
" This is very-very slow for doxy and stuff :(
" set cursorline      " Highlight the current line

set spelllang=ru,en " Internal speller language settings
set fileencodings=ucs-bom,utf8,cp1251,koi8-r,latin-1,default " Those are file encodings for guessing. The first single-byte is chosen, so everything after cp1251 has no effect

set wildignore=*.o,*.d,*.lo,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn,*.aux,*.out,*.toc,*.log,*.orig " Don't tab-complete those extensions

set hidden          " Allow running from modified buffers (warns of course if not :qa!)

set backup              " Yes, we like backups...
set backupdir=~/.backup " when they don't clutter the current dir

" Let's now try this: bring folding to help
" syntax foldmethod slows everything down!
set foldmethod=indent
set nofoldenable
"set foldminlines=15
"set foldlevelstart=2
"set foldnestmax=3
"set foldcolumn=2


let backuppath=expand(&backupdir)
  if (!isdirectory(backuppath))
    call mkdir(backuppath)
  endif
unlet backuppath

set mouse=a                 " Full mouse support

if has("mouse_sgr")
  set ttymouse=sgr
end

set printencoding=koi8-r    " Printing, printing...
set printoptions+=duplex:off

set tags=./tags;/           " Make vim find tags in parent directories recursively

" title setting for screen
if &term =~# "^screen"
    set t_ts=]2;
    set t_fs=
endif

if &t_Co==256
  try
    " Take a look at vimrc.local
    if (has("termguicolors"))
      set termguicolors
    endif

    colorscheme nord
  catch /^Vim\%((\a\+)\)\=:E185/
    " deal with it
  endtry
endif

"" CScope setup
"if has("cscope")
"    set cscopetag           " Use cscope for ^] etc
"    set cscopetagorder=0    " cscope tags first, then ctags
"
"    set cscopequickfix=s-,c-,d-,i-,t-,e-    " use quickfix window
"
"    set nocscopeverbose
"    " add any database in current directory
"    if filereadable("cscope.out")
"        cs add cscope.out
"        " else add database pointed to by environment
"    elseif $CSCOPE_DB != ""
"        cs add $CSCOPE_DB
"    endif
"    set cscopeverbose
"endif

" These are for easy navigation inside wrapped lines
noremap  <silent> <Up>   gk
noremap  <silent> k      gk
noremap  <silent> <Down> gj
noremap  <silent> j      gj
" noremap  <buffer> <silent> <Home> g<Home>
" noremap  <buffer> <silent> 0      g0
" noremap  <buffer> <silent> ^      g^
" noremap  <buffer> <silent> $      g$
" noremap  <buffer> <silent> <End>  g<End>
inoremap <silent> <Up>   <C-o>gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Home> <C-o>g<Home>
inoremap <silent> <End>  <C-o>g<End>

" This is to find "{" "}" not in the first column
nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

" This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
  silent exe "normal! `[v`]\"_c"
  silent exe "normal! p"
endfunction

" {{{ Plugin specific
filetype plugin on          " Filetype plugins such as latexsuite
" latexsuite specific
" set grepprg=grep\ -nH\ $*
" let g:Tex_CompileRule_dvi='latex -src-specials -interaction nonstopmode $* %'
" let g:Tex_ViewRule_dvi='xdvi'
" let g:tex_flavour='latex'

" tagbar specific
let g:tagbar_compact=1

" Doxygen highlighting, we want it!
let g:load_doxygen_syntax=1
" }}}

let g:indentLine_char = '|'
let g:indentLine_color_term = 236

let g:NERDTreeChDirMode = 2
let g:NERDTreeMouseMode = 3
let g:NERDTreeWinSize = 50
let g:NERDTreeRespectWildIgnore = 1

let g:ctrlp_extensions = ['buffertag']

let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "*.swp"
      \ --ignore ".*.swp"
      \ --ignore "*.pyc"
      \ -g ""'

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = 'a'
" let g:ctrlp_lazy_update = 1
"
let c_no_curly_error=1

let g:csearch_keyword = 0

let g:airline_powerline_fonts = 1

" from standard vimrc
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" This cool mapping uses ctags to find the filename under cursor. Make sure to
" run ctags with --extra=+f
nnoremap gF :exe 'tag '.expand('<cfile>')<cr>

" Allow saving of files as sudo when I forgot to start vim using sudo.
command Sudow w !sudo tee > /dev/null %

" Some convenience mappings
command W w
map Q <Nop>

" {{{ Tmux pane navigation
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1

if $TMUX != ''
  " integrate movement between tmux/vim panes/windows

  nnoremap <silent> <c-w>h :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-w>l :TmuxNavigateRight<cr>
  nnoremap <silent> <c-w>k :TmuxNavigateUp<cr>
  nnoremap <silent> <c-w>j :TmuxNavigateDown<cr>

  nnoremap <silent> <c-w><left> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-w><right> :TmuxNavigateRight<cr>
  nnoremap <silent> <c-w><up> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-w><down> :TmuxNavigateDown<cr>

  " Mostly for internal usage by tmux
  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
  nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
endif
" }}}

" {{{ vim_current_word
highlight CurrentWord ctermbg=240 cterm=NONE
highlight CurrentWordTwins ctermbg=240
" }}}

" {{{ key bindings
let mapleader=","   " <Leader> is ,
nnoremap <c-g> 1<c-g>

" Toggle diff view on the left, center, or right windows
nmap <silent> <leader>dl :call DiffToggle(1)<cr>
nmap <silent> <leader>dc :call DiffToggle(2)<cr>
nmap <silent> <leader>dr :call DiffToggle(3)<cr>


" Use K to :grep
nnoremap K :Ggrep! "\b<C-R><C-W>\b"<CR>:cw<CR>

let g:alternateSearchPath = 'sfr:.,sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sfr:../../src/libros'

" F keys
nnoremap <F2> :TagbarToggle<CR>
nnoremap <F3> :A<CR>
nnoremap <F5> :make<CR>

" fzf
nnoremap <Leader>t :call fzf#run(fzf#wrap({'source': 'git ls-files'}))<CR>
nnoremap <c-t> :call fzf#run(fzf#wrap({'source': 'git ls-files'}))<CR>

" nerd tree
nnoremap <Leader><tab> :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>

" sideways
nnoremap g) :SidewaysRight<CR>
nnoremap g( :SidewaysLeft<CR>

" viewing modes
nnoremap <Leader>l :set list!<CR>
nnoremap <Leader>w :set wrap!<CR>
nnoremap <Leader>p :set paste!<CR>
nnoremap <Leader>e :set expandtab!<CR>
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>n :set number!<CR>:IndentLinesToggle<CR>
nnoremap <Leader>i :IndentLinesToggle<CR>
nnoremap <Leader>c :VimCurrentWordToggle<CR>

" fugitive
nnoremap <Leader>cn :Git blame<CR>
nnoremap <Leader>cd :Git diff<CR>
nnoremap <Leader>cl :Git log<CR>

" vim-bookmarks
nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mi <Plug>BookmarkAnnotate
nmap <Leader>ma <Plug>BookmarkShowAll
nmap <Leader>mj <Plug>BookmarkNext
nmap <Leader>mk <Plug>BookmarkPrev
nmap <Leader>mc <Plug>BookmarkClear
nmap <Leader>mx <Plug>BookmarkClearAll
nmap <Leader>mkk <Plug>BookmarkMoveUp
nmap <Leader>mjj <Plug>BookmarkMoveDown
nmap <Leader>mg <Plug>BookmarkMoveToLine

" }}}

set concealcursor=nc
let g:indentLine_concealcursor = 'nc'

let g:splice_initial_mode="path"
let g:splice_initial_diff_path="2"


" {{{ vimrc.local
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
" }}}

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
