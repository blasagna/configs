" Basic Vim 9 Configuration
set nocompatible

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

" Rust-specific configuration (rust.vim)
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 0
let g:rust_fold = 1

" LSP configuration (yegappan/lsp)
let g:lsp_servers = [#{
    \   name: 'rust-analyzer',
    \   filetype: ['rust'],
    \   path: 'rust-analyzer',
    \   args: [],
    \   syncInit: v:true
    \ }]

let g:lsp_options = #{
    \   autoComplete: v:true,
    \   autoHighlightDiags: v:true,
    \   showDiagWithSign: v:true,
    \   showInlayHints: v:true,
    \   showSignature: v:true
    \ }

" LSP key mappings
nnoremap <silent> gd <cmd>LspGotoDefinition<CR>
nnoremap <silent> K <cmd>LspHover<CR>
nnoremap <silent> gr <cmd>LspShowReferences<CR>
nnoremap <silent> <leader>rn <cmd>LspRename<CR>
nnoremap <silent> <leader>ca <cmd>LspCodeAction<CR>
nnoremap <silent> [d <cmd>LspDiag prev<CR>
nnoremap <silent> ]d <cmd>LspDiag next<CR>

