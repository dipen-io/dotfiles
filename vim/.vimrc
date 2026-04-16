" ============================================================
"  .vimr — Programming-focused Vim configuration
"  Sections:
"    1. General settings
"    2. Look & feel
"    3. Key mappings
"    4. Plugins (vim-plug)
"    5. Language-specific settings
" ============================================================


" ============================================================
" 1. GENERAL SETTINGS
" ============================================================

set nocompatible            " Use Vim defaults (not Vi)
set encoding=utf-8          " Default encoding
set fileencoding=utf-8
set hidden                  " Allow switching buffers without saving
set nobackup                " No backup files
set noswapfile              " No swap files (use version control instead)
set undofile                " Persistent undo across sessions
set undodir=~/.vim/undodir  " Where to store undo history
set history=1000            " Remember more command history
set autoread                " Auto-reload files changed outside Vim
set clipboard=unnamedplus   " Use system clipboard (Linux); use 'unnamed' on macOS
set mouse=a                 " Enable mouse support
set backspace=indent,eol,start  " Sane backspace behavior
set splitright              " Vertical splits open to the right
set splitbelow              " Horizontal splits open below
set updatetime=300          " Faster completion & git gutter updates
set timeoutlen=500          " Key sequence timeout (ms)


" ============================================================
" 2. LOOK & FEEL
" ============================================================

syntax on                   " Enable syntax highlighting
set background=dark         " Dark background
colorscheme desert          " Built-in dark theme; override after installing a plugin theme

set number                  " Show absolute line numbers
set relativenumber          " Show relative line numbers (great for motions)
set cursorline              " Highlight the current line
set colorcolumn=80,120      " Vertical rulers at 80 and 120 chars
set signcolumn=yes          " Always show sign column (for git/lint signs)
set scrolloff=8             " Keep 8 lines visible above/below cursor
set sidescrolloff=5         " Keep 5 columns visible left/right
set wrap                    " Wrap long lines visually (no horizontal scroll)
set linebreak               " Break at word boundaries when wrapping
set showmatch               " Highlight matching brackets
set matchtime=2             " Tenths of a second to show matching bracket
set list                    " Show invisible characters
set listchars=tab:»·,trail:·,nbsp:·,extends:›,precedes:‹

" --- Search ---
set hlsearch                " Highlight search results
set incsearch               " Show match as you type
set ignorecase              " Case-insensitive search...
set smartcase               " ...unless query has uppercase


" ============================================================
" 3. KEY MAPPINGS
" ============================================================

" Leader key
let mapleader = ","         " Space as leader

" --- Essentials ---
" Clear search highlight
nnoremap <leader>/ :nohlsearch<CR>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" --- Navigation ---
" Move between splits with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize splits with arrow keys
nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Navigate buffers
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :buffers<CR>

" Move lines up/down in normal and visual mode
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" --- Editing ---
" Keep cursor centered when jumping search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Indent/unindent in visual mode and stay in mode
vnoremap < <gv
vnoremap > >gv

" Duplicate line
nnoremap <leader>d yyp

" Delete without yanking (send to black hole register)
nnoremap <leader>D "_d
vnoremap <leader>D "_d

" Yank to end of line (consistent with D and C)
nnoremap Y y$

" --- Terminal ---
nnoremap <leader>t :terminal<CR>
tnoremap <Esc> <C-\><C-n>   " Exit terminal mode with Esc

" --- Quick config reload ---
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ev :e $MYVIMRC<CR>


" ============================================================
" 4. PLUGINS (vim-plug)
" ============================================================
" Install vim-plug if not already installed:
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then run :PlugInstall inside Vim.

call plug#begin('~/.vim/plugged')

" --- Colorscheme ---
Plug 'morhetz/gruvbox'                  " Popular dark theme

" --- File & project navigation ---
Plug 'ctrlpvim/ctrlp.vim'              " Fuzzy file finder

