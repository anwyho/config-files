"          __                    
"   .--.--|__.--------.----.----.
"  _|  |  |  |        |   _|  __|
" |__\___/|__|__|__|__|__| |____|
" These are some sick VIM configs. 
"   As in they need to be made well.

set tabstop=2
set shiftwidth=2
set expandtab
syntax on
"colorscheme diokai
"colorscheme immortals
"colorscheme nord
"colorscheme sialoquent
"colorscheme simplifysimplify-dark
"colorscheme tomatosoup
"colorscheme vim-material
"colorscheme vrunchbang-dark

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'arcticicestudio/nord-vim'
call plug#end()
