-- Minimal lazyvimx Configuration
-- Just the essentials with plugin overrides

local lazy_opts = {
	spec = {
		-- lazyvimx with boot import
		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },

		-- Only core overrides (no extras)
		{ import = "lazyvimx.extras.core.overrides" },

		-- Your custom plugins
		{ import = "plugins" },
	},

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