" --- Git integration ---
Plug 'airblade/vim-gitgutter'           " Show git diff in sign column
Plug 'tpope/vim-fugitive'               " Git commands inside Vim

" --- Editing utilities ---
Plug 'tpope/vim-surround'               " cs, ds, ys to change/delete/add surroundings
Plug 'tpope/vim-commentary'             " gc to toggle comments
Plug 'jiangmiao/auto-pairs'             " Auto-close brackets, quotes, etc.
Plug 'mg979/vim-visual-multi'           " Multiple cursors

" --- Syntax & language support ---
Plug 'sheerun/vim-polyglot'             " Syntax for 100+ languages

" --- Autocompletion ---
Plug 'prabirshrestha/vim-lsp'           " LSP client
Plug 'mattn/vim-lsp-settings'           " Auto-configure LSP servers
Plug 'prabirshrestha/asyncomplete.vim'  " Async completion engine
Plug 'prabirshrestha/asyncomplete-lsp.vim' " LSP source for asyncomplete

" --- Linting ---
Plug 'dense-analysis/ale'               " Async linting & fixing

" --- Code display ---
Plug 'Yggdroot/indentLine'              " Show indent guides
Plug 'RRethy/vim-illuminate'            " Highlight word under cursor

call plug#end()

" --- Plugin configuration ---

" Gruvbox colorscheme (override the built-in 'desert' set above)
let g:gruvbox_contrast_dark = 'medium'
autocmd VimEnter * ++nested colorscheme gruvbox

" CtrlP
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Airline
let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1   " Show buffers as tabs
let g:airline_powerline_fonts = 0              " Set to 1 if you have a Nerd Font

" ALE linting & fixing
let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'python':     ['flake8', 'pylsp'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tsserver'],
\   'go':         ['gopls'],
\   'rust':       ['analyzer'],
\}
let g:ale_fixers = {
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\   'python':     ['black', 'isort'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'go':         ['gofmt', 'goimports'],
\   'rust':       ['rustfmt'],
\}
let g:ale_sign_error   = '✗'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign   ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

" vim-lsp key mappings
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nnoremap <buffer> gd         :LspDefinition<CR>
  nnoremap <buffer> gr         :LspReferences<CR>
  nnoremap <buffer> gi         :LspImplementation<CR>
  nnoremap <buffer> gt         :LspTypeDefinition<CR>
  nnoremap <buffer> K          :LspHover<CR>
  nnoremap <buffer> <leader>rn :LspRename<CR>
  nnoremap <buffer> <leader>ca :LspCodeAction<CR>
  nnoremap <buffer> [d         :LspPreviousDiagnostic<CR>
  nnoremap <buffer> ]d         :LspNextDiagnostic<CR>
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" indentLine
let g:indentLine_char = '│'


" ============================================================
" 5. LANGUAGE-SPECIFIC SETTINGS
" ============================================================

augroup lang_settings
  autocmd!

  " --- Python ---
  autocmd FileType python setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    \ textwidth=88
    \ colorcolumn=88,120
    \ autoindent

  " --- JavaScript / TypeScript ---
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact setlocal
    \ tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " --- HTML / CSS ---
  autocmd FileType html,css,scss,sass setlocal
    \ tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " --- Go ---
  autocmd FileType go setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

  " --- Rust ---
  autocmd FileType rust setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4 expandtab

  " --- Shell ---
  autocmd FileType sh,bash,zsh setlocal
    \ tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " --- YAML / JSON ---
  autocmd FileType yaml,json setlocal
    \ tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " --- Markdown ---
  autocmd FileType markdown setlocal
    \ tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    \ wrap linebreak spell

  " --- Makefile: must use real tabs ---
  autocmd FileType make setlocal noexpandtab

augroup END

" --- Default indentation (for anything not matched above) ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" ============================================================
" Create undodir if it doesn't exist
" ============================================================
if !isdirectory($HOME.'/.vim/undodir')
  call mkdir($HOME.'/.vim/undodir', 'p')
endif
