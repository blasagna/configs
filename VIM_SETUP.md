# Vim Setup & Plugin Dependencies

This document provides an overview of your Vim 9 configuration ([~/.vimrc](file:///home/bob/.vimrc)), the package management structure, and the plugins it depends on.

---

## 1. Plugin Management Overview

This configuration uses Vim's native package system introduced in Vim 8 and expanded in Vim 9. Plugins placed under `~/.vim/pack/<any-name>/start/` are automatically discovered and loaded during startup when `filetype plugin indent on` is active in `~/.vimrc`.

- **Package Directory**: [`~/.vim/pack/plugins/start/`](file:///home/bob/.vim/pack/plugins/start/)
- **Configuration File**: [`~/.vimrc`](file:///home/bob/.vimrc)
- **Vim Version**: Vim 9.2 (Huge version)

### Files in this repository

| Repo file | Installs to | Purpose |
| :--- | :--- | :--- |
| `vimrc` | `~/.vimrc` | Main Vim configuration |
| `clangd-config.yaml` | `~/.config/clangd/config.yaml` | Global clangd defaults (see [§4](#4-c-setup-clangd-and-bazel)) |
| `bazel-compdb` | `~/.local/bin/bazel-compdb` | Generates `compile_commands.json` from Bazel (see [§4](#4-c-setup-clangd-and-bazel)) |

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
let g:rustfmt_autosave = 1        " Automatically run rustfmt on buffer save (:w)
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
| `rust-analyzer` | `~/.cargo/bin/rust-analyzer` (via `rustup component add rust-analyzer`) | Semantic code analysis, autocompletion, type inference for Rust |
| `clangd` | `/usr/bin/clangd` (Fedora package `clang-tools-extra`) | Same, for C and C++ |
| `gcc` / `g++` | `/usr/bin/gcc`, `/usr/bin/g++` | Queried by clangd via `--query-driver` for the real system include paths |
| `bazel` | `~/.local/bin/bazel` | Supplies the compile flags clangd needs, via `bazel-compdb` |

The plugin reads `g:lsp_servers` and `g:lsp_options` automatically when it loads
(`plugin/lsp.vim` calls `LspAddServer()` / `LspOptionsSet()` for you), so these
must be set in `~/.vimrc` *before* the package loads — which is the normal case,
since the vimrc is sourced before `pack/*/start` plugins.

#### Configurations in `.vimrc`
```vim
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
    \   autoComplete: v:true,           " Automatically trigger completion popup menu as you type
    \   autoHighlightDiags: v:true,     " Highlight diagnostic issues in buffer
    \   showDiagWithSign: v:true,       " Show warning/error signs in the sign column
    \   showInlayHints: v:true,         " Display inline type hints
    \   showSignature: v:true           " Show function signature helper
    \ }
```

Notes on the clangd entry:

- **`--query-driver`** lets clangd run the real `gcc`/`g++` to discover its
  system header paths. Without it clangd guesses, which drifts from what Bazel
  actually compiles with (Bazel builds here use gcc, not clang).
- **`rootSearch`** decides which directory clangd treats as the project root.
  The nearest match to the current buffer wins, so a nested Bazel workspace
  (e.g. `practice/cpplings/`, which sits inside a larger git repo) is correctly
  rooted at its own `MODULE.bazel` rather than at the outer `.git/`.
- **`--header-insertion=never`** stops clangd auto-adding `#include` lines on
  completion; under Bazel those are usually wrong, since the header must also be
  added to the target's `deps`.

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

Useful plugin commands not bound to a key: `:LspServer restart` (reload a
language server), `:LspServer show` (status), `:LspDiagShow` (all diagnostics for
the buffer in a location list). Note the subcommand form — there is no
`:LspServerRestart`.

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

## 4. C++ setup: clangd and Bazel

C++ needs one extra piece of setup that Rust does not. `rust-analyzer` discovers
everything it needs from `Cargo.toml`, but **clangd has no build system of its
own**: it reads a `compile_commands.json` ("compilation database") listing the
exact compiler invocation for each source file. Without one it falls back to
compiling each file as a bare `clang <file>`, which causes two specific failures:

1. **C++20 code is flagged as errors.** On Fedora, clang defaults to **C++17**
   while gcc defaults to **C++20** (`__cplusplus` is `201703L` vs `202002L`). So
   `std::popcount`, `std::format`, ranges and concepts all report errors in the
   editor even though `bazel build` of the same file succeeds.
2. **Third-party headers are "file not found".** With no compile command there
   are no `-I` flags at all, so `#include <gtest/gtest.h>` (or Eigen, CLI11,
   benchmark) cannot resolve.

The three steps below fix both.

### Step 1 — Install clangd

```bash
sudo dnf install clang-tools-extra
```

### Step 2 — Install the global clangd config

This pins C++20 for any file that *no* build system knows about — a scratch
file, or a new source not yet added to a BUILD target. Files covered by a
`compile_commands.json` take their standard from there instead.

```bash
mkdir -p ~/.config/clangd
cp clangd-config.yaml ~/.config/clangd/config.yaml
```

The `If: PathMatch:` guard in that file restricts `-std=c++20` to C++ sources and
headers, so plain `.c` files are still compiled as C.

### Step 3 — Install `bazel-compdb`

```bash
install -m 755 bazel-compdb ~/.local/bin/bazel-compdb
```

`~/.local/bin` must be on `PATH` (it already is via `bashrc`). Requires `python3`
and `bazel`.

### Generating the database per workspace

Run once in each Bazel workspace, and again after adding a BUILD target, a new
source file, or a new external dependency:

```bash
cd ~/code/practice/cpplings && bazel-compdb        # defaults to //...
bazel-compdb //some/package/...                    # or narrow the target pattern
```

From inside Vim, `:BazelCompDB` does the same for the workspace containing the
current file and then restarts clangd so it picks up the new flags:

```vim
:BazelCompDB
:BazelCompDB //some/package/...
```

Add the generated file to the workspace's `.gitignore` — it contains absolute
machine-specific paths and should never be committed:

```
compile_commands.json
```

### Why a custom script rather than the usual tool

The common tool for this,
[`hedronvision/bazel-compile-commands-extractor`](https://github.com/hedronvision/bazel-compile-commands-extractor),
**does not work on Bazel 9** (in use here, 9.2.0): it calls `native.py_binary`,
which Bazel 9 removed, and fails with `Error: no native function or rule
'py_binary'`. It can be forced to run by adding `rules_python` and
`--incompatible_autoload_externally=+@rules_python`, but that means editing every
workspace's `MODULE.bazel`.

`bazel-compdb` instead derives the same information from `bazel aquery
'mnemonic("CppCompile", //...)' --output=jsonproto`, which needs **no changes to
any workspace** and no third-party Bazel dependency.

One deliberate detail: it writes the `"directory"` field as Bazel's *execution
root*, not the workspace root. Bazel's compile actions reference paths relative
to the execution root (`external/googletest+/...`, `bazel-out/...`), which
normally resolve through the `bazel-out` / `external` convenience symlinks — and
a workspace that sets `--symlink_prefix=/` (as `practice/cpplings` deliberately
does, to keep pytest and pyrefly from collecting Bazel output) has no such
symlinks. Pointing at the execution root resolves those paths without putting
build output back into the source tree.

### Non-Bazel C++ projects

clangd finds a database by the same `rootSearch` walk, so either works:

- **CMake**: configure with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` and symlink the
  generated `build/compile_commands.json` to the project root.
- **Plain / single-file**: drop a `compile_flags.txt` at the project root, one
  flag per line (e.g. `-std=c++20`, `-I./include`).

### Troubleshooting

| Symptom | Check |
| :--- | :--- |
| C++20 names flagged as errors | Is there a `compile_commands.json`? Run `:BazelCompDB`. |
| Third-party header "file not found" | Same — and confirm the file's target actually lists the dep in its BUILD file. |
| Nothing works, no diagnostics at all | `:LspServer show` for status; `:LspServer debug errors` for the server's stderr. |
| Verify outside Vim | `clangd --check=path/to/file.cpp` prints the exact command it chose and every diagnostic. |

---

## 5. Maintenance & Updates

To update all installed plugins to their latest versions, run:
```bash
# Update rust.vim
cd ~/.vim/pack/plugins/start/rust.vim && git pull

# Update yegappan/lsp
cd ~/.vim/pack/plugins/start/lsp && git pull
```

To re-sync this repository's copies after editing the live files:
```bash
cd ~/code/configs
cp ~/.vimrc vimrc
cp ~/.config/clangd/config.yaml clangd-config.yaml
cp ~/.local/bin/bazel-compdb bazel-compdb
```

To add another language or plugin in the future:
1. Clone the git repository into `~/.vim/pack/plugins/start/<plugin-name>`.
2. If it's a language server, add its configuration to `g:lsp_servers` in `~/.vimrc`.
3. If that server needs project metadata to find its flags (as clangd does), add
   the file that marks the project root to the server's `rootSearch` list.
