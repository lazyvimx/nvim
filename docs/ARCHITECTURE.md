# Architecture

> [!TIP]
> **🇷🇺 Русская версия:** [ARCHITECTURE.ru.md](ARCHITECTURE.ru.md)

How lazyvimx works on the inside.

## 📑 Table of Contents

- [Overview](#🔭-overview)
- [Bootstrap Process](#🚀-bootstrap-process)
- [Configuration System](#⚙️-configuration-system)
- [Extras System](#🧩-extras-system)
- [Overrides System](#🔧-overrides-system)
- [Utilities](#🧰-utilities)
- [Integration Points](#🔗-integration-points)

## 🔭 Overview

lazyvimx is a layer on top of LazyVim, not a fork: nothing in LazyVim gets replaced, every
enhancement is plugged in through lazy.nvim's standard machinery (specs, `import`,
`optional`, `cond`).

### Principles

1. **Don't interfere** — LazyVim works as usual, everything extra is optional
2. **Modularity** — one feature = one file
3. **Extensibility** — your own plugins and overrides plug in alongside
4. **Lightness** — lazy loading, conditional activation
5. **Friendly to the environment** — chezmoi, VSCode, the system theme

### Three Kinds of Modules

| Kind          | Where                     | What it is                                                     |
| ------------- | ------------------------- | --------------------------------------------------------------- |
| **Extras**    | `lua/lazyvimx/extras/`    | Optional features; enabled explicitly (`:LazyExtras` / import) |
| **Overrides** | `lua/lazyvimx/overrides/` | Tweaks to existing plugin settings; enabled in bundles         |
| **Utilities** | `lua/lazyvimx/util/`      | Shared functions for extras, overrides, and user configs       |

## 🚀 Bootstrap Process

### Guard Against Direct Use

The `init.lua` at the repository root configures nothing — it only warns if the repository
is mistakenly used as a standalone Neovim config.

### boot.lua

The entry point is `{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" }`. The module returns a
sequence of specs:

```lua
return {
	{ import = "system.plug", enabled = set_global },            -- 1
	{ import = "system.plug", enabled = vimopts_create_autocmd }, -- 2

	{ "LazyVim/LazyVim", branch = "main" },                       -- 3
	{ "LazyVim/LazyVim", opts = update_root_lsp_ignore },         -- 4
	{ "LazyVim/LazyVim", opts = insert_extras },                  -- 5
	{ "LazyVim/LazyVim", import = "lazyvim.plugins" },            -- 6
	{ "LazyVim/LazyVim", opts = set_colorscheme },                -- 7

	{ "lazyvimx/nvim", name = "lazyvimx", dependencies = { "LazyVim/LazyVim" }, vscode = true, config = true }, -- 8

	{ import = "plugins", enabled = has_plugins_dir },            -- 9
}
```

The `system.plug` specs are a trick: a non-existent plugin with a function in `enabled` runs
a side effect during spec parsing, before anything loads.

1. **Globals**: `lazyvim_check_order = false`, `xtras_prios = {}`,
   `lazyvim_explorer = "neo-tree"`
2. **Vim options**: a subscription to `LazyVimOptionsDefaults` — the values apply once
   LazyVim sets its defaults (tab indentation of 4, `backup` instead of swap,
   `winblend`/`pumblend`, timeouts, etc.)
3. LazyVim is pinned to the `main` branch
4. `eslint` is added to `root_lsp_ignore` (doesn't affect project root detection)
5. **Extras registration**: the lazyvimx section (the 󰬟 icon) appears in `:LazyExtras`
6. LazyVim's plugins load
7. **Colorscheme**: the variant for the current system theme is picked (`get_flavor()`)
8. lazyvimx itself: `config = true` calls `require("lazyvimx").setup(opts)` with the spec's
   options
9. The user's `lua/plugins/*.lua`, if the directory is non-empty

## ⚙️ Configuration System

### Data Flow

1. Defaults are declared in `lua/lazyvimx/init.lua`
2. User options arrive from the spec's `opts` (or a direct `setup()` call)
3. `vim.tbl_deep_extend("force", defaults, opts)` — a deep merge
4. The result is available to every module: `require("lazyvimx").config`

### Options

- `colorscheme` — the default colorscheme household
- `colorscheme_households` — households: lists of dark and light variants
- `bufferline_groups` — user buffer groups

Format and defaults — in [Configuration](CONFIGURATION.md#⚙️-the-setup-function).

### Picking the Colorscheme Variant

`util/general.lua`, the `get_flavor()` function:

```lua
function M.get_flavor(colorscheme_household_last)
	local config = require("lazyvimx").config
	local flavor_index = M.theme_is_dark() and 1 or 2 -- [1] dark, [2] light

	-- with last-color.nvim present, try restoring the last variant
	-- (only within the list matching the current system theme)

	local flavor_list = config.colorscheme_households[colorscheme_household_last or config.colorscheme]
	return flavor_list[flavor_index][1]
end
```

The household is derived from the theme name's prefix up to the first hyphen:
`catppuccin-latte` → `catppuccin`, `nord-light` → `nord`.

## 🧩 Extras System

### Structure

```
extras/
├── core/          # Bundles (5): all, colorschemes, extras, keys, overrides
├── ui/            # Interface (21)
├── motions/       # Navigation (6)
├── buf/           # Buffers (4)
├── git/           # Git (4)
├── lang/          # Languages (4)
├── perf/          # Performance (4)
├── coding/        # Coding tools (2)
├── linting/       # Linters (2)
├── colorschemes/  # Colorschemes (1)
├── dap/           # Debugging (1)
└── test/          # Testing (1)
```

50 feature extras; descriptions are in [Extras](EXTRAS.md).

### Extra Template

Each extra is a module returning a lazy.nvim spec. The `desc` field shows up in
`:LazyExtras`:

```lua
return {
	"author/plugin.nvim",
	desc = "What the extra does",
	opts = { ... },
}
```

### Core Bundles

- `core.all` — imports the other four plus a notification about recommended LazyVim extras
- `core.extras` — the registry of every feature extra (49 imports;
  `ui.better-progressbar` — behind a `TERM=xterm-ghostty` condition)
- `core.overrides` — all 4 override categories
- `core.colorschemes` — additional colorschemes
- `core.keys` — keymaps bound to plugins (`optional = true`: no plugin — no keymap)

### Conditional Activation

Extras with external dependencies activate via `cond` and warn via `warn_missing_extra()`:

```lua
-- dap/vscode-js.lua
cond = function()
	return not vim.g.vscode and LazyVim.has_extra("dap.core")
end
```

Some modules disable themselves entirely: `ui.simple-mode` and the VSCode override return
`{}` when their condition doesn't hold.

## 🔧 Overrides System

Overrides change the settings of existing plugins without replacing them. Every spec is
`optional = true`: if the plugin isn't there, the override does nothing.

### Structure

```
overrides/
├── lazyvim/     # LazyVim (9): language specifics (clangd, oxc, svelte), chezmoi,
│                #   theme auto-switching, VSCode, pretty path, the context menu
├── snacks/      # Snacks.nvim (9): the dashboard, lazygit (theme, follow worktree),
│                #   disabled animations and backdrop, repeatable buffer deletion
├── bufferline/  # Bufferline (6): groups, repeatable moves, tab styling
└── other/       # Other (15): avante, blink, catppuccin, dap-ui, edgy, flash, gitsigns,
                 #   lazy, lspconfig, lualine, neo-tree, noice, sidekick, tokyonight, trouble
```

39 modules total. A category is imported as a whole — lazy.nvim picks up every `.lua` file
in the directory:

```lua
{ import = "lazyvimx.overrides.snacks" }
```

### Common Patterns

**Extending opts** — the most frequent:

```lua
return {
	"plugin/name",
	optional = true,
	opts = { option = value },
}
```

**Replacing a function** — when opts aren't enough:

```lua
-- overrides/lazyvim/lualine-pretty-path.lua
opts = function()
	LazyVim.lualine.pretty_path = function(opts) --[[ custom implementation ]] end
end
```

**Autocmd** — reacting to events:

```lua
-- overrides/lazyvim/auto-switch-colorscheme-on-signal.lua
vim.api.nvim_create_autocmd("Signal", {
	callback = vim.schedule_wrap(colorscheme_update),
})
```

**Wrapping** — changing behavior while keeping the original:

```lua
-- extras/motions/langmapper.lua
local normkey_orig = Snacks.util.normkey
Snacks.util.normkey = function(key)
	return normkey_orig(translate_key(key, "default", "ru"))
end
```

## 🧰 Utilities

### util/general.lua

Color blending, system theme detection, colorscheme variant selection, extras checks. The
full reference is in [API](API.md#🧰-utilgeneral).

### util/layout.lua

The single source of panel sizes (left — 40, right — 80, top/bottom — 10, resize step — 3).
Used by edgy (sizes and resize keymaps) and diffview (the file and history panels) — which
keeps the sidebars consistent. Reference — in [API](API.md#🪟-utillayout).

## 🔗 Integration Points

### LazyVim

- extras registration in `:LazyExtras`
- use of `LazyVim.*` utilities (`has_extra`, `root`, `lualine.pretty_path`, `pick`)
- extending LazyVim's options through specs

### lazy.nvim

- everything plugs in through specs and `import`
- `optional = true` — degradation without errors
- `cond` / `enabled` — conditional loading

### External Tools

- **chezmoi** — `chezmoi add` for the lock files after `:Lazy update`
- **VSCode** — a mode for vscode-neovim (the mode indicator, adjusted keymaps)
- **The system** — the OS theme (macOS `defaults` / Linux `gsettings`), signals for theme
  switching, `trash` and `open` in neo-tree

## ⚡ Performance

- extras that aren't enabled don't exist as code: the registry is just an `import` list
- almost every plugin is lazy: events (`VeryLazy`, `BufReadPre`), commands, keymaps
- the `perf.*` extras add housekeeping: stopping inactive LSPs, closing old buffers

## 🧱 Extending

### Your Own Extra

A file in the appropriate category:

```lua
-- lua/lazyvimx/extras/<category>/<name>.lua
return {
	"author/plugin.nvim",
	desc = "A description for :LazyExtras",
	opts = { ... },
}
```

And a line in the `extras/core/extras.lua` registry:

```lua
{ import = "lazyvimx.extras.<category>.<name>" },
```

### Your Own Override

A file in an `overrides/` category — picked up automatically when the category is imported:

```lua
-- lua/lazyvimx/overrides/other/my-override.lua
return {
	"plugin/name",
	optional = true,
	opts = { ... },
}
```

## 🐞 Debugging

```vim
" Loaded spec modules
:lua vim.print(require("lazy.core.config").spec.modules)

" The current lazyvimx config
:lua vim.print(require("lazyvimx").config)

" Load profiling
:Lazy profile
```
