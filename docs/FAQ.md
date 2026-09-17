# Frequently Asked Questions (FAQ)

> [!TIP]
> **🇷🇺 Русская версия:** [FAQ.ru.md](FAQ.ru.md)

## 📑 Table of Contents

- [General](#💬-general)
- [Installation](#📦-installation)
- [Configuration](#⚙️-configuration)
- [Extras](#🧩-extras)
- [Performance](#⚡-performance)
- [Integrations](#🔗-integrations)

## 💬 General

### What is lazyvimx?

An enhancement layer for [LazyVim](https://github.com/LazyVim/LazyVim): 50 optional extras
and 39 plugin overrides. LazyVim stays the foundation, lazyvimx adds interface and workflow
polish — and only what you've enabled.

### How is lazyvimx different from LazyVim?

lazyvimx **extends** LazyVim, it doesn't replace it:

- **LazyVim** — the foundation: a well-thought-out base Neovim configuration
- **lazyvimx** — the layer on top: UI polish, navigation, git workflow, the Russian layout

Everything LazyVim can do keeps working as before.

### Can I use lazyvimx without LazyVim?

No. lazyvimx is built on top of LazyVim and requires it — it's not a standalone
configuration.

### How stable is it?

The project follows semver and is updated regularly. Every extra is optional — what's not
enabled has no effect.

### How do I update?

Like regular plugins:

```vim
:Lazy update
```

The change history is in the [Changelog](../CHANGELOG.md).

## 📦 Installation

### Minimum Requirements

- **Neovim** >= 0.10.0
- **Git** (for lazy.nvim)

LazyVim installs automatically.

### How do I install it?

See the [Quick Start](../README.md#quick-start) in the README: create an `init.lua` with the
`lazyvimx.boot` import, start Neovim — the rest happens on its own.

### Can I migrate from an existing LazyVim config?

Yes, lazyvimx is compatible with existing LazyVim configurations:

1. Make a backup: `cp -r ~/.config/nvim ~/.config/nvim.backup`
2. Replace the LazyVim spec in `init.lua` with the `lazyvimx.boot` import
3. Restart Neovim

Your plugins in `lua/plugins/` keep working.

### Where do I put my own plugins?

Same place as in LazyVim — `~/.config/nvim/lua/plugins/`:

```lua
-- ~/.config/nvim/lua/plugins/my-plugin.lua
return {
	"author/plugin-name",
	opts = {},
}
```

## ⚙️ Configuration

### How do I configure lazyvimx?

Via `opts` in the plugin spec or `setup()`:

```lua
require("lazyvimx").setup({
	colorscheme = "catppuccin",
	bufferline_groups = {
		["React"] = "%.tsx$",
	},
})
```

All the options are in [Configuration](CONFIGURATION.md).

### How do I change the colorscheme?

```lua
require("lazyvimx").setup({ colorscheme = "tokyonight" })
```

Or directly: `:colorscheme tokyonight-storm`.

### How does theme auto-switching work?

lazyvimx detects the system's light/dark mode and picks the matching variant from the
theme's "household" (`colorscheme_households`). Switching on the fly needs an external
watcher that sends the Neovim process a signal — details in
[Configuration](CONFIGURATION.md#🎨-colorschemes).

### Can I disable some of the overrides?

Yes — instead of `core.overrides`, import categories selectively:

```lua
{ import = "lazyvimx.overrides.lazyvim" },
{ import = "lazyvimx.overrides.snacks" },
-- skipping bufferline
{ import = "lazyvimx.overrides.other" },
```

## 🧩 Extras

### What is an extra?

An optional module with a ready-made setup for one feature. For example:

- `ui.better-diagnostic` — single-line diagnostics at the cursor
- `motions.langmapper` — the Russian layout
- `git.gitlab` — GitLab MR review

All 50 are in [Extras](EXTRAS.md).

### How do I enable an extra?

**Via the UI** (recommended): `:LazyExtras`, the lazyvimx section with the 󰬟 icon, `x` to
enable, restart.

**Via the config:**

```lua
{ import = "lazyvimx.extras.ui.better-diagnostic" },
```

**Everything at once:**

```lua
{ import = "lazyvimx.extras.core.all" },
```

### Do I need to enable everything?

No. Reasonable setups:

- minimal — just `core.overrides`
- full — `core.all`
- your own — the overrides plus individual extras to taste

### Which extras should I start with?

- `core.overrides` — polish for every plugin
- `ui.better-diagnostic` — readable diagnostics
- `ui.better-float` — one window style
- `motions.langmapper` — if you type on a Russian layout
- `git.conflicts` — if conflicts happen

### Can I write my own extra?

Yes — it's a regular file with a lazy.nvim spec, see
[Architecture](ARCHITECTURE.md#🧱-extending) and [Contributing](../CONTRIBUTING.md).

## ⚡ Performance

### Is lazyvimx slow?

No. Everything loads lazily, and disabled extras don't exist for lazy.nvim at all. The
startup impact is minimal and grows only with the number of enabled extras.

### How do I speed things up?

1. Enable only what you need — `core.overrides` instead of `core.all`
2. Profile: `:Lazy profile` and `nvim --startuptime startup.log`
3. `perf.stop-inactive-lsp` and `buf.delete-inactive` clean up memory in long sessions

## 🔗 Integrations

### Does it work with VSCode Neovim?

Yes, the VSCode mode turns on automatically (`vim.g.vscode`): mode indicator sync, adjusted
keymaps, native rename. A ready-made example is
[examples/vscode-user](../examples/vscode-user/).

### Does it work with chezmoi?

Yes: after `:Lazy update` the lock files are added to chezmoi automatically, as long as the
binary is installed. Details — in [Configuration](CONFIGURATION.md#chezmoi).

### Does it work on Linux/Windows?

It does. Notes:

- system theme detection exists on macOS and Linux (gsettings); not on Windows
- the trash in neo-tree goes through the `trash` utility (present — used, absent — a regular
  delete)

### Can I plug in my own colorscheme?

Yes — add your household to `colorscheme_households`
([format](CONFIGURATION.md#🎨-colorschemes)). But lazyvimx custom highlights only exist for
Catppuccin, Tokyo Night, and Nord.

## ❓ Still Have Questions?

- 📖 [Documentation](./)
- 🔧 [Troubleshooting](TROUBLESHOOTING.md)
- 💬 [Telegram discussion](https://t.me/aimuzov_dotfiles)
- 🐛 [Report an issue](https://github.com/lazyvimx/nvim/issues)
