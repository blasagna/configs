" Basic Vim 9 Configuration

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Enable file type detection, plugins, and indentation
filetype plugin indent on

" Use 4 spaces for tabs (common for Python, C, C++, Shell)
set expandtab
set shiftwidth=4
set softtabstop=4

" Enable auto-indentation
set autoindent
set smartindent

" Highlight the current line
set cursorline

" Case insensitive search unless pattern contains uppercase
set ignorecase
set smartcase

" Enable mouse support
set mouse=a

" Better command-line completion
set wildmenu

" Do not fold by default
set foldlevelstart=99

" Markdown-specific: Enable basic folding
let g:markdown_folding = 1
let g:markdown_fold_style = 'nested'
