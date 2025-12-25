set number
set nocompatible
set showmatch
set ignorecase
set mouse=v
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set expandtab 
set shiftwidth=4
set number
set mouse=a
set clipboard=unnamedplus
set cursorline
set ttyfast
filetype plugin indent on
syntax enable

call plug#begin()

    Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
    Plug 'vim-airline/vim-airline'

call plug#end()

lua require("toggleterm").setup()

autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>
