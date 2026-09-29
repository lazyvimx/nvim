# Keymaps

> [!TIP]
> **🇷🇺 Русская версия:** [KEYBINDINGS.ru.md](KEYBINDINGS.ru.md)

All custom lazyvimx keymaps.

## 📑 Table of Contents

- [How It Works](#⚙️-how-it-works)
- [Basic Operations](#🧰-basic-operations)
- [Files and Buffers](#🗂️-files-and-buffers)
- [Navigation and Motions](#🧭-navigation-and-motions)
- [Windows](#🪟-windows)
- [LSP and Code](#🧠-lsp-and-code)
- [Git](#🔀-git)
- [GitLab](#🦊-gitlab)
- [DAP (Debugging)](#🐞-dap-debugging)
- [Customization](#🎛️-customization)

## ⚙️ How It Works

Keymaps are enabled by the `core.keys` module (part of `core.all`):

```lua
{ import = "lazyvimx.extras.core.keys" }
```

Each keymap is bound to its plugin: if the plugin isn't installed (the corresponding extra
is off) — the keymap simply doesn't appear. The "Requires" column shows which extra brings
the plugin.

**Leader** is space (the LazyVim default). The source of truth is
[extras/core/keys.lua](../lua/lazyvimx/extras/core/keys.lua).

## 🧰 Basic Operations

| Keymap           | Mode    | Description                          | Requires  |
| ---------------- | ------- | ------------------------------------ | --------- |
| `d`              | n, v    | Delete without clobbering a register | core.keys |
| `<C-S-j>`        | n, i, v | Move the line/selection down         | core.keys |
| `<C-S-k>`        | n, i, v | Move the line/selection up           | core.keys |
| `<leader>\`      | n       | Split the window to the right        | core.keys |
| `<leader>ch`     | n       | Open a shell (cht.sh)                | core.keys |
| `<leader>ll`     | n       | Open the Lazy dashboard              | core.keys |
| `<leader>lx`     | n       | Open Lazy extras                     | core.keys |
| `<leader>uz`     | n       | Zen mode (zoom)                      | core.keys |
| `<leader>uq`     | n       | Open the dashboard                   | core.keys |
| `<leader><tab>r` | n       | Rename the tab                       | core.keys |

In VSCode the `<leader>\`, `<leader>ch`, `<leader>ll`, `<leader>lx` keymaps aren't created.

## 🗂️ Files and Buffers

| Keymap            | Mode | Description                    | Requires           |
| ----------------- | ---- | ------------------------------ | ------------------ |
| `<leader><space>` | n    | Find files (smart)             | core.keys          |
| `<leader>fy`      | n    | The Yazi file manager          | ui.better-explorer |
| `<leader>fY`      | n    | Yazi (the previous session)    | ui.better-explorer |
| `<leader>bg`      | n, v | Pick a buffer                  | core.keys          |
| `<leader>bm[`     | n    | Move the buffer back           | core.keys          |
| `<leader>bm]`     | n    | Move the buffer forward        | core.keys          |
| `<leader>b<tab>`  | n    | Move the buffer to another tab | buf.tab-scope      |
| `H`               | n    | Previous buffer                | core.keys          |
| `L`               | n    | Next buffer                    | core.keys          |

## 🧭 Navigation and Motions

| Keymap    | Mode    | Description                        | Requires                          |
| --------- | ------- | ---------------------------------- | --------------------------------- |
| `[x`      | n       | Jump to the treesitter context     | LazyVim ui.treesitter-context     |
| `w`       | n, o, x | Word forward (by subwords)         | motions.better-move-between-words |
| `b`       | n, o, x | Word backward (by subwords)        | motions.better-move-between-words |
| `e`       | n, o, x | End of word (by subwords)          | motions.better-move-between-words |
| `cw`      | n       | Change word (by subwords)          | motions.better-move-between-words |
| `<C-f>`   | i       | Word forward in insert             | motions.better-move-between-words |
| `<C-b>`   | i       | Word backward in insert            | motions.better-move-between-words |
| `<C-A-h>` | n       | Node to the left (treewalker)      | motions.sibling-move              |
| `<C-A-l>` | n       | Node to the right (treewalker)     | motions.sibling-move              |
| `<C-A-j>` | n       | Node below (treewalker)            | motions.sibling-move              |
| `<C-A-k>` | n       | Node above (treewalker)            | motions.sibling-move              |
| `<C-A-.>` | n       | Swap the node with the lower one   | motions.sibling-move              |
| `<C-A-,>` | n       | Swap the node with the upper one   | motions.sibling-move              |

## 🪟 Windows

Resizing works for edgy sidebars too — the new size is remembered (see
[util.layout](API.md#🪟-utillayout)).

| Keymap      | Mode    | Description                | Requires  |
| ----------- | ------- | -------------------------- | --------- |
| `<C-Up>`    | n, v, t | Increase the window height | core.keys |
| `<C-Down>`  | n, v, t | Decrease the window height | core.keys |
| `<C-Left>`  | n, v, t | Decrease the window width  | core.keys |
| `<C-Right>` | n, v, t | Increase the window width  | core.keys |

## 🧠 LSP and Code

| Keymap       | Mode | Description                             | Requires                         |
| ------------ | ---- | --------------------------------------- | -------------------------------- |
| `gr`         | n    | References in a peek window (glance)    | ui.peek-preview                  |
| `<leader>cr` | n    | Rename with a preview (live-rename)     | ui.better-live-rename            |
| `<leader>cw` | n, v | Wrap in an Emmet abbreviation           | coding.emmet                     |
| `<C-.>`      | n    | Swap the node with the right one        | motions.sibling-swap             |
| `<C-,>`      | n    | Swap the node with the left one         | motions.sibling-swap             |
| `<leader>ct` | n    | Split/join a block (automatically)      | motions.splitting-joining-blocks |
| `<leader>c\` | n    | Split a block                           | motions.splitting-joining-blocks |
| `<leader>cj` | n    | Join a block                            | motions.splitting-joining-blocks |
| `<leader>ac` | n, x | Copy the cursor/selection position      | core.overrides (sidekick)        |
| `zF`         | x    | Fold the selection into a label         | ui.inline-fold                   |
| `zF`         | n    | Unfold the inline fold under the cursor | ui.inline-fold                   |

`<leader>ac` puts a reference like `@file :L10:C5` on the clipboard — handy for prompts to
AI agents.

## 🔀 Git

| Keymap        | Mode | Description                          | Requires        |
| ------------- | ---- | ------------------------------------ | --------------- |
| `<leader>ghP` | n    | Preview the hunk                     | core.keys       |
| `go`          | n    | Open the file in a browser (GBrowse) | git.fugitive    |
| `go`          | v    | Open the range in a browser          | git.fugitive    |
| `gx`          | n    | Open a remote repository             | git.remote-view |
| `gX`          | n    | Enter `author/repo` and open         | git.remote-view |

## 🦊 GitLab

**Requires**: the `git.gitlab` extra.

| Keymap        | Mode | Description                       |
| ------------- | ---- | --------------------------------- |
| `<leader>gLr` | n    | Review the MR                     |
| `<leader>gLe` | n    | Choose an MR                      |
| `<leader>gLs` | n    | MR summary                        |
| `<leader>gLd` | n    | The discussion tree               |
| `<leader>gLc` | n    | Comment                           |
| `<leader>gLc` | v    | Comment on multiple lines         |
| `<leader>gLC` | v    | Comment with a suggested change   |
| `<leader>gLn` | n    | Note                              |
| `<leader>gLm` | n    | To the discussion from a diagnostic |
| `<leader>gLA` | n    | Approve                           |
| `<leader>gLR` | n    | Revoke the approve                |
| `<leader>gLM` | n    | Merge                             |
| `<leader>gLp` | n    | Pipeline                          |
| `<leader>gLo` | n    | Open in a browser                 |

## 🐞 DAP (Debugging)

**Requires**: `dap.vscode-js` (or another DAP extra bringing `nvim-dap`).

| Keymap  | Mode | Description |
| ------- | ---- | ----------- |
| `<F5>`  | n    | Continue    |
| `<F10>` | n    | Step over   |
| `<F11>` | n    | Step into   |
| `<F12>` | n    | Step out    |

## 🎛️ Customization

### Disabling a Keymap

```lua
-- lua/plugins/keys.lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>cr", false },
		},
	},
}
```

### Overriding

```lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename (default)" },
		},
	},
}
```

### Adding Your Own

```lua
-- lua/config/keymaps.lua
vim.keymap.set("n", "<leader>xx", "<cmd>MyCommand<cr>", { desc = "My Command" })
```

### The Russian Layout

With the `motions.langmapper` extra every keymap works on the Russian layout too — no
switching needed:

```lua
{ import = "lazyvimx.extras.motions.langmapper" }
```

### Conflicts

```vim
" Who took the keymap
:verbose map <leader>cr

" All mappings of a key
:map <leader>cr
```

Every keymap shows up in which-key: press leader and wait, or `:WhichKey <leader>g`.

## 📚 See Also

- [LazyVim Keymaps](https://www.lazyvim.org/keymaps) — the base keymaps
- [Extras](EXTRAS.md) — the extras reference
- [Troubleshooting](TROUBLESHOOTING.md#⌨️-keymaps) — if keymaps don't work
