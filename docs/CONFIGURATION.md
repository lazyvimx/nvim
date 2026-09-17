# Configuration

> [!TIP]
> **🇷🇺 Русская версия:** [CONFIGURATION.ru.md](CONFIGURATION.ru.md)

The complete guide to configuring lazyvimx.

## 📑 Table of Contents

- [Quick Start](#🚀-quick-start)
- [The setup Function](#⚙️-the-setup-function)
- [Colorschemes](#🎨-colorschemes)
- [Buffer Groups](#🗂️-buffer-groups)
- [Enabling Extras](#🧩-enabling-extras)
- [Vim Options](#✍️-vim-options)
- [Integrations](#🔗-integrations)
- [Advanced Configuration](#🧠-advanced-configuration)

## 🚀 Quick Start

### Bare Minimum

```lua
-- lua/config/lazy.lua
return {
	spec = {
		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },
	},
}
```

lazyvimx with default settings; all extras are available via `:LazyExtras` but disabled.

### Recommended

```lua
-- lua/config/lazy.lua
return {
	spec = {
		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },
		{ import = "lazyvimx.extras.core.all" }, -- everything at once
	},
}
```

### Ways to Pass Options

**Way 1 — `opts` in the plugin spec (recommended):**

```lua
{
	"lazyvimx/nvim",
	name = "lazyvimx",
	import = "lazyvimx.boot",
	opts = {
		colorscheme = "catppuccin",
		bufferline_groups = {
			["React"] = "%.tsx$",
		},
	},
}
```

**Way 2 — calling `setup()`:**

```lua
-- lua/config/lazyvimx.lua
require("lazyvimx").setup({
	colorscheme = "catppuccin",
	bufferline_groups = {
		["React"] = "%.tsx$",
	},
})
```

Both are equivalent.

## ⚙️ The setup Function

Options are deep-merged with the defaults (`vim.tbl_deep_extend`).

### Configuration Schema

```lua
{
	-- The default colorscheme household name
	colorscheme = "catppuccin",

	-- Households: for each one — a list of dark and a list of light variants.
	-- The first item of each list is the default variant.
	colorscheme_households = {
		[household: string] = {
			{ dark_1, dark_2, ... },   -- [1] dark variants
			{ light_1, light_2, ... }, -- [2] light variants
		},
	},

	-- Custom buffer groups for bufferline
	bufferline_groups = {
		[group_name: string] = pattern, -- a lua pattern over the file path
	},
}
```

### Defaults

```lua
{
	colorscheme = "catppuccin",

	colorscheme_households = {
		catppuccin = {
			{
				"catppuccin-macchiato", "catppuccin-frappe", "catppuccin-mocha", "catppuccin",
				"catppuccin-darkroast", "catppuccin-draculatte", "catppuccin-espresso",
				"catppuccin-gruvbrew", "catppuccin-kanagato", "catppuccin-nightbrew",
				"catppuccin-nordiccino", "catppuccin-rosetto", "catppuccin-solarbica",
			},
			{ "catppuccin-latte" },
		},
		tokyonight = {
			{ "tokyonight-storm", "tokyonight-moon", "tokyonight-night" },
			{ "tokyonight-day" },
		},
		nord = {
			{ "nord" },
			{ "nord-light" },
		},
	},

	bufferline_groups = {},
}
```

The additional catppuccin variants (darkroast, nightbrew, etc.) come from
[catppuccin-barista](https://github.com/aimuzov/catppuccin-barista.nvim), which is pulled in
by the `overrides/other/catppuccin.lua` override.

## 🎨 Colorschemes

### How the Variant Is Picked

On startup (and on a signal from the system) lazyvimx detects the OS theme and picks a
variant from the household:

1. Dark system → list `[1]`, light → list `[2]`
2. If the `perf.restore-last-colorscheme` extra is enabled and the last used variant is in
   that list — it gets restored
3. Otherwise the first variant of the list is used

OS theme detection: on macOS — `defaults read -g AppleInterfaceStyle`, on Linux —
`gsettings` (gtk-theme or color-scheme).

### Your Own Household

```lua
require("lazyvimx").setup({
	colorscheme = "gruvbox",
	colorscheme_households = {
		gruvbox = {
			{ "gruvbox" },       -- dark
			{ "gruvbox-light" }, -- light
		},
	},
})
```

Variant names must start with the household name (`<household>` or `<household>-<suffix>`) —
that prefix is how lazyvimx figures out which household the current theme belongs to.

**Note:** lazyvimx highlight customizations only cover Catppuccin, Tokyo Night, and Nord.
Other themes would need their own overrides.

### Switching Manually

```vim
:colorscheme catppuccin-latte
:colorscheme tokyonight-storm
```

### Auto-switching with the System

Enabled by an override (part of `core.overrides`):

```lua
{ import = "lazyvimx.overrides.lazyvim.auto-switch-colorscheme-on-signal" }
```

The override subscribes to the `Signal` autocmd: for Neovim to switch the theme, an external
OS-theme watcher must send the process a signal (e.g. SIGUSR1). An example of such a watcher
for macOS is [ThemeSwitcher](https://github.com/aimuzov/dotfiles/tree/main/private_Library/ThemeSwitcher)
from the author's dotfiles.

## 🗂️ Buffer Groups

Grouping buffers in bufferline by lua patterns over the file path.

```lua
require("lazyvimx").setup({
	bufferline_groups = {
		["React"] = "%.tsx$",           -- by extension
		["Styles"] = "%.s?css$",
		["Tests"] = "%.test%.",         -- by a name fragment
		["Components"] = "components/", -- by directory
	},
})
```

Besides your groups there are always built-in ones: pinned buffers (with the  icon),
terminal buffers (term), and everything else (ungrouped).

Groups work through the `overrides/bufferline/add-groups.lua` override (part of
`core.overrides`).

## 🧩 Enabling Extras

### Way 1 — the UI

1. `:LazyExtras`
2. The lazyvimx section is marked with the 󰬟 icon
3. `x` — enable the selected extra
4. Restart Neovim

### Way 2 — imports in the config

```lua
-- lua/plugins/lazyvimx.lua
return {
	{ import = "lazyvimx.extras.ui.better-diagnostic" },
	{ import = "lazyvimx.extras.ui.winbar" },
	{ import = "lazyvimx.extras.motions.langmapper" },
}
```

### Way 3 — everything at once

```lua
{ import = "lazyvimx.extras.core.all" }
```

Or just the extras registry, without overrides and keymaps:

```lua
{ import = "lazyvimx.extras.core.extras" }
```

The list of all extras with descriptions is in [Extras](EXTRAS.md).

## ✍️ Vim Options

lazyvimx sets its options on the `LazyVimOptionsDefaults` event (see `boot.lua`).

### Indentation

```lua
vim.o.expandtab = false      -- tabs, not spaces
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
```

### Backups and Swap

```lua
vim.o.swapfile = false
vim.o.backup = true
vim.o.backupdir = "~/.local/state/nvim/backup/"
```

### UI Transparency

```lua
vim.o.pumblend = 15          -- completion menu
vim.o.winblend = 5           -- floating windows
```

### Timeouts

```lua
vim.o.timeout = true
vim.o.timeoutlen = 500       -- wait for a mapping continuation
vim.o.ttimeoutlen = 0        -- no wait for key codes
```

### Everything Else

```lua
vim.o.showmode = false       -- the statusline shows the mode
vim.o.showbreak = "↪"        -- line wrap marker
vim.o.conceallevel = 2
vim.o.smoothscroll = true
vim.o.autochdir = false
vim.o.spelllang = ""
vim.o.shell = vim.fn.getenv("SHELL")
vim.opt.listchars = { eol = " ", space = " ", tab = "  " }
vim.opt.fillchars:append({ diff = " ", eob = " " })
```

### Overriding Them

Put your values in `lua/config/options.lua` (LazyVim runs it after the defaults):

```lua
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
```

Or on the same event:

```lua
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimOptionsDefaults",
	callback = function()
		vim.o.expandtab = true
		vim.o.shiftwidth = 2
	end,
})
```

## 🔗 Integrations

### Chezmoi

After `:Lazy update` the `auto-apply-chezmoi-on-lazy-update` override (part of
`core.overrides`) runs:

```bash
chezmoi add ~/.config/nvim/lazy-lock.json ~/.config/nvim/lazyvim.json
```

The only requirement is the `chezmoi` binary. If it's not needed or not installed, nothing
happens.

### VSCode

When running inside VSCode (the vscode-neovim extension, `vim.g.vscode = true`) the
`overrides/lazyvim/vscode.lua` override kicks in automatically:

- the mode indicator is synced to the VSCode status bar (needs the `neovim-ui-indicator`
  extension)
- `<leader>cr` triggers VSCode's native rename
- `Snacks.terminal` is replaced with `LazyVim.terminal`
- `<leader>l` and `<leader>qq` are disabled

### macOS

- **OS theme** — `defaults read -g AppleInterfaceStyle` (for automatic colorscheme
  switching)
- **Trash** — deleting files in neo-tree goes through the `trash` utility if installed
  (`brew install trash`); otherwise it's a regular delete
- **Opening files** — the `open` command in neo-tree

## 🧠 Advanced Configuration

### Load Order

1. `boot.lua` — globals and the `LazyVimOptionsDefaults` subscription
2. LazyVim plugins
3. `require("lazyvimx").setup()` — config merge
4. The extras and overrides you imported
5. Your `lua/plugins/*.lua`

### Per-project Local Config

```lua
{ import = "lazyvimx.extras.perf.local-config" }
```

Then in the project root:

```lua
-- .nvim.lua or .config/nvim.lua
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
```

### Conditional Extras

```lua
return {
	{
		import = "lazyvimx.extras.ui.winbar",
		cond = function()
			return not vim.g.vscode
		end,
	},
}
```

### Overriding Keymaps

```lua
-- lua/plugins/keys.lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>\\", false }, -- turn off a lazyvimx keymap
			{ "<leader>|", "<cmd>vsplit<cr>", desc = "Vertical Split" },
		},
	},
}
```

### Selective Overrides

Instead of `core.overrides`, import categories individually:

```lua
return {
	{ import = "lazyvimx.overrides.lazyvim" },
	{ import = "lazyvimx.overrides.snacks" },
	-- skipping bufferline
	{ import = "lazyvimx.overrides.other" },
}
```

### Debugging the Configuration

```vim
" The current lazyvimx config
:lua vim.print(require("lazyvimx").config)

" Loaded extras modules
:lua vim.print(require("lazy.core.config").spec.modules)

" Is a particular extra enabled
:lua print(require("lazyvimx.util.general").has_extra("ui.winbar"))
```

## 🚑 When Something Doesn't Work

Typical problems — extras not visible in `:LazyExtras`, the theme not switching, buffer
groups not appearing — are covered in [Troubleshooting](TROUBLESHOOTING.md).

## 📚 See Also

- [Extras](EXTRAS.md) — the extras reference
- [API](API.md) — utilities
- [Architecture](ARCHITECTURE.md) — internals
