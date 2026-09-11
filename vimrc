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
"
" clangd takes its flags from a project's compile_commands.json. Without one it
" falls back to a bare `clang <file>`, which on Fedora means C++17 (clang's
" default) even though this machine's gcc defaults to C++20 -- so C++20 code
" that Bazel builds fine still lights up red -- and means no -I paths at all,
" so any third-party header (gtest, Eigen, CLI11) reads as "file not found".
"
" Generate that file for a Bazel workspace with :BazelCompDB below. The
" C++17-vs-C++20 fallback for files no build system knows about is pinned in
" ~/.config/clangd/config.yaml.
let g:lsp_servers = [#{
    \   name: 'rust-analyzer',
    \   filetype: ['rust'],
    \   path: 'rust-analyzer',
    \   args: [],
    \   syncInit: v:true
    \ }, #{
    \   name: 'clangd',
    \   filetype: ['c', 'cpp'],
    \   path: 'clangd',
    \   args: [
    \     '--background-index',
    \     '--clang-tidy',
    \     '--completion-style=detailed',
    \     '--header-insertion=never',
    \     '--pch-storage=memory',
    \     '-j=4',
    \     '--query-driver=/usr/bin/gcc,/usr/bin/g++'
    \   ],
    \   rootSearch: ['compile_commands.json', 'MODULE.bazel', 'WORKSPACE',
    \                'WORKSPACE.bazel', 'compile_flags.txt', '.git/'],
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

" Regenerate compile_commands.json for the Bazel workspace containing the
" current file, then restart clangd so it picks the new flags up. Re-run after
" adding a BUILD target, a new source file, or a new external dependency.
command! -nargs=* BazelCompDB call s:BazelCompDB(<q-args>)
function! s:BazelCompDB(args) abort
  let l:dir = expand('%:p:h')
  if l:dir ==# '' | let l:dir = getcwd() | endif
  echo 'Running bazel-compdb (this can take a moment)...'
  let l:out = system('cd ' .. shellescape(l:dir) .. ' && bazel-compdb ' .. a:args .. ' 2>&1')
  if v:shell_error
    echohl ErrorMsg | echom 'bazel-compdb failed:' | echohl None
    for l:line in split(l:out, '\n') | echom l:line | endfor
  else
    echom substitute(split(l:out, '\n')[-1], '^\s*', '', '')
    LspServer restart
  endif
endfunction
