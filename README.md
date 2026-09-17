![lazyvimx](https://raw.githubusercontent.com/lazyvimx/nvim/assets/banner.jpeg)

<div align="center">

[![Release](https://img.shields.io/github/v/release/lazyvimx/nvim?style=flat-square)](https://github.com/lazyvimx/nvim/releases)
[![License](https://img.shields.io/github/license/lazyvimx/nvim?style=flat-square)](https://github.com/lazyvimx/nvim/blob/main/LICENSE)
[![Stars](https://img.shields.io/github/stars/lazyvimx/nvim?style=flat-square)](https://github.com/lazyvimx/nvim/stargazers)
![Neovim](https://img.shields.io/badge/Neovim-0.10+-green?style=flat-square)
![Extras](https://img.shields.io/badge/extras-50-purple?style=flat-square)

## [📖 Documentation: lazyvimx.aimuzov.online](https://lazyvimx.aimuzov.online/)

</div>

> [!TIP]
> **🇷🇺 Русская версия:** [README.ru.md](README.ru.md)

**An enhancement layer on top of [LazyVim](https://github.com/LazyVim/LazyVim): 50 optional
extras and 39 plugin overrides.**

The idea is simple: LazyVim stays untouched, and everything else — UI polish, navigation,
git workflow, Russian keyboard support — is enabled piece by piece. Don't like an extra?
Don't enable it, and it's like it doesn't exist.

## 📑 Table of Contents

- [Features](#✨-features) · [Installation](#📦-installation) · [Structure](#🗂️-project-structure) · [Core Modules](#🎯-core-modules)
- [Documentation](#📚-documentation) · [Highlighted Extras](#🎨-highlighted-extras) · [Keymaps](#⌨️-keymaps) · [Configuration](#🔧-configuration)
- [Integrations](#🤝-integrations) · [Philosophy](#🌟-philosophy) · [Stats](#📊-stats) · [Links](#🔗-links)

## ✨ Features

### 🎨 Interface

- **Deep theme customization** — Catppuccin, Tokyo Night, and Nord
- **Automatic light/dark switching** following the system theme ([macOS](https://github.com/aimuzov/dotfiles/tree/main/private_Library/ThemeSwitcher))
- **Consistent UI style** — rounded borders, aligned window sizes, custom icons
- **Enhanced dashboard** with ASCII art and animation
- **Symbol usage counters** inline in code, JetBrains-style
- **Single-line diagnostics** at the cursor

### 🚀 Productivity

- **Smart buffers** — bufferline groups, auto-cleanup, per-tab isolation
- **Syntax-tree navigation** — moving and swapping nodes
- **Subword motions** — `w`/`e`/`b` understand camelCase
- **Git workflow** — GitLab MR review inside the editor, conflict resolution, browsing remote repositories
- **JS/TS debugging** via js-debug-adapter

### ⚙️ Quality of life

- **Russian keyboard layout** via langmapper — no switching to English
- **Safe editing on sshfs mounts** — in-place writes, no broken permissions or symlinks
- **Auto-sync to chezmoi** on plugin updates
- **Per-project local configs** (`.nvim.lua`)
- **VSCode mode** for a hybrid workflow
- **Automatic Mason package updates**

## 📦 Installation

### Prerequisites

- Neovim >= 0.10.0
- Lua 5.1 or LuaJIT in `PATH` (`brew install luajit`) — required by
  `motions.better-move-between-words`: [luarocks.nvim](https://github.com/vhyrro/luarocks.nvim)
  builds the `luautf8` rock for non-ASCII subword motions and fails without a system Lua

### 🚀 Choose Your Setup

**New to lazyvimx?** Ready-to-use configurations live in [examples/](examples/):

- **[Minimal](examples/minimal/)** — overrides only, the fastest start
- **[Full-Featured](examples/full-featured/)** — all 50 extras
- **[VSCode User](examples/vscode-user/)** — for the VSCode Neovim extension
- **[Russian Keyboard](examples/russian-keyboard/)** — with Russian layout support

### Quick Start

> **💡 Real-world example**: the [author's configuration](https://github.com/aimuzov/dotfiles/blob/main/dot_config/nvim/init.lua).

1. **Create `~/.config/nvim/init.lua`:**

```lua
local lazy_opts = {
	spec = { { "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" } },

	install = { colorscheme = { "catppuccin", "tokyonight" } },
	checker = { enabled = true, notify = false },
	change_detection = { enabled = false },
	diff = { cmd = "diffview.nvim" },

	ui = {
		backdrop = 100,
		border = "rounded",
		icons = { keys = "󰥻" },
	},
}

-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_url = "https://github.com/folke/lazy.nvim.git"

if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_url, lazy_path })
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup(lazy_opts)
```

2. **Start Neovim:**

```bash
nvim
```

On first launch lazyvimx installs LazyVim and all required plugins by itself.

3. **Configure lazyvimx (optional):**

**Option A** — `opts` right in `init.lua`:

```lua
local lazy_opts = {
  spec = {
    {
      "lazyvimx/nvim",
      name = "lazyvimx",
      import = "lazyvimx.boot",
      opts = {
        colorscheme = "catppuccin",
        bufferline_groups = {
          -- ["group name"] = "lua-pattern",
        },
      },
    },
  },
  -- ... other settings
}
```

**Option B** — a separate file `~/.config/nvim/lua/plugins/lazyvimx.lua`:

```lua
return {
  "lazyvimx/nvim",
  name = "lazyvimx",
  opts = {
    colorscheme = "catppuccin",
    bufferline_groups = {
      -- ["group name"] = "lua-pattern",
    },
  },
}
```

All options, including light/dark theme variants (`colorscheme_households`), are covered in
[Configuration](docs/CONFIGURATION.md).

4. **Enable extras:**

Via the `:LazyExtras` UI (recommended) or imports in your config:

```lua
-- lua/plugins/extras.lua
return {
  -- All plugin overrides
  { import = "lazyvimx.extras.core.overrides" },
  -- Then whatever you need
  { import = "lazyvimx.extras.ui.better-diagnostic" },
  { import = "lazyvimx.extras.motions.langmapper" },
}
```

## 🗂️ Project Structure

```
lazyvimx/
├── lua/lazyvimx/
│   ├── boot.lua              # Bootstrap configuration
│   ├── init.lua              # Main module with setup()
│   ├── extras/               # Optional modules (50 + 5 core)
│   │   ├── core/             # Bundles: all, overrides, extras, keys, colorschemes
│   │   ├── ui/               # Interface (21)
│   │   ├── motions/          # Navigation (6)
│   │   ├── buf/              # Buffers (4)
│   │   ├── git/              # Git (4)
│   │   ├── lang/             # Languages (4)
│   │   ├── perf/             # Performance (4)
│   │   ├── coding/           # Coding tools (2)
│   │   ├── linting/          # Linters (2)
│   │   ├── colorschemes/     # Colorschemes (1)
│   │   ├── dap/              # Debugging (1)
│   │   └── test/             # Testing (1)
│   ├── overrides/            # Plugin customizations (39)
│   │   ├── lazyvim/          # LazyVim (9)
│   │   ├── snacks/           # Snacks.nvim (9)
│   │   ├── bufferline/       # Bufferline (6)
│   │   └── other/            # Other plugins (15)
│   └── util/                 # Utilities
│       ├── general.lua       # General (colors, system theme, extras checks)
│       └── layout.lua        # Sidebar and panel sizes
└── init.lua                  # Guard against using the repo directly
```

## 🎯 Core Modules

### Recommended Setup

Enable everything at once — `core.all` via `:LazyExtras` or an import:

```lua
{ import = "lazyvimx.extras.core.all" }
```

Inside:

- **overrides** — all 39 plugin customizations
- **extras** — all feature extras
- **colorschemes** — additional colorschemes
- **keys** — custom keymaps
- plus a notification if recommended LazyVim extras are missing

### Individually

```lua
{ import = "lazyvimx.extras.core.overrides" }     -- Plugin overrides
{ import = "lazyvimx.extras.core.extras" }        -- All extras
{ import = "lazyvimx.extras.core.keys" }          -- Keymaps
{ import = "lazyvimx.extras.core.colorschemes" }  -- Colorschemes
```

## 📚 Documentation

- **[EXTRAS.md](docs/EXTRAS.md)** — reference for all 50 extras ([🇷🇺](docs/EXTRAS.ru.md))
- **[CONFIGURATION.md](docs/CONFIGURATION.md)** — configuration and options ([🇷🇺](docs/CONFIGURATION.ru.md))
- **[KEYBINDINGS.md](docs/KEYBINDINGS.md)** — all keymaps ([🇷🇺](docs/KEYBINDINGS.ru.md))
- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** — how it all works ([🇷🇺](docs/ARCHITECTURE.ru.md))
- **[API.md](docs/API.md)** — utilities and functions ([🇷🇺](docs/API.ru.md))
- **[FAQ.md](docs/FAQ.md)** — frequently asked questions ([🇷🇺](docs/FAQ.ru.md))
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** — problem solving ([🇷🇺](docs/TROUBLESHOOTING.ru.md))

## 🎨 Highlighted Extras

### Interface

- `ui.better-diagnostic` — single-line diagnostics at the cursor
- `ui.better-float` — consistent floating window style
- `ui.symbol-usage` — symbol usage counters
- `ui.better-explorer` — the Yazi file manager
- `ui.winbar` — file path above the window

### Navigation

- `motions.langmapper` — **Russian layout without switching**
- `motions.better-move-between-words` — subword motions (needs Lua 5.1/LuaJIT in `PATH`, see Prerequisites)
- `motions.sibling-swap` — swapping tree-sitter nodes
- `motions.splitting-joining-blocks` — splitting/joining code blocks

### Git

- `git.gitlab` — GitLab MR review inside the editor
- `git.conflicts` — visual conflict resolution
- `git.remote-view` — opening remote repositories locally

### More

- `buf.remote-mounts` — safe editing over sshfs
- `coding.comments` — context-aware commenting and JSDoc generation
- `test.jest` — Jest in Neotest

## ⌨️ Keymaps

lazyvimx adds 60+ custom keymaps. The most used ones:

**Every day**:

- `<leader><space>` — find files (smart)
- `<leader>cr` — LSP rename with live preview
- `gr` — references in a peek window
- `H` / `L` — previous/next buffer
- `<leader>fy` — the Yazi file manager
- `w` / `b` / `e` — subword motions

**Productivity**:

- `d` — delete without clobbering the register
- `<C-S-j>` / `<C-S-k>` — move lines
- `<C-,>` / `<C-.>` — swap parameters and array elements
- `<leader>ct` — split/join a code block
- `gx` / `gX` — open a remote git repository

**Git & GitLab**:

- `<leader>gL*` — the whole GitLab MR workflow (review, comments, approve, merge)
- `go` — open a file or selection in GitHub/GitLab

**📖 Full list**: [Keybindings](docs/KEYBINDINGS.md) — with descriptions and the extra
each keymap requires.

## 🔧 Configuration

### Colorschemes

lazyvimx switches between light and dark theme variants following the system:

```lua
require("lazyvimx").setup({
	colorscheme = "catppuccin",
})
```

Variants are grouped into "households" (`colorscheme_households`): each theme gets a list of
dark and a list of light variants. Catppuccin, Tokyo Night, and Nord are configured out of
the box; a dark system picks a dark variant, a light one picks light. Details and format —
in [Configuration](docs/CONFIGURATION.md#🎨-colorschemes).

### Buffer Groups

Custom bufferline groups:

```lua
require("lazyvimx").setup({
	bufferline_groups = {
		["React"] = "%.tsx$",
		["Tests"] = "%.test%.",
	},
})
```

## 🤝 Integrations

### Chezmoi

After a plugin update lazyvimx adds `lazy-lock.json` and `lazyvim.json` to chezmoi — as long
as the `chezmoi` binary is installed.

### VSCode

A mode for the VSCode Neovim extension:

- mode indicator synced to the status bar
- adjusted keymaps
- rename via native VSCode

### macOS

- system theme detection for automatic colorscheme switching
- deleting files to the trash in neo-tree

## 🌟 Philosophy

1. **Don't break LazyVim** — every enhancement is optional and enabled via extras
2. **One style** — a shared theme and visual language across all plugins
3. **Smart defaults** — works out of the box, configurable when desired
4. **Attention to detail** — from window borders to cursor behavior

## 📊 Stats

- **50 optional extras** across 11 categories
- **39 overrides** for deep customization
- **Hundreds of custom highlights** for Catppuccin, Tokyo Night, and Nord
- **60+ custom keymaps**

## 🔗 Links

- [Usage Example](https://github.com/aimuzov/dotfiles/blob/main/dot_config/nvim/init.lua)
- [Discussion](https://t.me/aimuzov_dotfiles)
- [LazyVim](https://github.com/LazyVim/LazyVim)

## 📈 Activity

![Repo Activity](https://repobeats.axiom.co/api/embed/f5453bcfc3ad93005a4d3b73d0681450ff7ca5d3.svg "Repobeats analytics image")

## 🤝 Contributing

Bugs and ideas go to [issues](https://github.com/lazyvimx/nvim/issues). How the project
works and how to write your own extra — in [Contributing](CONTRIBUTING.md).

## 📄 License

Same license as LazyVim.

## 🙏 Credits

Built on top of the excellent [LazyVim](https://github.com/LazyVim/LazyVim) by
[folke](https://github.com/folke).

---

**Author**: Aleksey Imuzov ([@aimuzov](https://github.com/aimuzov))
