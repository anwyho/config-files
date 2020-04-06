"          __                    
"   .--.--|__.--------.----.----.
"  _|  |  |  |        |   _|  __|
" |__\___/|__|__|__|__|__| |____|
" These are some sick VIM configs. 
"   As in they need to be made well.

" Inspiration taken from https://github.com/amix/vimrc

"
" C O N F I G S
"

" Set the leader to , for extra key mappings
let mapleader = ","

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif
" Creates undo directory
if !isdirectory("/tmp/.vim-undo-dir")
    call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif

set ai             " set autoindent
set autoread       " set to auto read when a file is changed from outside
set expandtab      " expand tabs to spaces
set hid            " hide buffer when abandoned
set hlsearch       " highlight search results
set incsearch      " 
set ignorecase     " ignore case when searching
set lazyredraw     " only redraw lines during macros when necessary (performance)
set magic          " for regex
" set noantialias  " commented out for nvim
set nobackup
set noerrorbells   " no error bells
set noswapfile
set nowritebackup
set novisualbell   " no visual bells
set number         " line numbers
set relativenumber " relative line numbers
set ruler          " show cursor position at all times
set showmatch      " show matching brackets when hovered
set si             " set smart indent
set smartcase      " when searching, be smart about case
set smarttab       " be smart about tabbing
set splitbelow     " splits down
set splitright     " splits right
set termguicolors  " enable true colors support
set undofile       " persistent undos
set undodir=/tmp/.vim-undo-dir " set directory for undo information
" set wrap           " wrap lines

" set clipboard^=unnamed,unamedplus " set clipboard to vim buffer  " commented out for nvim
set encoding=utf-8
set guioptions-=r  " disables scrollbars
set guioptions-=R  " "
set guioptions-=l  " "
set guioptions-=L  " "
set history=1000   " set how many lines VIM will remember
set laststatus=2   " always display status line
set mat=2          " set how many deciseconds to blink when matching brackets
set numberwidth=4
set shiftwidth=4   " set how many spaces to indent
set so=8           " set how many lines to the cursor when moving vertically
set tabstop=4      " set how many spaces in a tab
" set textwidth=80   " set a visual marker for column
set textwidth=100 
set wrapmargin=0
set formatoptions-=t
set undodir=~/.vim/undo/
set undolevels=1000
set undoreload=10000

try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>



"
" A P P E A R A N C E
"

set background=dark

" let base16colorspace=256

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif
highlight LineNr guibg=NONE


"
" R E M A P S
"

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
" command W w !sudo tee % > /dev/null

" MOVEMENT
" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" TABS
" Tab command aliases
cabbrev tp tabprev
cabbrev tn tabnext
cabbrev tf tabfirst
cabbrev tl tablast

" NORMAL MODE
" Bind K to search word under cursor
" nnoremap K :Ag "\b<C-R><C-W>\b"<CR>:cw<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Quickly open a buffer for scribble
" Quickly open a markdown buffer for scribble
nnoremap <leader>x :e ~/.buffer.md<cr>

" Get off my lawn
" nnoremap <Left> :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up> :echoe "Use k"<CR>
" nnoremap <Down> :echoe "Use j"<CR>

" Prevent weird behavior
nnoremap <C-z> <NOP>
nnoremap K <NOP>
nnoremap <C-s> :w
nnoremap q: :q
nnoremap :W :w
nnoremap :Q :q
nnoremap :nu :set nu! rnu!  " toggle line numbers
nnoremap :spell :set spell!  " toggle spellcheck
nnoremap :wrap :set wrap!  " toggle wrap

" COMMAND MODE

" Sudo save
" cnoremap w!! w !sudo tee > /dev/null %<CR>

" INSERT MODE
" Map auto complete of (, ", ', [
" inoremap ( ()<esc>ha
" inoremap [ []<esc>ha
" inoremap { {}<esc>ha
" inoremap < <><esc>ha
" inoremap ' ''<esc>ha
" inoremap " ""<esc>ha

" inoremap jj <ESC>jj
" inoremap kk <ESC>kk

" VISUAL MODE
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"
" A U T O  E D I T S
"

" Give Zsh RC file Shell syntax highlighting
autocmd BufEnter *.zshrc :setlocal filetype=sh

" Automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Return to last edit position when reopening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre .txt,.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 72 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=72
augroup END



"
" P L U G I N S
"

" Plugin Manager: vim-plug
" https://github.com/junegunn/vim-plug

" Download vim-plug plugin manager
" If this doesn't work, try setting GIT_SSL_NO_VERIFY=true
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install plugins if vim-plug is installed
" Throw vim plugins in here with the syntax
"   Plug 'author/plugin.vim'
" Then run
"   :PlugInstall
" This automatically executes
"   filetype plugin indent on
"   syntax enable
" To remove a plugin, comment out the plugin and 
"   :PlugClean
call plug#begin('~/.vim/plugged')
" THEMES
" Plug 'arcticicestudio/nord-vim'
Plug 'chriskempson/base16-vim'
" Plug 'ayu-theme/ayu-vim'
" Plug 'nightsense/snow'
Plug 'nightsense/carbonized'


" powerline variant
" Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'

"filesystem explorer (loads NERDTree on demand)
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" most-recently-used files
" Plug 'yegappan/mru', {'on': 'MRU'}

" git gutter
Plug 'airblade/vim-gitgutter', {'on': 'GitGutterToggle'}

" Python
" better indentation
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}

" Terminus
" better terminal integration
" specifically for changing carets in Vim from ZSH
Plug 'wincent/terminus'

" To Research:
" ??
" Plug 'vim-scripts/a.vim'

" yank stack
" Plug 'maxbrunsfeld/vim-yankstack', {'on': ''}

" python-specific autocompletion
" Plug 'Valloric/YouCompleteMe', {'for': 'python', 'do': './install.py'}

" visual star search
" Plug 'bronson/vim-visual-star-search'

" git commands
Plug 'tpope/vim-fugitive'

" fuzzy file search
" Plug 'ctrlpvim/ctrlp.vim'

" better tab completion
Plug 'ervandew/supertab'

" snippet engine & library
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

"Initialize plugins
call plug#end()



"
" P L U G I N  C O N F I G S
"

" Colorscheme
set background=dark
" colorscheme base16-default-dark


" Airline
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_theme='angr'

" Ayu-theme
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme

" Git Gutter
set updatetime=100
" set signcolumn=yes
nnoremap <silent> <leader>d :GitGutterToggle<cr>

" Lightline.vim
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'carbonized_dark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'mode_map': {
      \ 'n' : ' N',
      \ 'i' : ' I',
      \ 'R' : ' R',
      \ 'v' : ' V',
      \ 'V' : 'VL',
      \ "\<C-v>": 'VB',
      \ 'c' : ' C',
      \ 's' : ' S',
      \ 'S' : 'SL',
      \ "\<C-s>": 'SB',
      \ 't': ' T',
      \ },
      \ }

" MRU
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>D

" NERDTree
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '_pycache_']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>Plug 'chriskempson/base16-vim'

" YankStack
let g:yankstack_yank_keys = ['y', 'd']

