local function insert_extras()
	table.insert(require("lazyvim.util.extras").sources, {
		name = "󰬟",
		desc = "Some recipes (extras) for enhance lazyvim",
		module = "lazyvimx.extras",
	})
end

local function set_colorscheme(_, opts)
	opts.colorscheme = require("lazyvimx.util.general").get_flavor()
end

local function set_global()
	vim.g.lazyvim_check_order = false
	vim.g.xtras_prios = {}
	vim.g.lazyvim_explorer = "neo-tree"

	return false
end

local function vimopts_set_values()
	vim.o.autochdir = false
	vim.o.swapfile = false
	vim.o.backup = true
	vim.o.backupdir = vim.fn.getenv("HOME") .. "/.local/state/nvim/backup/"
	vim.o.smoothscroll = true
	vim.o.conceallevel = 2

	vim.o.expandtab = false
	vim.o.smarttab = true
	vim.o.shiftwidth = 4
	vim.o.tabstop = 4
	vim.o.softtabstop = 4
	vim.o.autoindent = true

	vim.o.pumblend = 15
	vim.o.winblend = 5

	vim.o.timeout = true
	vim.o.timeoutlen = 500
	vim.o.ttimeoutlen = 0
	vim.o.showmode = false

	vim.o.showbreak = "↪"
	vim.opt.listchars = { eol = " ", space = " ", tab = "  " }
	vim.opt.fillchars:append({ diff = " ", eob = " " })

	vim.o.spelllang = ""
	vim.o.shell = vim.fn.getenv("SHELL")
end

local function vimopts_create_autocmd()
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimOptionsDefaults",
		once = true,
		callback = vimopts_set_values,
	})
end

local function update_root_lsp_ignore()
	vim.g.root_lsp_ignore = {
		unpack(vim.g.root_lsp_ignore or {}),
		"eslint",
	}
end

local function has_plugins_dir()
	local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"

	if vim.fn.isdirectory(plugins_dir) == 1 then
		local files = vim.fn.glob(plugins_dir .. "/*.lua", 0, 1)

		return #files > 0
	end

	return false
end

return {
	{ import = "system.plug", enabled = set_global },
	{ import = "system.plug", enabled = vimopts_create_autocmd },

	{ "LazyVim/LazyVim", branch = "main" },
	{ "LazyVim/LazyVim", opts = update_root_lsp_ignore },
	{ "LazyVim/LazyVim", opts = insert_extras },
	{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
	{ "LazyVim/LazyVim", opts = set_colorscheme },

	{ "lazyvimx/nvim", name = "lazyvimx", dependencies = { "LazyVim/LazyVim" }, vscode = true, config = true },

	{ import = "plugins", enabled = has_plugins_dir },
}
