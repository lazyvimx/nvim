# Troubleshooting

> [!TIP]
> **🇷🇺 Русская версия:** [TROUBLESHOOTING.ru.md](TROUBLESHOOTING.ru.md)

Typical problems and ways to fix them.

## 📑 Table of Contents

- [Installation](#📦-installation)
- [Extras](#🧩-extras)
- [Colorschemes](#🎨-colorschemes)
- [Performance](#⚡-performance)
- [Keymaps](#⌨️-keymaps)
- [LSP](#🧠-lsp)
- [macOS](#🍎-macos)
- [Getting Help](#🆘-getting-help)

## 📦 Installation

### lazyvimx extras aren't visible in :LazyExtras

1. Check the boot module import:

   ```lua
   { "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" }
   ```

2. Check whether the extras source is registered (there should be an entry with the 󰬟
   icon):

   ```vim
   :lua vim.print(require("lazyvim.util.extras").sources)
   ```

3. Restart Neovim and update the plugins: `:Lazy update`.

### Plugins won't install

1. Check the version: `:version` — Neovim >= 0.10.0 is required
2. Look at the log: `:Lazy log`
3. As a last resort — reinstall the plugins from scratch:

   ```bash
   rm -rf ~/.local/share/nvim/lazy
   nvim
   ```

### setup() options are ignored

1. Options must land in the `"lazyvimx"` plugin spec (the `opts` field) or an
   explicit `require("lazyvimx").setup()` call
2. Check the merge result:

   ```vim
   :lua vim.print(require("lazyvimx").config)
   ```

## 🧩 Extras

### An extra is enabled but doesn't work

1. Restart Neovim — extras apply on startup
2. Check the dependencies. Some extras require others:
   - `git.gitlab` → `ui.diff-view`
   - `dap.vscode-js` → the LazyVim `dap.core` extra
   - `test.jest` → the LazyVim `test.core` extra
   - `ui.better-progressbar` → the Ghostty terminal
3. Look at the warnings: `:messages` (search for "Missing extra")
4. Check that the extra is actually loaded:

   ```vim
   :lua print(require("lazyvimx.util.general").has_extra("ui.winbar"))
   ```

### Buffer groups don't appear

1. The `add-groups` override is needed (part of `core.overrides`):

   ```lua
   { import = "lazyvimx.extras.core.overrides" }
   ```

2. Check the config:

   ```vim
   :lua vim.print(require("lazyvimx").config.bufferline_groups)
   ```

3. Test the pattern on the current file:

   ```vim
   :lua print(vim.fn.expand("%"):match("%.tsx$"))
   ```

### symbol-usage counters aren't showing

1. The LSP must be running: `:LspInfo`
2. The `ui.symbol-usage` extra is enabled: `:LazyExtras`
3. In insert mode the counters are hidden on purpose (`ui.better-insert-mode`)
4. Restart the LSP: `:LspRestart`

## 🎨 Colorschemes

### The theme doesn't follow the system

1. Is the override on? You need `core.overrides` (or specifically
   `overrides.lazyvim.auto-switch-colorscheme-on-signal`)
2. Switching fires on the `Signal` autocmd — the Neovim process must receive a signal from
   an external OS-theme watcher (see
   [Configuration](CONFIGURATION.md#auto-switching-with-the-system))
3. Check the theme detection:

   ```vim
   :lua print(require("lazyvimx.util.general").theme_is_dark())
   ```

4. A manual check:

   ```vim
   :lua vim.api.nvim_exec_autocmds("Signal", {})
   ```

### The wrong theme variant gets picked

1. Look at the households:

   ```vim
   :lua vim.print(require("lazyvimx").config.colorscheme_households)
   ```

2. What the variant selection returns:

   ```vim
   :lua print(require("lazyvimx.util.general").get_flavor())
   ```

3. If `perf.restore-last-colorscheme` is enabled — the last used variant gets restored;
   switch the theme manually and the choice will be remembered

### A custom colorscheme doesn't apply

1. The theme must be installed as a plugin (`lazy = false, priority = 1000`)
2. The household is added to `colorscheme_households`, and variant names start with the
   household name
3. lazyvimx custom highlights don't extend to third-party themes

## ⚡ Performance

### Slow startup

1. Profile:

   ```bash
   nvim --startuptime startup.log
   sort -nk2 startup.log | tail -20
   ```

   and `:Lazy profile`

2. Enable fewer extras: `core.overrides` + targeted imports instead of `core.all`

### High memory usage

1. `{ import = "lazyvimx.extras.perf.stop-inactive-lsp" }` — stopping inactive LSPs
2. `{ import = "lazyvimx.extras.buf.delete-inactive" }` — closing old buffers

### A laggy interface

1. Snacks animations are already off via the `disable-animation` override (part of
   `core.overrides`)
2. Try turning off the heavier UI extras: `ui.scrollbar`, `ui.symbol-usage`,
   `ui.highlighted-colors`
3. Check the terminal itself — rendering speed varies a lot

## ⌨️ Keymaps

### lazyvimx keymaps don't work

1. Is `core.keys` enabled?

   ```lua
   { import = "lazyvimx.extras.core.keys" }
   ```

2. Keymaps are bound to plugins: no plugin (the extra is off) — no keymap. See the
   "Requires" column in [Keybindings](KEYBINDINGS.md)
3. Who took the key:

   ```vim
   :verbose map <leader>cr
   ```

4. Leader is space: `:echo mapleader`

### The Russian layout doesn't work

1. Is the extra enabled?

   ```lua
   { import = "lazyvimx.extras.motions.langmapper" }
   ```

2. Restart Neovim after enabling it
3. Check the mapping of a specific key:

   ```vim
   :verbose map ц
   ```

### A keymap conflict

Disable the lazyvimx keymap in your config:

```lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>cr", false },
		},
	},
}
```

## 🧠 LSP

### The LSP won't start

1. `:LspInfo` — client status
2. `:Mason` — is the server installed
3. `:LspLog` — the error log

### Diagnostics aren't displayed

1. With the `ui.better-diagnostic` extra the native virtual text is off — diagnostics show
   at the cursor as a single line
2. Check the configuration:

   ```vim
   :lua vim.print(vim.diagnostic.config())
   ```

### No LSP or autoformat on an sshfs mount

That's by design: the `buf.remote-mounts` extra disables the LSP, autoformat, swap, and undo
for buffers under `~/mnt` — for speed and to keep file permissions intact. Not what you
want — disable the extra.

## 🍎 macOS

### The system theme isn't detected

1. Check the command:

   ```bash
   defaults read -g AppleInterfaceStyle
   ```

   In dark mode it returns "Dark", in light mode — an error (that's normal)

2. Check from Neovim:

   ```vim
   :lua print(require("lazyvimx.util.general").theme_is_dark())
   ```

### Files skip the trash

Install the `trash` utility:

```bash
brew install trash
```

Without it neo-tree deletes files the regular way.

### Chezmoi sync doesn't fire

1. Is the binary installed? `which chezmoi`
2. The sync fires on the `LazyUpdate` event — that is, after `:Lazy update`
3. The override is part of `core.overrides`; individually:

   ```lua
   { import = "lazyvimx.overrides.lazyvim.auto-apply-chezmoi-on-lazy-update" }
   ```

## 🆘 Getting Help

1. [FAQ](FAQ.md)
2. [GitHub Issues](https://github.com/lazyvimx/nvim/issues)
3. [Telegram discussion](https://t.me/aimuzov_dotfiles)

In an issue include:

- the Neovim version (`:version`) and the OS
- reproduction steps on a minimal config:

  ```lua
  local lazy_opts = {
  	spec = {
  		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },
  		{ import = "lazyvimx.extras.core.all" },
  	},
  }
  ```

- error messages: `:Lazy log`, `:messages`

## 🐞 Debugging

```vim
" Spec modules
:lua vim.print(require("lazy.core.config").spec.modules)

" The lazyvimx config
:lua vim.print(require("lazyvimx").config)

" Profiling
:Lazy profile

" Integration autocmds
:autocmd Signal
:autocmd User LazyUpdate
```
