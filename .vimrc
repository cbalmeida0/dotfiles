" TO INSTALL
"  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"  Copy this file to /home/user/.vimrc
"  Enter at VIM and execute :BundleInstall

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ENCODING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencoding=utf-8

let mapleader=","

" let Vundle manage Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'abacha/ctrlp.vim'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-tbone'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'

syntax enable
filetype plugin indent on

let g:netrw_home="~/.vim/backup"

" Open vimrc with <leader>v
nmap <leader>v :edit $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<cr>

let g:indent_guides_auto_colors=1
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent=3
let g:indent_guides_guide_size=0
noremap <leader>ig :IndentGuidesToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UNBIND KEYS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>

" Tab spacing/size
set tabstop=2 "number of spaces on tab
set shiftwidth=2 "number of spaces to ident
set softtabstop=2
set expandtab "convert tabs to spaces
set smarttab

set backspace=indent,eol,start
set listchars=tab:▸\ ,eol:¬,trail:·,precedes:«,extends:»
set textwidth=80
set linebreak
set showbreak=…

" Screen offset
set sidescroll=8
set scrolloff=8

set autoindent
set smartindent
set ignorecase "ignore case when searching
set smartcase
set incsearch
set showmatch
set matchtime=2
set ruler "show cursor pos on status bar
set number "show line number
set relativenumber
set autoread
set wildmenu
set wildmode=list:longest
set shortmess=atI
set timeoutlen=500
set wrap
set wrapmargin=80
set visualbell "no crazy beeping
set hidden
set title
set cc=+1

set backupdir=~/.vim/backup,~/tmp,/var/tmp,/tmp
set directory=~/.vim/backup,~/tmp,/var/tmp,/tmp

set wildignore+=*/.hg/*,*/.svn/*
set wildignore+=*.o,moc_*.cpp,*.exe,*.qm
set wildignore+=.gitkeep,.DS_Store

" Toggle paste mode with <leader>p
set pastetoggle=<leader>p
function! PasteCB()
  set paste
  set nopaste
endfunction

" Save/quit typos
cab W w| cab Q q| cab Wq wq| cab wQ wq| cab WQ wq| cab Bd bd| cab Wa wa| cab WA wa
autocmd BufWritePre * :%s/\s\+$//e

inoremap jj <esc>

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

"""""""""""""""""""""""
" WINDOW MANAGEMENT   "
"""""""""""""""""""""""

" Split
noremap <C-\> :vsp<CR>
noremap <C--> :sp<CR>

" Resize
noremap <Up> <C-w>+
noremap <Down> <C-w>-
noremap <Left> <C-w>>
noremap <Right> <C-w><

" Move around
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

"""""""""""""""""""""""
"     SHORTCUTS       "
"""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>
map <C-b> :CtrlPBuffer<CR>

"""""""""""""
"   Ack     "
"""""""""""""
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nnoremap <Leader>a :exe 'Ack!' expand('<cword>')<cr>
cnoreabbrev Ack Ack!
cnoreabbrev G Ack!
""""""""""""
" CtrlP    "
" """"""""""""
nmap <C-B> :CtrlPBuffer<cr>
" Open buffer with <C-B>
let g:ctrlp_custom_ignore='\.git$\|\.pdf$'
let g:ctrlp_use_caching=0
let g:ctrlp_max_height=10
let g:ctrlp_extensions=['quickfix']
let g:ctrlp_user_command={
      \ 'types' : {
      \ 1: ['.git', 'cd %s && git ls-tree -r HEAD | grep -v -e "^\d\+\scommit" | cut -f 2']
      \ },
      \ 'fallback': 'find %s -name "tmp" -prune -o -print'
      \ }
nnoremap <C-f> :CtrlPFallback<CR>

function! CleverTab()
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-N>"
  endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>


function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':vsp ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<buinsess\>') || match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
nnoremap <leader>s <c-w>o :call OpenTestAlternate()<cr>
