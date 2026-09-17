-- Full-Featured lazyvimx Configuration
-- Everything enabled for maximum productivity

local lazy_opts = {
	spec = {
		-- lazyvimx with boot import and configuration
		{
			"lazyvimx/nvim",
			name = "lazyvimx",
			import = "lazyvimx.boot",
			opts = {
				colorscheme = "catppuccin",
				colorscheme_households = {
					-- [1] — dark flavors, [2] — light flavors
					catppuccin = {
						{ "catppuccin-macchiato", "catppuccin-mocha" },
						{ "catppuccin-latte" },
					},
					tokyonight = {
						{ "tokyonight-storm", "tokyonight-moon" },
						{ "tokyonight-day" },
					},
				},
				bufferline_groups = {
					["React"] = "%.tsx$",
					["Tests"] = "%.test%.",
					["Styles"] = "%.s?css$",
				},
			},
		},

		-- Enable ALL lazyvimx features
		{ import = "lazyvimx.extras.core.all" },

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
