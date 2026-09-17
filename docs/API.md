# API Reference

> [!TIP]
> **🇷🇺 Русская версия:** [API.ru.md](API.ru.md)

lazyvimx utilities and modules you can use in your own configuration.

## 📑 Table of Contents

- [Main Module](#📦-main-module)
- [util.general](#🧰-utilgeneral)
- [util.layout](#🪟-utillayout)
- [boot.lua](#🚀-bootlua)

---

## 📦 Main Module

**Module:** `lazyvimx` (`lua/lazyvimx/init.lua`)

### `setup(opts)`

Merge user options with the defaults.

```lua
require("lazyvimx").setup({
	colorscheme = "tokyonight",
	bufferline_groups = {
		["React"] = "%.tsx$",
	},
})
```

The options schema and defaults are in
[Configuration](CONFIGURATION.md#⚙️-the-setup-function). You usually don't call `setup()`
yourself: options from the `"lazyvimx"` plugin spec end up here automatically (the
spec in `boot.lua` has `config = true`).

### `config`

The current configuration (after the merge).

```lua
local config = require("lazyvimx").config
print(config.colorscheme) -- "catppuccin"
```

---

## 🧰 util.general

**Module:** `lazyvimx.util.general` (`lua/lazyvimx/util/general.lua`)

### `color_blend(color_first, color_second, percentage)`

Blend two hex colors in a given proportion.

```lua
function M.color_blend(color_first: string, color_second: string, percentage: number): string
```

- `color_first`, `color_second` — colors like `"#RRGGBB"`
- `percentage` — the share of the second color, 0–100

```lua
local util = require("lazyvimx.util.general")

util.color_blend("#FF0000", "#0000FF", 50) -- "#7F007F"
util.color_blend("#FF0000", "#FFFFFF", 25) -- a slightly lighter red
```

The main tool for highlight customization — used heavily in the theme overrides.

### `popen_get_result(cmd)`

Run a shell command and return its output as a single line (no trailing whitespace or
newlines). An empty string on failure.

```lua
function M.popen_get_result(cmd: string): string
```

```lua
util.popen_get_result("echo hello") -- "hello"
```

### `theme_is_dark()`

Whether the system theme is dark.

```lua
function M.theme_is_dark(): boolean
```

- **macOS:** `defaults read -g AppleInterfaceStyle`
- **Linux:** `gsettings get org.gnome.desktop.interface gtk-theme`, falling back to
  `color-scheme`

### `get_flavor(colorscheme_household_last?)`

The colorscheme variant for the current system theme.

```lua
function M.get_flavor(colorscheme_household_last?: string): string
```

- `colorscheme_household_last` — the household name; defaults to `config.colorscheme`

**Logic:**

1. `theme_is_dark()` picks the list: `[1]` — dark, `[2]` — light
2. If `last-color.nvim` is installed (the `perf.restore-last-colorscheme` extra) and the
   last used variant is in that list — it's returned
3. Otherwise — the first variant of the list

```lua
-- In dark mode with default settings:
util.get_flavor("catppuccin") -- "catppuccin-macchiato"
```

### `get_dotfiles_path()`

The value of the `DOTFILES_SRC_PATH` environment variable, or an empty string. A helper for
user configs; lazyvimx itself doesn't use it at the moment.

```lua
function M.get_dotfiles_path(): string
```

### `has_extra(extra)`

Whether a lazyvimx extra is enabled.

```lua
function M.has_extra(extra: string): boolean
```

- `extra` — the name without the prefix: `"ui.winbar"`, `"git.gitlab"`

Checks both loaded lazy.nvim modules and the extras list in `lazyvim.json`.

```lua
if util.has_extra("ui.winbar") then
	-- configure the integration
end
```

For LazyVim's own extras there's the analogous `LazyVim.has_extra("ui.edgy")`.

### `warn_missing_extra(extra_name)`

A callback factory: show a warning if an extra is not enabled. Used by extras with
dependencies (e.g. `git.gitlab` warns about `ui.diff-view`).

```lua
function M.warn_missing_extra(extra_name: string): function
```

```lua
{
	"folke/snacks.nvim",
	opts = require("lazyvimx.util.general").warn_missing_extra("ui.diff-view"),
}
```

---

## 🪟 util.layout

**Module:** `lazyvimx.util.layout` (`lua/lazyvimx/util/layout.lua`)

A single source of sidebar and panel sizes: edgy, diffview, and other plugins take their
sizes from here, so panels stay consistent, and resizing one is remembered for all.

**Internal state:**

```lua
local size = {
	left = 40,
	right = 80,
	top = 10,
	bottom = 10,
}

M.step = 3 -- resize step
```

### `get_size(pos)`

The current size for a position.

```lua
function M.get_size(pos: "left"|"right"|"top"|"bottom"): number
```

```lua
local layout = require("lazyvimx.util.layout")

layout.get_size("left")   -- 40
layout.get_size("bottom") -- 10
```

### `get_size_create(pos)`

The same, but returns a function — for plugins that accept a size callback (edgy):

```lua
{
	"folke/edgy.nvim",
	opts = {
		left = { size = layout.get_size_create("left") },
	},
}
```

### `increase_create(dir)` / `decrease_create(dir)`

Factories of edgy-window resize functions that step by `M.step` and remember the new size.

```lua
function M.increase_create(dir: "width"|"height"): function
function M.decrease_create(dir: "width"|"height"): function
```

This is how the `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>` keymaps in `core.keys` are
built:

```lua
opts.keys = {
	["<c-Up>"] = layout.increase_create("height"),
	["<c-Down>"] = layout.decrease_create("height"),
	["<c-Left>"] = layout.decrease_create("width"),
	["<c-Right>"] = layout.increase_create("width"),
}
```

---

## 🚀 boot.lua

**Module:** `lazyvimx.boot` (`lua/lazyvimx/boot.lua`)

The entry point: `{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" }`. Internal functions, not
called directly:

| Function                   | What it does                                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------------------------ |
| `set_global()`             | `vim.g.lazyvim_check_order = false`, `vim.g.xtras_prios = {}`, `vim.g.lazyvim_explorer = "neo-tree"`  |
| `vimopts_create_autocmd()` | subscribes to `LazyVimOptionsDefaults` to set Vim options                                             |
| `update_root_lsp_ignore()` | adds `eslint` to `vim.g.root_lsp_ignore`                                                              |
| `insert_extras()`          | registers the lazyvimx extras source (the 󰬟 icon) in the `:LazyExtras` UI                             |
| `set_colorscheme()`        | sets the colorscheme via `get_flavor()`                                                               |
| `has_plugins_dir()`        | plugs in the user's `lua/plugins/*.lua` if present                                                    |

The spec order in `boot.lua` and the bootstrap process are described in
[Architecture](ARCHITECTURE.md#🚀-bootstrap-process).

---

## 📋 Summary

| Module         | Functions                                                                                                                             | Purpose         |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `lazyvimx`     | `setup()`, `config`                                                                                                                    | Configuration   |
| `util.general` | `color_blend()`, `popen_get_result()`, `theme_is_dark()`, `get_flavor()`, `get_dotfiles_path()`, `has_extra()`, `warn_missing_extra()` | General helpers |
| `util.layout`  | `get_size()`, `get_size_create()`, `increase_create()`, `decrease_create()`, `step`                                                    | Panel sizes     |

## 📚 See Also

- [Configuration](CONFIGURATION.md) — configuration
- [Architecture](ARCHITECTURE.md) — internals
- [Extras](EXTRAS.md) — the extras reference
