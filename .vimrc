set nocompatible

syntax on               " enable syntax highlighting
set cursorline          " highlight the current line
set nobackup            " don't create pointless backup files; Use VCS instead
set number              " show line numbers
set showcmd             " show selection metadata
set showmode            " show INSERT, VISUAL, etc. mode
set scrolloff=5         " show at least 5 lines above/below


" bells
set noerrorbells        " turn off audio bell
set visualbell          " but leave on a visual bell

" search
set hlsearch            " highlighted search results
set showmatch           " show matching bracket


set mouse=a
set backspace=2
set tabstop=4
set shiftwidth=4
"set softtabstop=4
set selectmode=mouse
set laststatus=2

filetype indent plugin on
filetype on
filetype plugin on
" filetype indent on

set pastetoggle=<F2>
" Fast saving
nmap <leader>w :w!<cr>
map <M-1> 1gt " 
map <M-2> 2gt
map <M-3> 3gt
set incsearch
set noexpandtab
set mouse=a
map <silent> <leader><cr> :noh<cr>

"Always show current position
set ruler
" tab navigation like firefox
nnoremap <C-t>     :tabnew<CR>

nnoremap <A-F1> 1gt
nnoremap <A-F2> 2gt
nnoremap <A-F3> 3gt
nnoremap <A-F4> 4gt
nnoremap <A-F5> 5gt
nnoremap <A-F6> 6gt
nnoremap <A-F7> 7gt
nnoremap <A-F8> 8gt
nnoremap <A-F9> 9gt
nnoremap <A-F0> 10gt


:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+\%#\@<!$/
" Show leading whitespace that includes spaces, and trailing whitespace.
:autocmd BufWinEnter * match ExtraWhitespace /^\s* \s*\|\s\+$/

