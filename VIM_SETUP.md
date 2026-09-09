# Vim Setup & Plugin Dependencies

This document provides an overview of your Vim 9 configuration ([~/.vimrc](file:///home/bob/.vimrc)), the package management structure, and the plugins it depends on.

---

## 1. Plugin Management Overview

This configuration uses Vim's native package system introduced in Vim 8 and expanded in Vim 9. Plugins placed under `~/.vim/pack/<any-name>/start/` are automatically discovered and loaded during startup when `filetype plugin indent on` is active in `~/.vimrc`.

- **Package Directory**: [`~/.vim/pack/plugins/start/`](file:///home/bob/.vim/pack/plugins/start/)
- **Configuration File**: [`~/.vimrc`](file:///home/bob/.vimrc)
- **Vim Version**: Vim 9.2 (Huge version)

---

## 2. Installed Plugins & Dependencies

### 1. `rust-lang/rust.vim`
- **Location**: [`~/.vim/pack/plugins/start/rust.vim/`](file:///home/bob/.vim/pack/plugins/start/rust.vim/)
- **Repository**: [https://github.com/rust-lang/rust.vim](https://github.com/rust-lang/rust.vim)
- **Role**: Official Vim support for Rust. Handles filetype detection, syntax highlighting, syntax-based code folding, formatting via `rustfmt`, and compilation shortcuts.

#### External Tool Dependencies
| Dependency | Path / Source | Purpose |
| :--- | :--- | :--- |
| `rustc` | `~/.cargo/bin/rustc` | Rust compiler integration |
| `cargo` | `~/.cargo/bin/cargo` | Cargo command runner (`:Cargo <command>`) |
| `rustfmt` | `~/.cargo/bin/rustfmt` | Automatic and manual code formatting |

#### Configurations in `.vimrc`
```vim
" Rust-specific configuration (rust.vim)
let g:rustfmt_autosave = 1       " Automatically run rustfmt on buffer save (:w)
let g:rustfmt_fail_silently = 0   " Show errors in quickfix if rustfmt fails
let g:rust_fold = 1               " Enable syntax folding for Rust code blocks
```

#### Key Commands
- `:RustFmt` — Format the current buffer.
- `:RustFmtRange` — Format visually selected range.
- `:Cargo <command>` — Run a cargo command (e.g. `:Cargo check`, `:Cargo build`).

---

### 2. `yegappan/lsp`
- **Location**: [`~/.vim/pack/plugins/start/lsp/`](file:///home/bob/.vim/pack/plugins/start/lsp/)
- **Repository**: [https://github.com/yegappan/lsp](https://github.com/yegappan/lsp)
- **Role**: A fast, lightweight Language Server Protocol (LSP) client written in native Vim9 script. Provides intelligent autocompletion for types, methods, fields, and imports, along with diagnostics and code navigation.

#### External Tool Dependencies
| Dependency | Path / Source | Purpose |
| :--- | :--- | :--- |
| `rust-analyzer` | `~/.cargo/bin/rust-analyzer` (via `rustup component add rust-analyzer`) | Semantic code analysis, autocompletion, type inference |

#### Configurations in `.vimrc`
```vim
" LSP configuration (yegappan/lsp)
let g:lsp_servers = [#{
    \   name: 'rust-analyzer',
    \   filetype: ['rust'],
    \   path: 'rust-analyzer',
    \   args: [],
    \   syncInit: v:true
    \ }]

let g:lsp_options = #{
    \   autoComplete: v:true,           " Automatically trigger completion popup menu as you type
    \   autoHighlightDiags: v:true,     " Highlight diagnostic issues in buffer
    \   showDiagWithSign: v:true,       " Show warning/error signs in the sign column
    \   showInlayHints: v:true,         " Display inline type hints
    \   showSignature: v:true           " Show function signature helper
    \ }
```

#### Key Mappings & Shortcuts
| Shortcut | Command | Action |
| :--- | :--- | :--- |
| `gd` | `:LspGotoDefinition` | Jump to definition of symbol under cursor |
| `K` | `:LspHover` | Show documentation and type hover popup |
| `gr` | `:LspShowReferences` | Find all references across project |
| `<leader>rn` | `:LspRename` | Rename symbol across project |
| `<leader>ca` | `:LspCodeAction` | Open code actions (auto-import, implement traits) |
| `]d` / `[d` | `:LspDiag next` / `prev` | Jump to next / previous diagnostic |
| `Ctrl-N` / `Ctrl-P` | *Built-in* | Navigate autocomplete popup |
| `Ctrl-X Ctrl-O` | *Omni completion* | Manually trigger LSP autocomplete |

---

## 3. Built-in Vim Filetype Plugins

Your `~/.vimrc` also configures features for Vim's built-in filetype plugins:

### Markdown Folding
```vim
let g:markdown_folding = 1
let g:markdown_fold_style = 'nested'
```
- Handled by Vim's internal Markdown runtime (`$VIMRUNTIME/ftplugin/markdown.vim`).
- Enables hierarchical outline folding for headers in Markdown files.

---

## 4. Maintenance & Updates

To update all installed plugins to their latest versions, run:
```bash
# Update rust.vim
cd ~/.vim/pack/plugins/start/rust.vim && git pull

# Update yegappan/lsp
cd ~/.vim/pack/plugins/start/lsp && git pull
```

To add another language or plugin in the future:
1. Clone the git repository into `~/.vim/pack/plugins/start/<plugin-name>`.
2. If it's a language server, add its configuration to `g:lsp_servers` in `~/.vimrc`.
